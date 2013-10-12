#ifndef _MMC_H
#define _MMC_H

#include <stdint.h>
#include "global.h"

void cardInit(uint8_t echo);
uint8_t mmcInit(void);
void command(char command, uint32_t fourbyte_arg, char CRCbits);
void writeSingleBlock(void);
void readSingleBlock(void);
uint8_t sendCMD(uint8_t cmd, uint32_t arg);
uint8_t readMultipleBlock(uint8_t samplingRate, uint32_t address, uint32_t length);
uint8_t writeInit(uint8_t writeMode, uint32_t address);
uint8_t write(uint8_t writeMode, uint16_t *buffer);
void writeStop(void);

#endif	/* _MMC_H */