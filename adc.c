/**
* adc.h
* Functions for A/D conversions
*/

#include "adc.h"

/**
* This function start the A/D conversion, polling GO bit and return the ADC
* result
*/
uint8_t adcRead(void)
{
	GO_bit = 1; 						// Begin conversion
	while (GO_bit); 					// Wait for conversion completed
	return ADRESH;
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
	ADCON0 |= (1 << ADON);	
}