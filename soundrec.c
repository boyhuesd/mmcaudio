/******************************************************************************
PIC18F4520 MMC/SD AUDIO RECORDER
Author: Dat Tran Quoc Le
******************************************************************************/

/******************************************************************************
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
******************************************************************************/

/******************************************************************************
TODO::
1. Luu du lieu thanh tung track, track list (dung EEPROM)
2. Lua chon tan so lay mau
3. Data reject handling
4. Noise supression
5. Check if the card address argument is byte-address or block-address?!!!
>>> block for SDC v2, byte otherwise
6. !Write track metadata to MMC/SD, not EEPROM!
7. Rewrite MMC/SD Init fucntion to support more card
8. Add feature to keep or discard a track when recorded successful.
9. Write an UI that ask for which track to play.
>>> Done, debug it!
10. Create a header files that contain information string constant
11. Write handle when play the whole card in readMultipleBlock()
12. Display sampling period on oscilloscope.
******************************************************************************/
#include <stdint.h>
#include "soundrec.h"

sfr sbit Mmc_Chip_Select at LATC2_bit;
sfr sbit Mmc_Chip_Select_Direction at TRISC2_bit;

#define TP0 LATC0_bit
#define UWR(x) UART_Write_Text(x);\
	UART_Write(13);\
	UART_Write(10);

#define spiWrite(x) SPI1_Write(x)
#define spiRead() SPI1_Read(0xff)

// Error definition
#define initERROR_CMD0 1
#define initERROR_CMD1 2
#define initERROR_CMD16 3
// EEPROM Fucntion definition
#define _LENGTH 1
#define _ADDRESS 0
// respond type
#define _R1 0
#define _R3 1
#define _R7 1
#define _RESPOND_ERROR 0xff

sbit LCD_RS at LATD0_bit;
sbit LCD_EN at LATD1_bit;
sbit LCD_D7 at LATD7_bit;
sbit LCD_D6 at LATD6_bit;
sbit LCD_D5 at LATD5_bit;
sbit LCD_D4 at LATD4_bit;


sbit LCD_RS_Direction at TRISD0_bit;
sbit LCD_EN_Direction at TRISD1_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;

const char infProgName[] = "AUDIO RECORDER";
const char infPressSelect[] = "PRESS SELECT!";
const char infModeSlct[] = "CHOOSE A MENU";
const char infSamplingSelect[] = "SLCT SMPLNG RATE";
const char infSamplingSelected[] = "SMPLNG RATE SLCTD";
const char inf8Ksps[] = "8 KSPS";
const char inf16Ksps[] = "16 KSPS";
const char infMax[] = "MAXIMUM";
const char infMMCDttng[] = "DETECTING MMC";
const char infMMCDttd[] = "MMC DETECTED";
const char infWrtng[] = "RECORDING!";
const char infRdng[] = "PLAYING";
const char infWrt[] = "RECORD";
const char infRd[] = "PLAY  ";
const char infPressToStop[] = "PRSS SLCT TO STP";
const char infStopped[] = "STOPPED";
const char infPressAnyKey[] = "PRESS ANY KEY!";

#define SLCT RD2_bit
#define OK RD3_bit
#define DACOUT LATB

volatile unsigned char samplingRate = 1;
volatile unsigned int mode = 0;
volatile unsigned int t = 0;
volatile unsigned char x;
volatile uint8_t error;
volatile uint32_t numberOfSectors;
volatile uint8_t spiReadData;
volatile uint32_t arg = 0;
volatile uint8_t count;
volatile uint16_t rejected = 0;

/* EEPROM variables for track listing */
//volatile uint8_t totalTrack = 0; // Total tracks have been recorded
/******************************************************************************
EEPROM data placement (00h - ffh)
[8-bits totalTrack][32-bits trackAdd1][32-bits trackLength1][32-bits trackAdd2]

totalTrack = 0b101xxxxxx - 101 to verify that a real total track
TODO:: need to write a block that verify totalTrack when the program start, if 
totalTrack is not verified, initialize it as 0 (0b101000000)

void addTrack(uint32_t address, uint32_t length)
Function to add the sectors recored in current session to the eeprom
Returns: none

void readTotalTrack()
Function to read the total track in the EEPROM, if total track is not a valid 
number, initialize it at 0.
returns: totalTrack

void trackList()
Function print track list via UART.

uint32_t readTrackMeta(uint8_t trackID, uint8_t returnType)
Function returns track address or track length.

uint8_t selectTrack(void)
An UI that ask for which track to play.
returns: trackID
******************************************************************************/

uint8_t
selectTrack(void);

void
addTrack(uint32_t address, uint32_t length); // track address, numberOfSectors

uint8_t
readTotalTrack(void);

void
trackList(void);

uint32_t
readTrackMeta(uint8_t trackID, uint8_t returnType);

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

/******************************************************************************
MMC functions: 
- command(command, fourbyte_arg, CRCbits)
- writeSingleBlock() : write a single block
******************************************************************************/
void
command(char command, uint32_t fourbyte_arg, char CRCbits)
{
	spiWrite(0xff);
	spiWrite(0b01000000 | command);
	spiWrite((uint8_t) (fourbyte_arg >> 24));
	spiWrite((uint8_t) (fourbyte_arg >> 16));
	spiWrite((uint8_t) (fourbyte_arg >> 8));
	spiWrite((uint8_t) (fourbyte_arg));
	spiWrite(CRCbits);
	spiReadData = spiRead();
}

uint8_t 
mmcInit(void)
{
	uint8_t u;
	volatile uint8_t error = 0;
	
	Delay_ms(2);
	Mmc_Chip_Select = 1;
	for (u = 0; u < 10; u++)
	{
		spiWrite(0xff);
	}
	Mmc_Chip_Select = 0;
	Delay_ms(1);
	command(0, 0, 0x95);
	count = 0;
	while ((spiReadData != 1) && (count < 10))
	{
		spiReadData = spiRead();
		count++;
	}
	if (count >= 10)
	{
		error = initERROR_CMD0;
	}
	command(1, 0, 0xff);
	count = 0;
	while ((spiReadData != 0) && (count < 1000))
	{
		command(1, 0, 0xff);
		spiReadData = spiRead();
		count++;
	}
	if (count >= 1000)
	{
		error = initERROR_CMD1;
	}
	command(16, 512, 0xff);
	count = 0;
	while ((spiReadData != 0) && (count < 1000))
	{
		spiReadData = spiRead();
		count++;
	}
	if (count >= 1000)
	{
		error = initERROR_CMD16;
	}
	return error;
}

void
writeSingleBlock(void)
{
	uint16_t g = 0;
	spiWrite(0xff);
	// check if the card is ready to receive command
	spiReadData = spiRead();
	while (spiReadData != 0xff)
	{
		spiReadData = spiRead();
		UWR("Card busy!");
	}
	// Send CMD 24 to write single block
	command(24, arg, 0x95);
	// verify R1
	while (spiReadData != 0)
	{
		spiReadData = spiRead();
	}
	UWR("Command accepted!");
	spiWrite(0xff);
	spiWrite(0xff);
	spiWrite(0b11111110); // Data token for CMD 24
	for (g = 0; g < 512; g++)
	{
		spiWrite(0x50);
	}
	spiWrite(0xff);
	spiWrite(0xff);
	spiReadData = spiRead();
	// check if the block is accepted
	count = 0;
	while (count < 10)
	{
		if ((spiReadData & 0b00011111) == 0x05)
		{
			UWR("Data accepted!");
			break;
		}
		spiReadData = spiRead();
		count++;
	}
	if (count >= 10)
	{
		UWR("Data rejected!");
	}
	spiReadData = spiRead();
	while (spiReadData != 0xff)
	{
		spiReadData = spiRead();
	}
	UWR("Card is idle");
}
void
readSingleBlock(void)
{
	volatile uint16_t numOfBytes;
	volatile uint8_t strData[7];
	spiWrite(0xff);
	spiReadData = spiRead();
	while (spiReadData != 0xff)
	{
		spiReadData = spiRead();
		UWR("Card busy!");
	}
	// Send CMD 17 to read single block
	command(17, arg, 0x95); // read 512 bytes from byte address 0
	// Verify R1
	count = 0;
	while (count < 10)
	{
		spiReadData = spiRead();
		if (spiReadData == 0)
		{
			UWR("CMD accepted!");
			break;
		}
		count++;
	}
	if (count >= 10)
	{
		UWR("CMD Rejected!");
		while (1); // Trap the CPU
	}
	// continue to read until data token received
	while (spiReadData != 0xfe)
	{
		spiReadData = spiRead();
	}
	UWR("Token received!");
	// received a single block
	for (numOfBytes = 0; numOfBytes < 512; numOfBytes++)
	{
		spiReadData = spiRead();
		IntToStr(spiReadData, strData);
		UWR(strData);
		DACOUT = spiReadData;
		Delay_ms(2);
	}
	// receive CRC;
	spiReadData = spiRead();
	spiReadData = spiRead();
	UWR("DONE!");
}

// better command sending function
/******************************************************************************
Send Command to the MMC/SD
Arguments: uint8_t cmd, uint32_t arg
Returns:
	0 : sucesss
	1 : error
******************************************************************************/
uint8_t
sendCMD(uint8_t cmd, uint32_t arg)
{
	uint8_t retryTimes = 0;
	
	// check if the card is ready to receive command
	spiWrite(0xff);
	do 
	{
		spiReadData = spiRead();
	}
	while (spiReadData != 0xff);
	//UWR("Card free!");
	
	// Send the CMD
	spiWrite(0b01000000 | cmd);
	spiWrite((uint8_t) (arg >> 24));
	spiWrite((uint8_t) (arg >> 16));
	spiWrite((uint8_t) (arg >> 8));
	spiWrite((uint8_t) arg);
	spiWrite(0x95); // default CRC for SPI protocol
	spiReadData = spiRead();
	
	while (retryTimes < 10)
	{
		if (spiReadData == 0)
		{
			break;
		}
		spiReadData = spiRead();
		retryTimes++;
	}
	
	if (retryTimes >= 10)
	{
		return 1; // command rejected
	}
	else
	{
		return 0; // command accepted
	}
}

uint8_t
writeMultipleBlock(uint32_t address)
/******************************************************************************
Write multiple block of data to the MMC/SD.
address: address location begin to write (byte address mode only)
numberOfSectors should be used as track length

Returns:
	0 if successful.
	1 write error.
******************************************************************************/
{
	volatile uint16_t g;
	volatile uint8_t retry;
	volatile uint8_t error;
	
	do 
	{
		if (!(sendCMD(25, address))) // write command accepted
		{
			error = 0;
			break;
		}
		else
		{
			error = 1;
			Delay_ms(50);
			UWR("CMD error!");
			retry++;
		}
	}
	while (retry < 50);
	
	if (!error)
	{
		spiWrite(0xff);
		spiWrite(0xff);
		spiWrite(0xff); // Dummy clock
		numberOfSectors = 0; // Initialize the number of sector
		rejected = 0;
		while (SLCT) // repeat until Select button pressed
		{
			spiWrite(0b11111100); // Data token for CMD 25
			for (g = 0; g < 512; g++)
			{
				//spiWrite((uint8_t) g);
				//TP0 = 1;
				spiWrite(adcRead());
				//TP0 = 0;
				//Delay_us(15);
				// IntToStr(g, text);
				// UWR(text);
				// Delay_ms(2);
			} // write a block of 512 bytes data
			spiWrite(0xff);
			spiWrite(0xff); // 2 bytes CRC
			// check if the data is accepted
			count = 0;
			while (count < 30)
			{
				spiReadData = spiRead();
				if ((spiReadData & 0b00011111) == 0x05)
				{
					//UWR("Data accepted!");
					//Delay_us(5);
					numberOfSectors++;
					break;
				}
				count++;
			}
			if (count >= 30)
			{
				UWR("Data rejected!");
				rejected++;
			} 			
			do // check if the card is busy
			{
				spiReadData = spiRead();
			}
			while (spiReadData != 0xff);
		}
		// if the SLCT button is pressed
		// write the stop transfer token
		spiWrite(0b11111101); 
		spiWrite(0xff);
		spiReadData = spiRead();
		while (spiReadData != 0xff) // check if the card is busy
		{
			spiReadData = spiRead();
		}
	}
	return error;
}


/******************************************************************************
uint8_t readMultipleBlock(uint32_t address, uint32_t length);
Function to read multiple block from MMC/SD
address : bye address to read (track address)
length: number of bytes to read (track length)

returns: 
	0: success
	1: error
******************************************************************************/
uint8_t
readMultipleBlock(uint32_t address, uint32_t length)
{
	volatile uint16_t g;
	volatile uint8_t text[7];
	volatile uint16_t sectorIndex = 0;
	volatile uint8_t error;
	volatile uint8_t retry = 0;
	
	do 
	{
		if (!(sendCMD(18, address))) // read multiple block command accepted
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
	while (retry < 50);
	
	if (!error)
	{
		while (sectorIndex <= length)
		{
			sectorIndex++;
			// 3. Read until received data token
			do 
			{
				spiReadData = spiRead();
			}
			while (spiReadData != 0xfe);
			// 4. Read 512 bytes of data
			for (g = 0; g < 512; g++)
			{
				//spiReadData = spiRead();
				//IntToStr(spiReadData, text);
				//UWR(text);
				//Delay_ms(2);
				DACOUT = spiRead();
				Delay_us(17);
			}
			// 5. Read 2 bytes CRC
			spiReadData = spiRead();
			spiReadData = spiRead();
		}
		// STOP TRANSMISSION
		// 6. Send stop transmission command
		command(12, 0, 0x95);
		count = 0;
		do
		{
			if (spiReadData == 0)
			{
				UWR("Stopped Transfer!");
				break;
			}
			spiReadData = spiRead();
			count++;
		}
		while (count < 10);
		// 7. Read until card is ready
		do 
		{
			spiReadData = spiRead();
		}
		while (spiReadData != 0xff);
		UWR("Card free!");
	}
	return error;
}

void main()
{
	unsigned char select;
	unsigned char lastMode;
	volatile uint8_t initRetry = 0;
	volatile uint8_t text[10];
	static volatile uint8_t totalTrack;
	static volatile uint32_t trackAddr = 0; // MMC/SD Addr to write this track
	static volatile uint32_t trackLength = 0;
	static volatile uint8_t i;
	static volatile uint8_t trackID = 0;

	// adcInit();
	ADCON1 |= 0x0e; // AIN0 as analog input
	ADCON2 |= 0x2d; // 12 Tad and FOSC/16
	ADFM_bit = 0; // Left justified
	ADON_bit = 1; // Enable ADC module
	Delay_ms(100);

	/**** END ADC INIT ****/
	TRISD=0xf3;
	TRISA2_bit=1;
	TRISD2_bit=1;
	TRISD3_bit=1;
	TRISB=0;
	TRISC = 0x00;

	//Lcd_Init();
	UART1_Init(9600);
	// SPI Initialization
	SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE,\
	_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	// MMC/SD Initialization
	while (1)
	{
		if (mmcInit() == 0)
		{	
			UWR("Card detected!");
			break;
		}
		initRetry++;
		if (initRetry == 50)
		{
			UWR("Card error, CPU trapped!");
			while (1); // Trap the CPU
		}
	}
	SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE,\
	_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);

	for ( ; ; )        // Repeats forever
	{
		/****** REWRITE NEW SETUP UI ******/
		while (SLCT != 0)        // Wait until SELECT pressed
		{
		}
		UWR("Select a Menu");
		while (OK)
		{
			if (!SLCT)
			{
				Delay_ms(300);
				mode++;
				if (mode == 3)
				{
					mode = 1;
				}
			}

			if ((mode == 1) & (lastMode != mode))
			{
				UWR("Record\n");
			}
			else if ((mode == 2) & (lastMode != mode))
			{
				UWR("Play\n");
			}
			lastMode = mode;					
		}
		/****** END REWRITE NEW SETUP UI ******/

		/**** BEGIN WORKING MODE *******/
		if (mode == 1) // Record
		{
			t = 0;
			UWR("Writing");
			PORTB = 0x00;
			//writeSingleBlock();
			// SPI Re-Initialization
			SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE,\
			_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
			// MMC/SD Re-Initialization
			while (1)
			{
				if (mmcInit() == 0)
				{	
					UWR("Card detected!");
					break;
				}
				initRetry++;
				if (initRetry == 50)
				{
					UWR("Card error, CPU trapped!");
					while (1); // Trap the CPU
				}
			}
			SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE,\
			_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
			
			/* Read total track to determine the address to write this track */
			totalTrack = readTotalTrack();
			if (totalTrack == 0) // Card is empty
			{
				trackAddr = 0; //  write on the beginning.
			}
			else // card is not empty, totalTrack != 0
			{
				/* Determine first free sector */
				for (i = 1; i <= totalTrack; i++)
				{
					trackAddr += readTrackMeta(i, _LENGTH) * 512; 
				}
				//trackAddr += 1; // first free location
			}
			/* Write a new track */			
			if (writeMultipleBlock(trackAddr))
			{
				UWR("Write error!");
			}
			else
			{
				UWR("STOPPED!")
				IntToStr(numberOfSectors, text);
				UWR("Written:")
				UWR(text);
				IntToStr(rejected, text);
				UWR("Lost: ");
				UWR(text); // Print out number of recjected sector
				addTrack(trackAddr, numberOfSectors);
				UWR("Track added!");
				trackList();
			}
		}

		if (mode == 2)
		{
			
			trackID = selectTrack();
			if (trackID != 0)
			{
				/* Get track address and track length */
				trackAddr = readTrackMeta(trackID, _ADDRESS);
				trackLength = readTrackMeta(trackID, _LENGTH);
				if (trackLength != 0)
				{
					/* Play the track */
					if (readMultipleBlock(trackAddr, trackLength))
					{
						UWR("Read error!"); 
					}
				}
				else
				{
					UWR("Track empty!");
				}
			}
			else 
			{
				//TODO:: play the whole card goes here
			}
			while (SLCT && OK) // return to main menu
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
	static volatile uint8_t totalTrack = 0;
	static volatile uint8_t trackID = 0;
	static volatile uint8_t text[7];
	static volatile uint8_t i;
	
	UWR("Which track to play?");
	totalTrack = readTotalTrack();
	if (totalTrack != 0)
	{
		do
		{
			for (i = 1; i <= totalTrack; i++)
			{
				IntToStr(i, text);
				UWR(text);
				while (SLCT)
				{
					if (!OK)
					{
						trackID = i;
						break;
					}
				}
				if (trackID != 0)
				{
					break;
				}
			}
		}
		while (trackID != 0); 
		return trackID;
	}
	else
	{
		return 0; // play the whole card
	}
}


void
addTrack(uint32_t address, uint32_t length)
{
	static volatile uint8_t romAddr;
	static volatile uint8_t totalTrack;
	
	totalTrack = EEPROM_Read(0x00) & 0b000111111; // Read the totalTrack value
	romAddr = 8*totalTrack; // address to place new track metadata
	/* Write new track address */
	EEPROM_Write((romAddr + 1), (uint8_t) address >> 24); // MSB first
	EEPROM_Write((romAddr + 2), (uint8_t) address >> 16);
	EEPROM_Write((romAddr + 3), (uint8_t) address >> 8);
	EEPROM_Write((romAddr + 4), (uint8_t) address);
	/* Write new track length */
	EEPROM_Write((romAddr + 5), (uint8_t) length >> 24); // MSB first
	EEPROM_Write((romAddr + 6), (uint8_t) length >> 16);
	EEPROM_Write((romAddr + 7), (uint8_t) length >> 8);
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
	static volatile uint8_t text[10];
	static volatile uint8_t totalTrack;
	static volatile i;
	
	totalTrack = readTotalTrack(); // beware of nesting fucntion call!
	
	if (totalTrack != 0)
	{
		UWR("Track list:");
		IntToStr(totalTrack, text); // convert total track to string
		UART_Write_Text("Total track: ");
		UWR(text);
		/* print track list */
		for (i = 1; i <= totalTrack; i++)
		{
			UART_Write_Text("Track ");
			IntToStr(i, text);
			UART_Write_Text(text);
			UART_Write_Text(": ");
			/* Write track address */
			// !!! Beware of nesting function call
			IntToStr((readTrackMeta(i, _ADDRESS)), text); // trackAddr to string
			UART_Write_Text(text); // write track address
			UART_Write_Text("  "); // write inline spaces
			/* Write track length */
			IntToStr((readTrackMeta(i, _LENGTH)), text); // trackLnght to strng
			UWR(text); // write track length and break line
		}
		UWR("*** END ***");
	}
	else 
	{
		// totalTrack = 0;
		UWR("No track available!");
	}
}

uint32_t
readTrackMeta(uint8_t trackID, uint8_t returnType)
{
	static volatile uint32_t trackAddr = 0;
	static volatile uint32_t trackLength = 0;
	static volatile uint8_t romAddr; // first rom location for track
	
	romAddr = 8 * (trackID - 1);
	if (returnType == _ADDRESS)
	{
		trackAddr |= (uint32_t) (EEPROM_Read(romAddr + 1) << 24); // MSB
		trackAddr |= (uint32_t) (EEPROM_Read(romAddr + 2) << 16);
		trackAddr |= (uint32_t) (EEPROM_Read(romAddr + 3) << 8);
		trackAddr |= (uint32_t) (EEPROM_Read(romAddr + 4)); // LSB
		return trackAddr;
	}
	else if (returnType == _LENGTH)
	{
		trackLength |= (uint32_t) (EEPROM_Read(romAddr + 5) << 24); // MSB
		trackLength |= (uint32_t) (EEPROM_Read(romAddr + 6) << 16);
		trackLength |= (uint32_t) (EEPROM_Read(romAddr + 7) << 8);
		trackLength |= (uint32_t) (EEPROM_Read(romAddr + 8)); // LSB
		return trackLength;		
	}
	else
	{
		return 0; // ERROR
	}
}

/******************************************************************************
uint8_t betterMmcInit(void)
New MMC/SD init function support more cards.
returns:
	0: success
	1: error, card not detected
******************************************************************************/
uint8_t
betterMmcInit(void)
{
	static volatile uint8_t u;
	
	Delay_ms(2); // Delay 2 ms after power up the card
	Mmc_Chip_Select = 1; // CS = 1
	for (u = 0; u < 10; u++) // send 80 dummy clocks	
	{
		spiWrite(0xff);
	}
	Mmc_Chip_Select = 0; // CS = 0
	
}

/******************************************************************************
uint8_t getResponse(uint8_t type);
Get R1, R3/R7 response from card.
return: 
	- respond : success
	- 0xff : error
******************************************************************************/
uint8_t getResponse(uint8_t type)
{
	static volatile uint8_t r1Respond;
	static volatile uint32_t r3Respond;
	static volatile uint8_t count = 0;
	
	if (type == R1) // get R1 respond
	{
		do 
		{
			spiReadData = spiRead();
			count++;
		}
		while (1); //TODO:: fix
	}
}