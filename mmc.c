/**
* mmc.c
* author: Le Tran Quoc Dat
*/

#include "mmc.h"
#include "global.h"
#include <stdint.h>

uint8_t mmcInit(void)
{
	uint8_t u;
	volatile uint8_t error = 0;
	
	Delay_ms(2);
	CS = 1;
	for (u = 0; u < 10; u++)
	{
		spiWrite(0xff);
	}
	CS = 0;
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

void cardInit(uint8_t echo)
{
	uint8_t initRetry = 0;
	
	/* SPI Re-init */
	SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE,\
	_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	
	/* MMC/SD Re-Initialization */
	while (1)
	{
		if (mmcInit() == 0)
		{	
			if (echo == ECHO_ON)
			{
				UWR("Card detected!");
			}
			break;
		}
		initRetry++;
		if (initRetry == 50)
		{
			UWR("Card error, CPU trapped!");
			while (1); // Trap the CPU
		}
	}
	
	/* Change SPI clock to maximum */
	SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE,\
	_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
}

/******************************************************************************
MMC functions: 
- command(command, fourbyte_arg, CRCbits)
- writeSingleBlock() : write a single block
******************************************************************************/
void command(char command, uint32_t fourbyte_arg, char CRCbits)
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

void writeSingleBlock(void)
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

void readSingleBlock(void)
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
uint8_t sendCMD(uint8_t cmd, uint32_t arg)
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

/**
* uint8_t readMultipleBlock(uint32_t address, uint32_t length);
* Function to read multiple block from MMC/SD
* address : bye address to read (track address)
* length: number of bytes to read (track length)
* 
* returns: 
* 	0: success
* 	1: error
*/
uint8_t readMultipleBlock(uint8_t samplingRate, uint32_t address, uint32_t length)
{
	volatile uint16_t g;
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
				#ifdef READ_DEBUG
				spiReadData = spiRead();
				IntToStr(spiReadData, text);
				UWR(text);
				Delay_ms(2);
				#else
				TP0 = 1; /* Testpoint goes HIGH */
				
				/* Read a byte and output to the DAC */
				DACOUT = spiRead();
				
				/* Delay to meet the sampling period */
				switch (samplingRate)
				{
					case ENC_MAXIMUM_RATE:
					{
						Delay_us(MMC_READ_DELAY);
						break;
					}
					case ENC_22_KSPS:
					{
						Delay_us(MMC_READ_DELAY + _22_KSPS);
						break;
					}
					case ENC_16_KSPS:
					{
						Delay_us(MMC_READ_DELAY + _16_KSPS);
						break;
					}
				}
				
				TP0 = 0; /* Test point goes LOW */
				#endif
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