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

//#define _UART_GUI_
//#define DEBUG_PLAY

/**
* VARIABLE DECLARATION
*/
volatile uint8_t buffer0[512];			/* Buffers for ADC result storage */
volatile uint8_t buffer1[512];
static volatile uint8_t *ptr;
static volatile uint16_t ptrIndex;
volatile uint8_t currentBuffer;
volatile uint8_t bufferFull;
volatile uint8_t mode;
volatile uint8_t adcResult;
volatile uint8_t totalTrack;

/*---- Variables for hardware timing -----------------------------------------*/
static volatile uint8_t samplingRate = _16KHZ;
static volatile uint8_t timerH = _16KHZ_HIGHBYTE;
static volatile uint8_t timerL = _16KHZ_LOWBYTE;

/*----- Variables for track management ---------------------------------------*/
struct songInfo {
	uint32_t address;
	uint32_t nextAddress;
	uint8_t samplingRate;
};

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
//void mmcBuiltinInit(void);
void timer1Config(void);
#ifdef USE_PWM
void pwmConfig(void);
void pwmStart(void);
void pwmStop(void);
void pwmChangeDutyCycle(uint8_t dutyCycle);
#endif

/*
* This function add info for the next track
* 8-bit samplingRate (prev track) + 32-bit new track address
*/

void trackNext(uint32_t address, uint8_t samplingRate);

/*
* This function returns free address location for a new unrecorded track
*/
uint32_t trackFree(void);

/*
* This function get info for a recorded song
*/
struct songInfo trackGet(uint8_t track);

/*
* This function return total tracks available on the card.
* It first check for the security ID
* If the security ID is not valid, it will clear the sector a rewrite a new
* track management sector.
*/
uint8_t trackGetTotal(void);

char* codeToRam(const char* ctxt)
{
	static char txt[15];
	char i;
	for(i =0; txt[i] = ctxt[i]; i++);

	return txt;
}

void main()
{
	unsigned char lastMode;
	uint32_t sectorIndex;
	uint8_t temp;
	uint8_t text[7];
	uint32_t lastSector;
	
	/*---------------- Initialize variables data ---------------------------- */
	ptrIndex = 0;
	currentBuffer = 0;
	bufferFull = 0;
	mode = 0;
	adcResult = 0;
	
	/*---------------- Setup Port B weak pull-up ---------------------------- */
	INTCON2 &= ~(1 << 7); // nRBPU = 0

	ptr = &buffer0[0];
	adcInit();
	Delay_ms(100);

	
	/*---------------- Setup I/O ---------------------------------------------*/
	TRISD = 0x00; 							// Output for DAC0808
	TRISB = (1 << RB0) | (1 << RB1); 		// B0, B1 input; remains output
	TRISC &= ~((1 << 2) | (1 << 6)); 					// Output for CS pin
	
	/*------------ Test code for DAC0808 -------------------------------------*/
	LATD = 0x40;

	/*------------ Welcome message -------------------------------------------*/
	Lcd_Init();								// Init LCD for display
	Lcd_Cmd(_LCD_CLEAR);
	Lcd_Cmd(_LCD_CURSOR_OFF);
	Lcd_Out(1, 2, codeToRam(lcd_welcome));

	//mmcBuiltinInit();
	/*----------- MMC INIT ---------------------------------------------------*/
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
	
	
	
	INTCON |= (1 << GIE) | (1 << PEIE);		/* Global interrupt */

	for (;;)        						/* Repeat forever */
	{
		while (SLCT != 0){
		}

/* ------------------- HD44780 LCD 16x2 display mode -------------------------*/
	Lcd_Cmd(_LCD_CLEAR);               		// Clear display
	
	/* Menu loop */
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
				lcdDisplay(1, 2, codeToRam(lcd_sampleRate));
			}
			
			lastMode = mode;					
		}

		/* Record mode */
		if (mode == 1)
		{
			/* Config the timer for hardware timing */
			timer1Config();

			/* Write routine */
			lcdClear();
			lcdDisplay(1, 2, codeToRam(lcd_writing));
			
			/* Variables init */
			ptr = buffer0;
			ptrIndex = 0;
			sectorIndex = 0;
			bufferFull = 0;
			currentBuffer = 0;
			
			T1CON = (1 << TMR1ON);		/* Start hardware timer */
			while (SLCT)				/* Wait until SLCT pressed */
			{			
				if (bufferFull == 1)
				{
				bufferFull = 0;
					if (currentBuffer)	/* Write buffer 0 */
					{
						if (Mmc_Write_Sector(sectorIndex++, buffer0) != 0) {
						lcdClear();
						lcdDisplay(2, 2, "E");
						}
					}
					else				/* Write buffer 1 */
					{
						if (Mmc_Write_Sector(sectorIndex++, buffer1) != 0) {
						lcdClear();
						lcdDisplay(2,2, "E");
						}
					}
				}
			}
			T1CON &= ~(1 << TMR1ON);
			
			Delay_ms(100);
	
			/* Write complete message */
			// intToStr(sectorIndex, text);	/* Calculate track length */
			// lcdClear();
			// lcdDisplay(2, 2, text);
		}

		/* Play mode */
		else if (mode == 2) 
		{	
			lastSector = sectorIndex;
			sectorIndex = 0;
			
			/* Config the timer for hardware timing */
			timer1Config();
			
			/* Read routine */
			lcdClear();
			lcdDisplay(1, 2, codeToRam(lcd_playing));
			ptr = buffer0;
			ptrIndex = 0;
			bufferFull = 0;
			currentBuffer = 0;
			
			/* Read the first sector to the buffer */
			if (Mmc_Read_Sector(sectorIndex, buffer0) != 0)	{
			}
			
			/* Start the timer1 */
			T1CON |= (1 << TMR1ON);
			
			/* Reading loop */
			while (SLCT)
			{
				if (bufferFull == 1) {
				bufferFull = 0;
					if (currentBuffer) { /* Read buffer 0 */
					
						if (Mmc_Read_Sector(sectorIndex++, buffer0) != 0) {
						lcdClear();
						lcdDisplay(2,2, "E");						
						}
					}
					else { /* Write buffer 1 */
					
						if (Mmc_Read_Sector(sectorIndex++, buffer1) != 0) {
						lcdClear();
						lcdDisplay(2,2, "E");
						}
					}
				}
			}
			
			/* Stop the timer1 */
			T1CON &= ~(1 << TMR1ON);
			
			Delay_ms(100);
			//lcdClear();
			//lcdDisplay(1, 2, codeToRam(lcd_done));
		}
		
		/* Change sampling rate */
		else if (mode == 3)	{
			temp = mode; /* Save current mode state */
			mode = 1;
			Delay_ms(500);
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
		}
	
		mode == 1;
	}

}

#ifdef REMOVE
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
#endif

void interrupt()
{
	if (PIR1.TMR1IF == 1) {
		/* Clear the interrupt flag */
		PIR1.TMR1IF = 0;
		
		/* Load a new timer cycle */
		/* For 8kHz: 0xfd8e
			For 16kHz: 0xfec7*/
		TMR1H = timerH;
		TMR1L = timerL;
		
		if (mode == 1) { /* Record mode */
			/* Trigger the A/D conversion */
			GO_bit = 1;
		
		/*---- ADC signal --------*/
			LATC |= (1 << 6);
			Delay_us(1);
			LATC &= ~(1 << 6);
		}
		else {	/* Play mode */
			/* Send data to the DAC */
			LATD = *(ptr + (ptrIndex++));
		
			/* Swap the buffer */
			if (ptrIndex == 512) {
				ptrIndex = 0;
				bufferFull = 1;
				if (currentBuffer == 0)	{
					ptr = buffer1;
					currentBuffer = 1;
				}
				else {
					ptr = buffer0;
					currentBuffer = 0;
				}
			}
		}
	}

	if (PIR1 & (1 << ADIF)) {
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

#ifdef USE_PWM
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
#endif

/*
* This function add info for the next track
* 8-bit samplingRate (prev track) + 32-bit new track address
*/

// void trackNext(uint32_t address, uint8_t samplingRate) 
// {
	// uint8_t i = 0;
	
	// /* Get free byte location to write new track info */
	// i = 4 + totalTrack * 3;
	
	// /* Write a new track info */
	// buffer0[i+1] = (uint8_t) samplingRate;
	// buffer0[i+2] = (uint8_t) address;		/* LSB */
	// buffer0[i+3] = (uint8_t) address >> 8;
	
	// /* Increase total Track by 1 */
	// totalTrack++;
	// buffer0[4] = totalTrack;
	
	// /* Write new sector to info sector */
	// Mmc_Write_Sector(INFO_SECTOR, buffer0);
// }

// /*
// * This function returns free address location for a new unrecorded track
// */
// uint32_t trackFree(void)
// {
	// uint8_t i;
	// uint32_t address;
	
	// address = (uint32_t) FIRST_DATA_SECTOR;
	
	// if (totalTrack != 0) {
		// i = 4 + totalTrack * 5;
		
		// address = (uint32_t) (buffer0[i] << 24) + \
					// (uint32_t) (buffer0[i-1] << 16) + \
					// (uint32_t) (buffer0[i-2] << 8) + \
					// (uint32_t) (buffer0[i-3]);
	// }
						
	// return address;
// }

// /*
// * This function get info for a recorded song
// */
// struct songInfo trackGet(uint8_t track)
// {
	// struct songInfo song;
	// uint8_t i = 0;
	
	// /* Read the info sector of the card */
	// while (Mmc_Read_Sector(INFO_SECTOR, buffer0) != 0);
	
	// /* Calculate the track location in buffer sector */
	// i = 4 + track * 5;
	
	// if (track != 1)
	// {
		// /* Return the track information */
		// song.address = (uint32_t) (buffer0[i-8] + \
						// buffer0[i-7] << 8 + \
						// buffer0[i-6] << 16 + \
						// buffer0[i-5] << 24);
		// song.samplingRate = buffer0[i-4];
		// song.nextAddress = (uint32_t) (buffer0[i-3] + \
						// buffer0[i-2] << 8 + \
						// buffer0[i-1] << 15 + \
						// buffer0[i] << 24);
	// }
	// else
	// {
		// /* Return track 1 info */
		// song.address = 0;
		// song.samplingRate = buffer0[5];
		// song.nextAddress = (uint32_t) (buffer0[6] + \
							// buffer0[7] << 8 + \
							// buffer0[8] << 16 + \
							// buffer0[9] << 24);
	// }
	
	// return song;
// }


/*
* This function return total tracks available on the card.
* It first check for the security ID
* If the security ID is not valid, it will clear the sector a rewrite a new
* track management sector.
*/
// uint8_t trackGetTotal(void)
// {
	// uint8_t i;
	// uint8_t totalTrack;
	
	// totalTrack = 0;
	
	// /* Read the info sector of the card */
	// while (Mmc_Read_Sector(INFO_SECTOR, buffer0) != 0);
	
	// /* IDs check */
	// if ((buffer0[0] == ID0) || (buffer0[1] == ID1) ||\
	// (buffer0[2] == ID2) || (buffer0[3] == ID3)) {
		// /* Sector not contain true ids, wipe out */
		// for (i = 0; i < 512; i++) {
			// buffer0[i] = 0;
		// }
		// buffer0[0] = ID0;
		// buffer0[1] = ID1;
		// buffer0[2] = ID2;
		// buffer0[3] = ID3;
		
		// /* Rewrite the information sector */
		// while (Mmc_Write_Sector(INFO_SECTOR, buffer0) != 0);
	// }
	// else {
		// /* Sector contain valid information */
		// /*-- Read number of tracks */
		// totalTrack = buffer0[4];
	// }
	
	// return totalTrack;
// }