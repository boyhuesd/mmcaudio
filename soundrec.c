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
#include "string.h"
#include "soundrec.h"
#include "global.h"
#include "adc.h"
#include "track.h"

#define _UART_GUI_ 0
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

volatile uint8_t text[10];

volatile uint32_t sectorIndex = 0;
volatile uint8_t adcResult = 0;

/*---- Variables for hardware timing -----------------------------------------*/
static volatile uint8_t samplingRate = _16KHZ;
static volatile uint8_t timerH = _16KHZ_HIGHBYTE;
static volatile uint8_t timerL = _16KHZ_LOWBYTE;

sfr sbit Mmc_Chip_Select at LATC2_bit;
sfr sbit Mmc_Chip_Select_Direction at TRISC2_bit;


/*--------- LCD Pin definitions ----------------------------------------------*/
sbit LCD_RS at RB7_bit;
sbit LCD_EN at RB6_bit;
sbit LCD_D4 at RB5_bit;
sbit LCD_D5 at RB4_bit;
sbit LCD_D6 at RB3_bit;
sbit LCD_D7 at RB2_bit;

sbit LCD_RS_Direction at TRISB7_bit;
sbit LCD_EN_Direction at TRISB6_bit;
sbit LCD_D4_Direction at TRISB5_bit;
sbit LCD_D5_Direction at TRISB4_bit;
sbit LCD_D6_Direction at TRISB3_bit;
sbit LCD_D7_Direction at TRISB2_bit;

/**
* FUNCTION DECLARATION
*/
void mmcBuiltinInit(void);
void timer1Config(void);
void pwmConfig(void);
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
	unsigned int mode = 0;
	uint8_t temp;
	uint32_t trackFirstSector;
	uint8_t totalTrack;
	struct songInfo trackInfo;
	
	/*---------------- Setup Port B weak pull-up ----------------------------- */
	INTCON2 &= ~(1 << 7); // nRBPU = 0

	ptr = &buffer0[0];
	currentBuffer = 0;
	adcInit();
	Delay_ms(100);

	
	/*---------------- Setup I/O ---------------------------------------------*/
	TRISD = 0x00; 							// Output for DAC0808
	TRISB = (1 << RB0) | (1 << RB1); 		// B0, B1 input; remains output
	TRISC &= ~(1 << 2); 					// Output for CS pin
	
	/*------------ Test code for DAC0808 -------------------------------------*/
	LATD = 0x40;

	/*------------ Welcome message -------------------------------------------*/
#if _UART_GUI
	UART1_Init(9600);
	UWR(codeToRam(uart_welcome));
#else
	Lcd_Init();								// Init LCD for display
	Lcd_Cmd(_LCD_CLEAR);
	Lcd_Cmd(_LCD_CURSOR_OFF);
	Lcd_Out(1, 2, codeToRam(lcd_welcome));
#endif

	mmcBuiltinInit();
	
#ifdef DEBUG_PLAY
	pwmConfig();
	UWR(codeToRam(uart_debugRead));
#endif
	
	INTCON |= (1 << GIE) | (1 << PEIE);		/* Global interrupt */

	for (;;)        						/* Repeat forever */
	{
		while (SLCT != 0)
		{
		}
		
#if _UART_GUI_
/*------------------------ UART DEBUG mode -----------------------------------*/
		UWR(codeToRam(uart_menu));

		while (OK)	/* OK not pressed */
		{
			if (!SLCT)	/* SLCT */
			{
				Delay_ms(300);
				mode++;
				if (mode == 4)
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
				UWR(codeToRam(uart_sampleRate));
			}
			
			lastMode = mode;					
		}
#endif

#if !_UART_GUI
/* ------------------- HD44780 LCD 16x2 display mode -------------------------*/
	Lcd_Cmd(_LCD_CLEAR);               		// Clear display
	
	/* Menu loop */
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
				lcdClear();
				lcdDisplay(1, 2, codeToRam(lcd_record));
			}
			else if ((mode == 2) & (lastMode != mode))
			{
				lcdClear();
				lcdDisplay(1, 2, codeToRam(lcd_play));
			}
			else if ((mode == 3) & (lastMode != mode))
			{
				lcdClear();
				lcdDisplay(1, 2, codeToRam(lcd_totaltrack));
			}
			else if ((mode == 4) & (lastMode != mode))
			{
				lcdClear();
				lcdDisplay(1, 2, codeToRam(lcd_sampleRate));
			}
			
			lastMode = mode;					
		}
#endif		

		/* Record mode */
		if (mode == 1)
		{
			/* Config the timer for hardware timing */
			timer1Config();

			/* Write routine */
#if _UART_GUI			
			UWR(codeToRam(uart_writing));
#else
			lcdClear();
			lcdDisplay(1, 2, codeToRam(lcd_writing));
#endif	
			/* Variables init */
			ptr = buffer0;
			ptrIndex = 0;
			sectorIndex = trackFree();	/* Get address for new track */
			trackFirstSector = sectorIndex;
			bufferFull = 0;
			
			T1CON = (1 << TMR1ON);		/* Start hardware timer */
			while (SLCT)				/* Wait until SLCT pressed */
			{			
				if (bufferFull == 1)
				{
				bufferFull = 0;
					if (currentBuffer)	/* Write buffer 0 */
					{
						if (Mmc_Write_Sector(sectorIndex++, buffer0) != 0)
						{
#if _UART_GUI			
						UWR(codeToRam(uart_errorWrite));
#endif
						}
					}
					else				/* Write buffer 1 */
					{
						if (Mmc_Write_Sector(sectorIndex++, buffer1) != 0)
						{
#if _UART_GUI						
							UWR(codeToRam(uart_errorWrite));
#endif
						}
					}
				}
			}
			T1CON &= ~(1 << TMR1ON);
			
			trackNext(sectorIndex, samplingRate); /* Write the track info */
			
			Delay_ms(500);
			
			
			/* Write complete message */
			intToStr((sectorIndex - trackFirstSector), text);	/* Calculate track length */
#if _UART_GUI
			UWR(codeToRam(uart_done));
			UWR(text);
#else
			lcdClear();
			lcdDisplay(1, 2, codeToRam(lcd_done));
			lcdDisplay(2, 2, text);
#endif
		}

		/* Play mode */
		else if (mode == 2) 
		{
			totalTrack = trackGetTotal(); /* Get total track for menu display */
			
			if (totalTrack == 0) { /* No tracks avaialbe */
				lcdClear();
				lcdDisplay(1, 2, codeToRam(lcd_t_notrack));
			}
			else { /* Select the track */
#if !_UART_GUI
				temp = mode;
				lcdClear();
				
				/* Menu loop */
				while (OK) { /* OK not pressed */
					if (!SLCT) { /* SLCT */
						Delay_ms(300);
						mode++;
						if (mode == (totalTrack+1)) {
							mode = 1;
						}
					}
					
					/* Display track on the screen */
					if (lastMode != mode) {
						intToStr(mode, text);
						lcdClear();
						lcdDisplay(1, 2, text);
					}
					
					lastMode = mode;					
				}
#endif
			}
			
			/* Get the track information to play */
			trackInfo = trackGet(mode);
			mode = temp;	/* Return saved state to mode !important! */
			samplingRate = trackInfo.samplingRate; /* Change sampling rate */
			
			/* Config the timer for hardware timing */
			timer1Config();
			
			/* Read routine */
#if _UART_GUI			
			UWR(codeToRam(uart_reading));
#else
			lcdClear();
			lcdDisplay(1, 2, codeToRam(lcd_playing));
#endif
			ptr = buffer0;
			ptrIndex = 0;
			sectorIndex = trackInfo.address;
			bufferFull = 0;
			currentBuffer = 0;
			
			/* Read the first sector to the buffer */
			if (Mmc_Read_Sector(sectorIndex, buffer0) != 0)
			{
#if _UART_GUI
				UWR(codeToRam(uart_initReadError));	/* First buffer error */
#endif
			}
			
			/* Start the timer1 */
			T1CON |= (1 << TMR1ON);
#ifdef DEBUG_PLAY
			/* Start the PWM module */
			pwmStart();
#endif
			/* Reading loop */
			while (sectorIndex < trackInfo.nextAddress)				/* Wait until SLCT pressed */
			{
				if (bufferFull == 1)
				{
				bufferFull = 0;
					if (currentBuffer)	/* Read buffer 0 */
					{
						if (Mmc_Read_Sector(sectorIndex++, buffer0) != 0)
						{
#if _UART_GUI						
							UWR(codeToRam(uart_errorRead));
#endif						
						}
					}
					else				/* Write buffer 1 */
					{
						if (Mmc_Read_Sector(sectorIndex++, buffer1) != 0)
						{
#if _UART_GUI						
							UWR(codeToRam(uart_errorRead));
#endif
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
#if _UART_GUI			
			UWR(codeToRam(uart_done));
#else
			lcdClear();
			lcdDisplay(1, 2, codeToRam(lcd_done));
#endif
		}
		
		/* Change sampling rate */
		else if (mode == 3)	{
			temp = mode; /* Save current mode state */
			mode = 1;

#if !_UART_GUI
			Lcd_Cmd(_LCD_CLEAR);               		
			/* Menu loop */
			while (OK) { /* OK not pressed */
				if (!SLCT) { /* SLCT */
					Delay_ms(300);
					mode++;
					if (mode == 3) {
						mode = 1;
					}
				}

				if ((mode == 1) & (lastMode != mode)) {
					lcdClear();
					lcdDisplay(1, 2, codeToRam(lcd_s_16khz));
				}
				else if ((mode == 2) & (lastMode != mode)) {
					lcdClear();
					lcdDisplay(1, 2, codeToRam(lcd_s_8khz));
				}
				
				lastMode = mode;					
			}
			
			if (mode == 1) {
				samplingRate = _16KHZ;
			}
			else if (mode == 2) {
				samplingRate = _8KHZ;
			}
			
			lcdClear();
			lcdDisplay(1, 2, codeToRam(lcd_saved));
			
			mode = temp;
#endif	
		}
		
		mode == 1;
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
		TMR1H = timerH;
		TMR1L = timerL;
		
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
			LATD = *(ptr + (ptrIndex++));
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
	
	if (samplingRate == _16KHZ) {
		timerH = _16KHZ_HIGHBYTE;
		timerL = _16KHZ_LOWBYTE;
	}
	else if (samplingRate == _8KHZ) {
		timerH = _8KHZ_HIGHBYTE;
		timerL = _8KHZ_LOWBYTE;
	}
	
	TMR1H = timerH;
	TMR1L = timerL;
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