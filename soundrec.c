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
#include "mmc.h"
#include "soundrec.h"
#include "global.h"

/**
* VARIABLE DECLARATION
*/
volatile uint16_t buffer0[512];			/* Buffers for ADC result storage */
volatile uint16_t buffer1[512];
uint16_t *ptr;
uint16_t ptrIndex = 0;
volatile uint8_t currentBuffer = 0;
volatile uint8_t bufferFull = 0;

//volatile unsigned char samplingRate = 1;
volatile unsigned int mode = 0;
volatile unsigned int t = 0;
volatile unsigned char x;
volatile uint8_t error;
volatile uint32_t numberOfSectors;
volatile uint8_t spiReadData;
volatile uint32_t arg = 0;
volatile uint8_t count;
volatile uint16_t rejected = 0;
volatile uint8_t samplingDelay = _MAXIMUM_RATE;
volatile uint8_t text[10];


/**
* FUNCTION DECLARATION
*/
void specialEventTriggerSetup(void);
void adcInit(void);
uint8_t writeInit(uint8_t writeMode, uint32_t address);
uint8_t write(uint8_t writeMode, uint16_t *buffer);
void writeStop(void);


/* EEPROM variables for track listing */
//volatile uint8_t totalTrack = 0; // Total tracks have been recorded
char* codeToRam(const char* ctxt)
{
	static char txt[20];
	char i;
	for(i =0; txt[i] = ctxt[i]; i++);

	return txt;
}

/*********** BEGIN ADC *****************/
uint8_t
adcRead(void)
{
	//TP0 = 1;
	GO_bit = 1; // Begin conversion
	while (GO_bit); // Wait for conversion completed
	//TP0 = 0;
	return ADRESH;
}
/*********** END ADC *****************/

void main()
{
	unsigned char lastMode;
	static volatile uint8_t totalTrack;
	static volatile uint32_t trackAddr; // MMC/SD Addr to write this track
	static volatile uint32_t trackLength = 0;
	static volatile uint8_t i;
	static volatile uint8_t trackID = 0;
	volatile uint8_t lastSelect = 0;
	uint8_t trackSamplingRate = ENC_MAXIMUM_RATE; /* Encoded track sampling rate
													in EEPROM */

	ADCON1 |= 0x0e; // AIN0 as analog input
	ADCON2 |= 0x2d; // 12 Tad and FOSC/16
	ADFM_bit = 0; // Left justified
	ADON_bit = 1; // Enable ADC module
	Delay_ms(100);

	/**** END ADC INIT ****/
	TRISD = 0xff;
	TRISA2_bit=1;
	TRISD2_bit=1;
	TRISD3_bit=1;
	TRISD7_bit = 0;
	TRISB=0;
	TRISC = 0x00;

	UART1_Init(9600);
	cardInit(ECHO_ON);

	for (;;)        /* Repeat forever */
	{
		/****** REWRITE NEW SETUP UI ******/
		while (SLCT != 0)        /* Wait until SELECT pressed */
		{
		}
		UWR("Select a Menu");
		while (OK)
		{
			if (!SLCT)
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
				UWR("Record");
			}
			else if ((mode == 2) & (lastMode != mode))
			{
				UWR("Play");
			}
			else if ((mode == 3) & (lastMode != mode))
			{
				UWR("Track listing");
			}
			else if ((mode == 4) & (lastMode != mode))
			{
				UWR("C s r"); 			/* Change sampling rate */
			}
			lastMode = mode;					
		}
		/****** END REWRITE NEW SETUP UI ******/

		/**** BEGIN WORKING MODE *******/
		if (mode == 1) // Record
		{
			while (SLCT)				/* Wait until SLCT pressed */
			{
				if (writeInit(_MULTIPLE_BLOCK, 0))
				{
					UWR("W!");
					break;
				}
				
				if (bufferFull)
				{
					bufferFull = 0;
					if (currentBuffer)	/* Write buffer 0 */
					{
						if (write(_MULTIPLE_BLOCK, buffer0))
						{
							UWR("W e1!");
						}
					}
					else				/* Write buffer 1 */
					{
						if (write(_MULTIPLE_BLOCK, buffer1))
						{
							UWR("W e2!");
						}
					}
				}
			}
			
			writeStop();
			UWR("Wr!");
		}

		/* Play mode */
		else if (mode == 2) 
		{
			#ifndef DEBUG // realcode
			#ifdef DEBUG_SELECT_TRACK
			while (OK == 0);
			UWR("Wch?");
			totalTrack = readTotalTrack();
			trackID = 0;
			i = 0;
			if (totalTrack != 0)
			{	
				while (OK) 			// OK button not pressed
				{
					if (!SLCT)
					{
						Delay_ms(300);
						i++;
						if (i == (totalTrack + 1))
						{
							i = 1;
						}
					}
					
					if (lastSelect != i)
					{
						IntToStr(i, text);
						UWR(text);
					}
					
					lastSelect = i;
				}
			}
			trackID = i;
			#else
			trackID = selectTrack();
			#endif
			UART_Write_Text("Slctd: ");
			IntToStr(trackID, text);
			UWR(text);
			
			if (trackID != 0)
			{
				/* Get track address and track length */
				trackAddr = readTrackMeta(trackID, _ADDRESS);
				trackLength = readTrackMeta(trackID, _LENGTH);
				
				/* Get track sampling rate */
				trackSamplingRate = (uint8_t) (readTrackMeta(trackID,\
				_TRACK_SAMPLING_RATE));
				
				if (trackLength != 0)
				{
					/* Play the track */
					if (readMultipleBlock(trackSamplingRate, trackAddr*512, 	
					trackLength))
					{
						UWR("R r!"); 
					}
				}
				else
				{
					UWR("pt!");			/* Empty */
				}
			}
			else 
			{
				//TODO:: play the whole card goes here
			}
			
			#else
			//read 10 block from address 0
			if (readMultipleBlock(6*512, 3))
			{
				UWR("R r!"); 
			}
			#endif
			while (SLCT && OK) // return to main menu
			{
			}
		}
		else if (mode == 3) // track listing
		{
			tracklist();
			for (i = 0; i < 40; i++)
			{
				IntToStr(EEPROM_Read(i), text);
				UART_Write_Text(text);
			}
			UWR("");
			while (SLCT && OK) // return to main menu
			{
			}
		}
		else if (mode == 4) // Change sampling rate
		{
			samplingDelay = changeSamplingRate();
			UWR("S!");
			while (SLCT && OK)
			{
			}
		}
		/**** END WORKING MODE *******/
	}
}

/******************************************************************************
uint8_t selectTrack
returns:
	- trackID
	- 0: play the whole card
******************************************************************************/
uint8_t
selectTrack(void)
{
	uint8_t temp = 0;
	uint8_t trackID;
	uint8_t i = 1;
	
	UWR("Whch?");
	temp = readTotalTrack();
	trackID = 0;
	if (temp != 0)
	{
		while (OK)
		{
			if (!SLCT)
			{
				Delay_ms(300);
				i++;
				if (i == (temp + 1))
				{
					i = 1;
				}
			}
			
			trackID = i;
			IntToStr(i, text);
			UWR(text);
			Delay_ms(200);
		}
		
		return trackID;
	}
	else
	{
		return 0; // play the whole card
	}
}

/*
* void addTrack(uint32_t address, uint32_t length)
* Caution! Sampling rate will be place at 8MSBs in address.
* This function add the track to tracklist on EEPROM.
* Arguments: address: 32 bit address of the track
* 			 length: 32 bit length of the track
* Returns: none
*/
void
addTrack(uint32_t address, uint32_t length)
{
	static volatile uint8_t romAddr;
	static volatile uint8_t totalTrack;
	
	/* Encode the sampling rate to address's first octet */
	address &= 0x1fffffff; /* Clear the first 3 MSBs */
	switch (samplingDelay)
	{
		case _MAXIMUM_RATE:
		{
			address |= (ENC_MAXIMUM_RATE << 29);
			break;
		}
		case _22_KSPS:
		{
			address |= (ENC_22_KSPS << 29);
			break;
		}
		case _16_KSPS:
		{
			address |= (ENC_16_KSPS << 29);
			break;
		}
	}
	totalTrack = EEPROM_Read(0x00) & 0b000111111; // Read the totalTrack value
	romAddr = 8*totalTrack; // Address to place new track metadata
	/* Write new track address */
	EEPROM_Write((romAddr + 1), (uint8_t) (address >> 24)); // MSB first
	EEPROM_Write((romAddr + 2), (uint8_t) (address >> 16));
	EEPROM_Write((romAddr + 3), (uint8_t) (address >> 8));
	EEPROM_Write((romAddr + 4), (uint8_t) address);
	/* Write new track length */
	EEPROM_Write((romAddr + 5), (uint8_t) (length >> 24)); // MSB first
	EEPROM_Write((romAddr + 6), (uint8_t) (length >> 16));
	EEPROM_Write((romAddr + 7), (uint8_t) (length >> 8));
	EEPROM_Write((romAddr + 8), (uint8_t) length);
	/* Write new totalTrack */
	totalTrack++;
	totalTrack |= 0b10100000;
	EEPROM_Write(0x00, totalTrack);
}

uint8_t
readTotalTrack(void)
{
	static volatile uint8_t totalTrack;
	
	totalTrack = EEPROM_Read(0x00);
	// check if totalTrack is a valid number
	if (((totalTrack & 0b11100000) >> 5) != 0x05)
	{
		// invalid, totalTrack = 0;
		EEPROM_Write(0x00, 0b10100000);
		return 0;
	}
	else
	{
		// valid, return totalTrack
		totalTrack &= 0b00011111;
		return totalTrack;
	}
}

void
trackList(void)
{
	uint8_t tTrack;
	uint8_t t;
	uint8_t temp;
	
	tTrack = readTotalTrack(); // beware of nesting fucntion call!
	
	if (tTrack != 0)
	{
		UWR("Track list:");
		temp = tTrack;
		IntToStr(temp, text); // convert total track to string
		UART_Write_Text("Tk: ");
		UWR(text);
		/* print track list */
		for (t = 1; t <= temp; t++)
		{
			UART_Write_Text("Tr ");
			IntToStr(t, text);
			UART_Write_Text(text);
			UART_Write_Text(": ");
			/* Write track address */
			// !!! Beware of nesting function call
			LongWordToStr((readTrackMeta(t, _ADDRESS)), text); // trackAddr to string
			UART_Write_Text(text); // write track address
			UART_Write_Text("  "); // write inline spaces
			/* Write track length */
			LongWordToStr((readTrackMeta(t, _LENGTH)), text); // trackLnght to strng
			UWR(text); // write track length and break line
		}
	}
	else 
	{
		// tTrack = 0;
		UWR("e!");						/* No track avaiable */
	}
}

uint32_t
readTrackMeta(uint8_t trackID, uint8_t returnType)
{
	uint32_t returnInfo = 0;
	uint8_t romAddr; // first rom location for track
	
	romAddr = 8 * (trackID - 1);
	switch (returnType)
	{
		case _ADDRESS:
		{
			returnInfo |= (uint32_t) (EEPROM_Read(romAddr + 1) << 24); // MSB
			returnInfo |= (uint32_t) (EEPROM_Read(romAddr + 2) << 16);
			returnInfo |= (uint32_t) (EEPROM_Read(romAddr + 3) << 8);
			returnInfo |= (uint32_t) (EEPROM_Read(romAddr + 4)); // LSB
			returnInfo &= 0x1fffffff; /* Clear 3 MSBs */
			break;
		}
		case _LENGTH:
		{
			returnInfo |= (uint32_t) (EEPROM_Read(romAddr + 5) << 24); // MSB
			returnInfo |= (uint32_t) (EEPROM_Read(romAddr + 6) << 16);
			returnInfo |= (uint32_t) (EEPROM_Read(romAddr + 7) << 8);
			returnInfo |= (uint32_t) (EEPROM_Read(romAddr + 8)); // LSB
			break;
		}
		case _TRACK_SAMPLING_RATE:
		{
			returnInfo = (uint32_t) (EEPROM_Read(romAddr + 1) >> 5);
			break;
		}
		default:
		{
			break;
		}
	}
	return returnInfo;
}


/******************************************************************************
uint8_t changeSamplingRate();
UI to prompt user select sampling rate
returns: delay amount
******************************************************************************/
uint8_t
changeSamplingRate()
{
	static uint8_t select, lastSelect;
	static uint8_t delay = _MAXIMUM_RATE;
	
	select = 1;
	lastSelect = 0;
	
	while (!OK || !SLCT); // make sure none are pressed
	UWR("Select sampling rate:");
	while (OK)
	{
		if (!SLCT)
		{
			Delay_ms(300);
			select++;
			if (select == 4)
			{
				select = 1;
			}
		}
		
		if ((select == 1) & (lastSelect != select))
		{
			UWR("-- Max");
			delay = _MAXIMUM_RATE;
		}
		else if ((select == 2) & (lastSelect != select))
		{
			UWR("-- 22");
			delay = _22_KSPS;
		}
		else if ((select == 3) & (lastSelect != select))
		{
			UWR("-- 16");
			delay = _16_KSPS;
		}
		
		lastSelect = select;
	}
	return delay;
}

/**
* This function setup the CCP2 module as an A/D conversion trigger.
*/
void specialEventTriggerSetup(void)
{
	/* Compare mode, trigger sepcial event */
	CCP2CON = (1 << CCP2M3) | (1 << CCP2M1) | (1 << CCP2M0);
	
	/* Timer 3 as clock source
		with 1:8 clock prescaler */
	T3CON = (1 << T3CCP2) | (1 << T3CKPS1) | (1 << T3CKPS0);
	
	/* Compare value: 15625 (0x3d09) for 25ms period */
	CCPR2H = 0x3d;
	CCPR2L = 0x09;
}

/**
* This function start the Timer 3 for special event trigger.
*/
void specialEventTriggerStart(void)
{
	T3CON |= (1 << TMR3ON);
}

/**
* Init the ADC module
* 	with AIN0 as analog input
* 	12 Tad and FOSC/16
* 	left justified result
*/
void adcInit(void)
{
	ADCON1 = 0x0e;						
	ADCON2 = 0x2d;						
	ADCON2 |= (1 << ADFM);			
	ADCON0 |= (1 << ADON);	

	/* Enable ADC interrupt */
	PIE1 |= (1 << ADIE);
}

/**
* A/D conversion interrupt routine
* This move the ADC result to the buffer array.
*/
void interrupt(void)
{
	if (PIR1 & (1 << ADIF)) 
	{
		/* Move the result to buffer */
		*(ptr + (ptrIndex++)) = (ADRESH << 8) + ADRESL;
		
		/* Swap the buffer */
		if (ptrIndex == 512)					
		{
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
*	Write init
* 	This function init the writing procedure to the card with write mode is 
*	single or multiple blocks.
*/
uint8_t writeInit(uint8_t writeMode, uint32_t address)
{
	uint8_t retry;
	
	if (writeMode == _MULTIPLE_BLOCK)
	{
		while (retry < 50)
		{
			if (!(sendCMD(25, address)))
			{
				error = 0;
				break;
			}
			else
			{
				error = 1;
				retry++;
			}
		}
	}
	else 
	{
		// TODO wire single block init code goes here
	}
	
	if (!error)
	{
		spiWrite(0xff);						/* Dummy clock */
		spiWrite(0xff);
		spiWrite(0xff);
		return 0;
	}
	else
	{
		return 1;
	}
}

/**
* Write the data to the card.
*/
uint8_t write(uint8_t writeMode, uint16_t *buffer)
{
	uint16_t i;
	uint8_t count;
	uint8_t error = 0;
	
	if (writeMode == _MULTIPLE_BLOCK)		
	{
		spiWrite(0b11111100);				/* Data token for CMD 25 */
		
		for (i = 0; i < 512; i++)
		{
			spiWrite(*(buffer + i));
		}
		
		spiWrite(0xff);						/* 2-bytes CRC */
		spiWrite(0xff);
		
		/* Check if the data is accepted */
		count = 0;
		while (count++ < 12)
		{
			spiReadData = spiRead();
			if ((spiReadData & 0x1f) == 0x05)
			{
				error = 0;
				break;
			}
			else
			{	
				error = 1;
			}
		}
		
		while (spiRead() != 0xff);			/* Check if the card is busy */
	}
	else
	{
	}
	
	return error;
}

/**
*	This function stop the write procedure for multiple block write
*/
void writeStop(void) 
{
	spiWrite(0b11111101);
	while (spiRead() != 0xff); 				// Check if the card is busy
}