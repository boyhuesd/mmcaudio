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
******************************************************************************/
#include <stdint.h>

sfr sbit Mmc_Chip_Select at LATC2_bit;
sfr sbit Mmc_Chip_Select_Direction at TRISC2_bit;

#define TP0 LATC0_bit
#define UWR(x) UART_Write_Text(x);\
	UART_Write(13);\
	UART_Write(10);

#define spiWrite(x) SPI1_Write(x)
#define spiRead() SPI1_Read(0xff)

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
//#define dulieuvao PORTD

volatile unsigned char samplingRate = 1;
volatile unsigned int mode = 0;
volatile unsigned int t = 0;
volatile unsigned char x;
volatile uint8_t error;
volatile uint16_t numberOfSectors;
volatile uint8_t spiReadData;
volatile uint32_t arg = 0;
volatile uint8_t count;

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
	while (GO); // Wait for conversion completed
	//TP0 = 0;
	return ADRESH;
}
/*********** END ADC *****************/

void caidatMMC()
{
	UWR("Detecting MMC");
	Delay_ms(1000);
	SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE,\
	_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);

	while (MMC_Init() != 0)
	{
	}
	// change spi clock rate to achive maximum speed
	SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE,\
	_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	UWR("MMC Detected!");
	Delay_ms (1000);
}


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

void
mmcInit(void)
{
	uint8_t u;
	SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE,\
	_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	Delay_ms(2);
	Mmc_Chip_Select = 1;
	UWR("CS is HIGH!");
	for (u = 0; u < 10; u++)
	{
		spiWrite(0xff);
	}
	UWR("Dummy clock sent!");
	Mmc_Chip_Select = 0;
	UWR("CS is LOW!\n");
	Delay_ms(1);
	command(0, 0, 0x95);
	UWR("CMD0 sent!");
	count = 0;
	while ((spiReadData != 1) && (count < 10))
	{
		spiReadData = spiRead();
		count++;
	}
	if (count >= 10)
	{
		UWR("CARD ERROR - CMD0");
		while (1); // Trap the CPU
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
		UWR("Card ERROR - CMD1");
		while (1); // Trap the CPU
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
		UWR("Card error - CMD16");
		while (1); // Trap the CPU
	}
	UWR("MMC Detected!");
	// change spi clock rate to achive maximum speed
	SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV16, _SPI_DATA_SAMPLE_MIDDLE,\
	_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	Delay_ms(20);
	
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
	UWR("Card free!");
	
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

void
writeMultipleBlock(void)
{
	volatile uint16_t g;
	volatile uint8_t text[10];
	volatile uint16_t rejected = 0;
	
	while (1)
	{
		if (sendCMD(25, 0))
		{
			UWR("Command rejected!");
			Delay_ms(10);
		}
		else
		{
			break;
		}
	}
	UWR("Command accepted!");
	spiWrite(0xff);
	spiWrite(0xff);
	spiWrite(0xff); // Dummy clock
	numberOfSectors = 0; // Initialize the number of sector will be recorded
	while (SLCT) // repeat until Select button pressed
	{
		spiWrite(0b11111100); // Data token for CMD 25
		for (g = 0; g < 512; g++)
		{
			spiWrite((uint8_t) g);
			IntToStr(g, text);
			UWR(text);
			Delay_ms(2);
		} // write a block of 512 bytes data
		spiWrite(0xff);
		spiWrite(0xff); // 2 bytes CRC
		// check if the data is accepted
		count = 0;
		while (count < 8)
		{
			spiReadData = spiRead();
			if ((spiReadData & 0b00011111) == 0x05)
			{
				//UWR("Data accepted!");
				numberOfSectors++;
				break;
			}
			count++;
		}
		if (count >= 8)
		{
			//UWR("Data rejected!");
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
	UWR("STOPPED!")
	IntToStr(numberOfSectors, text);
	UWR("Written:")
	UWR(text);
	IntToStr(rejected, text);
	UWR("Lost: ");
	UWR(text); // Print out number of recjected sector
}


void
readMultipleBlock(void)
{
	volatile uint16_t g;
	volatile uint8_t text[7];
	volatile uint16_t sectorIndex = 0;
	// 1. Make sure the card is not busy
	do 
	{
		spiReadData = spiRead();
	}
	while (spiReadData != 0xff);
	// 2. Send CMD 18 to read multiple block
	command(18, arg, 0x95);
	count = 0;
	do // verify R1 respond
	{
		if (spiReadData == 0)
		{
			UWR("Command accepted!");
			break;
		}
		spiReadData = spiRead();
		count++;
	}
	while (count < 10);
	if (count >= 10)
	{
		UWR("Command Rejected!");
		while (1); // Trap the CPU
	}
	while (sectorIndex < numberOfSectors)
	{
		// 3. Read until received data token
		do 
		{
			spiReadData = spiRead();
		}
		while (spiReadData != 0xfe);
		// 4. Read 512 bytes of data
		for (g = 0; g < 512; g++)
		{
			spiReadData = spiRead();
			IntToStr(spiReadData, text);
			UWR(text);
			Delay_ms(2);
		}
		// 5. Read 2 bytes CRC
		spiReadData = spiRead();
		spiReadData = spiRead();
		sectorIndex++;
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
	while (1); // Trap the CPU
}

//// ham ghi du lieu
/* TODO:: Need to write MMC Write error handling */
void hamghi(void)
{
	unsigned int i;
	char a[512];
	for(i=0; i<512; i++)
	{
		TP0 = 1;
		Delay_us(15);
		TP0 = 0;
		a[i] =  adcRead();
		//a[i] = i;  // !TESTING 
		//writeDelay(samplingRate);  // Sampling delay
	}
	//MMC_Write_Sector(t, a);
	error = MMC_Write_Sector(t, a);
	if (error == 1)
	{
		UWR("Command error!");
	}
	else if (error == 2)
	{
		UWR("Write error!");
	}
	t++;
}

/// ham doc du lieu tu sector
void hamdoc()
{
	unsigned int i;
	char a[512];
	char txt[7];
	if (Mmc_Read_Sector(t, a)) 
	{
		UWR("Read error!");
	}
	for(i=0; i< 512; i++)
	{
		DACOUT = a[i];
		//readDelay(samplingRate);
		Delay_us(25);
	}
	t++;
}

unsigned int hamcaidat()
{
	Lcd_Cmd(_LCD_CLEAR);
	Lcd_Cmd(_LCD_CURSOR_OFF);
	while (1)
	{
		if(SLCT==0)
		{
			Delay_ms(500);
			mode++;
			if(mode==3)mode=1;

		}
		// if(mode==1)Lcd_Out(1,6, codeToRam(infWrt));
		// if(mode==2)Lcd_Out(1,6,codeToRam(infRd));
		if (mode == 1) UWR("Record");
		if (mode == 2) UWR("Play");
		if(OK==0)
		{
			//Lcd_Out(1,6,"SETUP OK");
			return mode;
			break;
		}
	}
}

void main()
{
	unsigned char select;
	unsigned char lastMode;
	char strNumOfSec[7];

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
	mmcInit();

	for ( ; ; )        // Repeats forever
	{
		/****** REWRITE NEW SETUP GUI ******/
		while (SLCT != 0)        // Wait until SELECT pressed
		{
		}
		// LCD_CMD(_LCD_CLEAR);
		// LCD_CMD(_LCD_CURSOR_OFF);
		// LCD_OUT(1, 1, codeToRam(infModeSlct));
		
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
				//LCD_OUT(2, 1, codeToRam(infWrt));
				UWR("Record\n");
			}
			else if ((mode == 2) & (lastMode != mode))
			{
				//LCD_OUT(2, 1, codeToRam(infRd));
				UWR("Play\n");
			}
			// else
			// {
			// LCD_OUT(2, 1, codeToRam(infSamplingSelect));
			// }
			lastMode = mode;					
		}
		/****** END REWRITE NEW SETUP GUI ******/

		/**** BEGIN WORKING MODE *******/
		if (mode == 1)
		{
			t = 0;
			UWR("Writing");
			PORTB = 0x00;
			//writeSingleBlock();
			writeMultipleBlock();
		}

		if (mode == 2)
		{
			// LCD_CMD(_LCD_CLEAR);
			// LCD_OUT(1, 6, codeToRam(infRdng));
			UWR("Reading");
			t = 0;
			//readSingleBlock();
			readMultipleBlock();
			while (SLCT && OK)
			{
			}
		}
		/**** END WORKING MODE *******/
	}
}