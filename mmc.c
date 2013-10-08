/**
* mmc.c
* author: Le Tran Quoc Dat
*/

#include mmc.h
#include stdint.h

uint8_t mmcInit(void)
{
	uint8_t u;
	volatile uint8_t error = 0;
	
	Delay_ms(2);
	Mmc_Chip_Select = 1;
	for (u = 0; u < 10; u++)
	{
		spiWrite(0xff);
	}
	Mmc_Chip_Select = 0;
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
