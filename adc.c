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
	//ADCON2 |= (1 << ADFM);			
	ADCON0 |= (1 << ADON);	

	/* Enable ADC interrupt */
	//PIE1 |= (1 << ADIE);
}