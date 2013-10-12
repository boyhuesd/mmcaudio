/**
* This file contain code for ISRs
* author: Le Tran Quoc Dat
*/

#include "interrupt.h"
#include "global.h"

/**
* A/D conversion interrupt routine
* This move the ADC result to the buffer array.
*/
void interrupt(void)
{
	if (PIR1 & (1 << ADIF)) 
	{
		/* Move the result to buffer */
		*(ptr + (ptrIndex++)) = ADRESH;
		
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


