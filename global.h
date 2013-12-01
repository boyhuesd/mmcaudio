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

/* For track management */

#endif