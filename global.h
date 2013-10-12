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

// Debug define
//#define DEBUG
#define WRITE_DEBUG
//#define READ_DEBUG
//#define HOME_TEST
#define REINIT_MMC
#define DEBUG_SELECT_TRACK
#define ADD_TEST_POINT // for determine the sampling frequency

// Sampling rate define (in microseconds)
#define MEASURED_SAMPLING_PERIOD 31 /* Measured by oscilloscope */
#define MMC_READ_DELAY 20
#define _MAXIMUM_RATE 0
#define _22_KSPS (45 - MEASURED_SAMPLING_PERIOD)
#define _16_KSPS (62 - MEASURED_SAMPLING_PERIOD)

#define SLCT RD2_bit
#define OK RD3_bit
#define DACOUT LATB
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
extern uint16_t *ptr;
extern uint16_t ptrIndex;
extern volatile uint8_t currentBuffer;
extern volatile uint8_t bufferFull;

#endif