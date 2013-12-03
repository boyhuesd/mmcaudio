#ifndef _GLOBAL_H
#define _GLOBAL_H

#include "string.h"
#include <stdint.h>

/*
* Function aliases
*/
#define spiWrite(x) SPI1_Write(x)
#define spiRead() SPI1_Read(0xff)

#define UWR(x) UART_Write_Text(x);\
	UART_Write(13);\
	UART_Write(10);

// Error definition
#define initERROR_CMD0 1
#define initERROR_CMD1 2
#define initERROR_CMD16 3
// EEPROM Fucntion definition
#define _LENGTH 1
#define _ADDRESS 0
#define _TRACK_SAMPLING_RATE 2
// respond type
#define _R1 0
#define _R3 1
#define _R7 1
#define _RESPOND_ERROR 0xff

// Sampling rate define (in microseconds)
#define MEASURED_SAMPLING_PERIOD 31 /* Measured by oscilloscope */
#define MMC_READ_DELAY 20
#define _MAXIMUM_RATE 0
#define _22_KSPS (45 - MEASURED_SAMPLING_PERIOD)
#define _16_KSPS (62 - MEASURED_SAMPLING_PERIOD)

#define SLCT RB0_bit
#define OK RB1_bit
#define DACOUT LATD
#define TP0 LATD7_bit
#define CS LATC2_bit
#define CS_DIR TRISC2_bit

#define _MULTIPLE_BLOCK 1

#define ECHO_ON 1
#define ECHO_OFF 0


/* Defines for sampling rate encoded to EEPROM */
#define ENC_MAXIMUM_RATE 0
#define ENC_22_KSPS 1
#define ENC_16_KSPS 2



#define lcdClear()				Lcd_Cmd(_LCD_CLEAR)
#define lcdDisplay(x, y, z) 	Lcd_Out(x, y, z);

/**
* Global variables 
*/
extern volatile unsigned int mode;
extern volatile unsigned int t;
extern volatile unsigned char x;
extern volatile uint8_t error;
extern volatile uint32_t numberOfSectors;
extern volatile uint8_t spiReadData;
extern volatile uint32_t arg;
extern volatile uint8_t count;
extern volatile uint16_t rejected;
extern volatile uint8_t samplingDelay;
extern volatile uint8_t text[10];

extern volatile uint8_t buffer0[512];
extern volatile uint8_t buffer1[512];
extern volatile uint8_t currentBuffer;
extern volatile uint8_t bufferFull;

/*----- Variables for track management ---------------------------------------*/
struct songInfo
{
	uint32_t address;
	uint32_t nextAddress;
	uint8_t samplingRate;
};

/* For track management */
#define			ID0 0xfe
#define 		ID1 0xf1
#define			ID2	0xf2
#define 		ID3	0xf3

#define INFO_SECTOR			0
#define FIRST_DATA_SECTOR 	64

#define mmcWrite(index, buffer) Mmc_Write_Sector(index, buffer) 
#define mmcRead(index, buffer) Mmc_Read_Sector(index, buffer) 

/* Definitions for hardware timing */
#define _16KHZ				0
#define _8KHZ				1
#define _16KHZ_HIGHBYTE		0xfe
#define	_16KHZ_LOWBYTE		0xc7
#define _8KHZ_HIGHBYTE		0xfd
#define _8KHZ_LOWBYTE		0x8e

#endif /* _GLOBAL_H */