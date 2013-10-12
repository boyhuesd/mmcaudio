/**
* adc.h
*/

#ifndef _ADC_H
#define _ADC_H

#include <stdint.h>

void adcInit(void);
uint8_t adcRead(void);
void specialEventTriggerSetup(void);
void specialEventTriggerStart(void);


#endif /* _ADC_H */