/*
* PIC18F4520 MMC/SD AUDIO RECORDER
* Author: Dat Tran Quoc Le
*/

/*
Git command
git add *
git add filename.ext
git commit -m "User comment"
git push -u origin master // push from local to server
git pull // pull from server to local
git commit -a -m "..." // commit all
// drop local changes and commits, fetch the latest history from the server
git fetch origin
git reset --hard origin/master
// create a new branch and switch to to it
git checkout -b <branch_name>
// switch back to master
git checkout master
// delete the branch
git branch -d <branch_name>
// push branch to server
git push origin branch
*/

/*
* TODO::
* 1. Luu du lieu thanh tung track, track list (dung EEPROM)
* 2. Lua chon tan so lay mau
* 3. Data reject handling
* 4. Noise supression
* 5. Check if the card address argument is byte-address or block-address?!!!
* >>> block for SDC v2, byte otherwise
* 6. !Write track metadata to MMC/SD, not EEPROM!
* 7. Rewrite MMC/SD Init fucntion to support more card
* 8. Add feature to keep or discard a track when recorded successful.
* 9. Write an UI that ask for which track to play.
* >>> Done, debug it!
* 10. Create a header files that contain information string constant
* 11. Write handle when play the whole card in readMultipleBlock()
* 12. Display sampling period on oscilloscope.
*/

#include <stdint.h>
//#include "mmc.h"
#include "string.h"
#include "soundrec.h"
#include "global.h"
#include "adc.h"

#define _UART_GUI_
//#define DEBUG_PLAY

/**
* VARIABLE DECLARATION
*/
volatile uint8_t buffer0[512];			/* Buffers for ADC result storage */
volatile uint8_t buffer1[512];
static volatile uint8_t *ptr;
static volatile uint16_t ptrIndex = 0;
volatile uint8_t currentBuffer = 0;
volatile uint8_t bufferFull = 0;

//volatile unsigned char samplingRate = 1;
volatile unsigned int mode = 0;
volatile uint8_t text[10];

volatile uint32_t sectorIndex = 0;
volatile uint8_t adcResult = 0;

sfr sbit Mmc_Chip_Select at LATC2_bit;
sfr sbit Mmc_Chip_Select_Direction at TRISC2_bit;

/* Debug variables */
volatile uint32_t adcCount = 0;


/**
* FUNCTION DECLARATION
*/
void mmcBuiltinInit(void);
void timer1Config(void);
void pwmCOnfig(void);
void pwmStart(void);
void pwmStop(void);
void pwmChangeDutyCycle(uint8_t dutyCycle);


char* codeToRam(const char* ctxt)
{
	static char txt[20];
	char i;
	for(i =0; txt[i] = ctxt[i]; i++);

	return txt;
}

void main()
{
	unsigned char lastMode;
	uint16_t i;
	
	/*---------------- Setup Port B weak pull-up ----------------------------- */
	INTCON2 &= ~(1 << 7); // nRBPU = 0

	ptr = &buffer0[0];
	currentBuffer = 0;
	adcInit();
	Delay_ms(100);

	/**** END ADC INIT ****/
	
	/*---------------- Setup I/O ---------------------------------------------*/
	TRISD = 0x00; // output for DAC0808
	//TRISB &= ~((1 << 0) + (1 << 1));
	TRISB = 0xc0; // B0, B1 input; remains output
	TRISC &= ~(1 << 2); // output for CS pin

	UART1_Init(9600);
	UWR(codeToRam(uart_welcome));
	mmcBuiltinInit();
	specialEventTriggerSetup();
	timer1Config();
	LATD7_bit = 0;
	
#ifdef DEBUG_PLAY
	pwmConfig();
	UWR(codeToRam(uart_debugRead));
#endif
	
	INTCON |= (1 << GIE) | (1 << PEIE);	/* Global interrupt */

	for (;;)        					/* Repeat forever */
	{
		while (SLCT != 0)
		{
		}
#ifdef _UART_GUI_
		UWR(codeToRam(uart_menu));
		
		while (OK)	/* OK not pressed */
		{
			if (!SLCT)	/* SLCT */
			{
				Delay_ms(300);
				mode++;
				if (mode == 5)
				{
					mode = 1;
				}
			}

			if ((mode == 1) & (lastMode != mode))
			{
				UWR(codeToRam(uart_record));
			}
			else if ((mode == 2) & (lastMode != mode))
			{
				UWR(codeToRam(uart_play));
			}
			else if ((mode == 3) & (lastMode != mode))
			{
				UWR(codeToRam(uart_trackList));
			}
			else if ((mode == 4) & (lastMode != mode))
			{
				UWR(codeToRam(uart_changeSampleRate));
			}
			
			lastMode = mode;					
		}
		
		/* Record mode */
		if (mode == 1)
		{
			/* Write routine */
			UWR(codeToRam(uart_writing));
			ptr = buffer0;
			ptrIndex = 0;
			sectorIndex = 0;
			bufferFull = 0;
			
			T1CON = (1 << TMR1ON);
			while (SLCT)				/* Wait until SLCT pressed */
			{			
				if (bufferFull == 1)
				{
				bufferFull = 0;
					if (currentBuffer)	/* Write buffer 0 */
					{
						if (Mmc_Write_Sector(sectorIndex++, buffer0) != 0)
						{
							UWR(codeToRam(uart_errorWrite));
						}
					}
					else				/* Write buffer 1 */
					{
						if (Mmc_Write_Sector(sectorIndex++, buffer1) != 0)
						{
							UWR(codeToRam(uart_errorWrite));
						}
					}
				}
			}
			T1CON &= ~(1 << TMR1ON);
			Delay_ms(500);
			
			/* Write complete message */
			intToStr(sectorIndex, text);
			UWR(codeToRam(uart_done));
			UWR(text);
			intToStr(adcCount, text);
			UWR(text);
		}

		/* Play mode */
		else if (mode == 2) 
		{
			/* Read routine */
			UWR(codeToRam(uart_reading));
			ptr = buffer0;
			ptrIndex = 0;
			sectorIndex = 0;
			bufferFull = 0;
			currentBuffer = 0;
			
			/* Read the first sector to the buffer */
			if (Mmc_Read_Sector(sectorIndex, buffer0) != 0)
			{
				UWR(codeToRam(uart_initReadError));
			}
			
			/* Start the timer1 */
			T1CON |= (1 << TMR1ON);
#ifdef DEBUG_PLAY
			/* Start the PWM module */
			pwmStart();
#endif
			/* Reading loop */
			while (SLCT)				/* Wait until SLCT pressed */
			{
				if (bufferFull == 1)
				{
				bufferFull = 0;
					if (currentBuffer)	/* Read buffer 0 */
					{
						if (Mmc_Read_Sector(sectorIndex++, buffer0) != 0)
						{
							UWR(codeToRam(uart_errorRead));
						}
					}
					else				/* Write buffer 1 */
					{
						if (Mmc_Read_Sector(sectorIndex++, buffer1) != 0)
						{
							UWR(codeToRam(uart_errorRead));
						}
					}
				}
			}
			
			/* Stop the timer1 */
			T1CON &= ~(1 << TMR1ON);
#ifdef DEBUG_PLAY
			/* Stop the PWM module */
			pwmStop();
#endif
			Delay_ms(500);
			
			UWR(codeToRam(uart_done));
		}
		
		/* Test read mode */
		else if (mode == 3)
		{
			/* Empty the buffer */
			for (i = 0; i < 512; i++)
			{
				buffer0[i] = 0;
				buffer1[i] = 0;
			}
			
			/* Load the data to buffers */
			Mmc_Read_Sector(5, buffer0);
			Mmc_Read_Sector(10, buffer1);
			
			/* Print the buffer to the screen */
			for (i = 0; i < 512; i++)
			{
				intToStr(buffer0[i], text);
				UWR(text);
			}
		}
		
		mode == 1;
		
#endif
	}
}

void mmcBuiltinInit(void)
{
	/* Init the SPI module with fOSC/64 */
	SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE,\
	_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	
	/* Init the MMC/SD */
	while (MMC_Init() != 0)
	{
	}
	
	/* Boost the SPI clock speed to fOSC/4 */
	SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE,\
	_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
}

void interrupt()
{
	if (PIR1.TMR1IF == 1)
	{
		/* Clear the interrupt flag */
		PIR1.TMR1IF = 0;
		
		/* Load a new timer cycle */
		/* For 8kHz: 0xfd8e
			For 16kHz: 0xfec7*/
		TMR1H = 0xfe;
		TMR1L = 0xc7;
		
		if (mode == 1)					/* Record mode */
		{
			/* Trigger the A/D conversion */
			GO_bit = 1;
		}
		
		else if (mode == 2)				/* Play mode */
		{
#ifdef DEBUG_PLAY
			/* Change the PWM duty cycle */
			CCPR2L = *(ptr + (ptrIndex++));
#else
			/* Send data to the DAC */
			DACOUT = *(ptr + (ptrIndex++));
#endif
			
			/* Swap the buffer */
			if (ptrIndex == 512)					
			{
				ptrIndex = 0;
				bufferFull = 1;
				if (currentBuffer == 0)
				{
					ptr = buffer1;
					currentBuffer = 1;
				}
				else
				{
					ptr = buffer0;
					currentBuffer = 0;
				}
			}
		}
	}

	if (PIR1 & (1 << ADIF)) 
	{
		/* Clear the interrupt flag */
		PIR1 &= ~(1 << ADIF);
		
		/* Buffer the result */
		adcResult = ADRESH;
		/* Move the result to buffer */
		*(ptr + (ptrIndex++)) = adcResult;
		
		/* Swap the buffer */
		if (ptrIndex == 512)					
		{
			ptrIndex = 0;
			bufferFull = 1;
			if (currentBuffer == 0)
			{
				ptr = buffer1;
				currentBuffer = 1;
			}
			else
			{
				ptr = buffer0;
				currentBuffer = 0;
			}
		}
	}
}

/**
* Config timer1 for sampling interrupt
*/
void timer1Config(void)
{
	PIE1 = (1 << TMR1IE);
	
	TMR1H = 0xfe;
	TMR1L = 0xc7;
}

/**
* Setup PWM module for debug output using CCP2 module
* CCP2 output is RB3, need to be configured via configuration bits
*/
void pwmConfig(void)
{
	PR2 = 77; 							/* 16.025 kHz */
	TRISB &= ~(1 << RB3);				/* Output for PWM */
	CCPR2L	= 128;						/* Initial duty cycle is 0 */
	T2CON = (1 << TMR2ON);				/* Enable timer 2 */
}

/**
* Start the PWM module
*/
void pwmStart(void)
{
	CCP2CON = (1 << CCP2M3) | (1 << CCP2M2);	/* PWM mode */
}

/**
* Stop thw PWM module
*/
void pwmStop(void)
{
	CCP2CON = 0;
}

/**
* Change the duty cycle of the PWM module
*/
void pwmChangeDutyCycle(uint8_t dutyCycle)
{
	CCPR2L = dutyCycle;
}