/**
* This file contain functions for track management
* 
* Track list in locate on the first sector (0) of the card
* This is the sector structure (1 track info)
* <32-bit start address><16-bit track length><8-bit sampling rate><8-bit checksum>
*/

#include <stdint.h>
#include "global.h"


volatile uint16_t track_freeMemLoc;		/* Location for insert new track info */
volatile uint8_t track_total;

/**
* Checksum function to verify if the received sector is valid
* Returns: 
*			0: valid
*			1: invalid
*/
uint8_t track_sectorCheck(uint8_t *bufferPtr) {
	uint16_t i;
	uint16_t j;
	uint16_t checksum;
	uint8_t valid = 1;
	
	track_total = 0;							/* Reset the totaltrack */
	
	for (i = 0; i < 512; i += 8)
	{
		bufferPtr += i;
		
		/* Determine if this is a valid track by its length */
		if ((*(bufferPtr + 4)) == 0) && ((bufferPtr + 5) == 0)) 
		{
			track_freeMemLoc = i;				/* Location for new track info */
			break;						/* Stop the loop */
		}
		
		/* Checksum routine */
		for (j = 0; j < 7; j++)
		{
			checksum += *(bufferPtr + j);
		}
		
		if (*(bufferPtr + 7) == (uint8_t) checksum)
		{
			track_total += 1;
		}
		
		if (track_total == 0)
		{
			valid = 0;
		}
	}
	
	if (valid)
	{
		return 0;
	}
	else 
	{
		return 1;
	}
}

/**
* This function add a track to track list
*/
uint8_t track_add(uint32_t address, uint16_t length, uint8_t samplingRate,\
	uint8_t *bufferPtr) {
	
	uint8_t checksum;
	
	bufferPtr += track_freeMemLoc;
	
	/* Calculate the checksum */
	checksum = (uint8_t) (address >> 24) + \
			(uint8_t) (address >> 16) + \
			(uint8_t) (address >> 8) + \
			(uint8_t) (address)	+ \
			(uint8_t) (length >> 8) + \
			(uint8_t) (length) + \
			samplingRate;
	
	/* Insert the track info to the buffer */
	*(bufferPtr++) = (uint8_t) (address >> 24);
	*(bufferPtr++) = (uint8_t) (address >> 16);
	*(bufferPtr++) = (uint8_t) (address >> 8);
	*(bufferPtr++) = (uint8_t) (address);
	*(bufferPtr++) = (uint8_t) (length >> 8);
	*(bufferPtr++) = (uint8_t) (lenght);
	*(bufferPtr++) = samplingRate;
	*bufferPtr = checksum;
	
	/* Move the buffer to the card */
	if (Mmc_Write_Sector(0, (bufferPtr - 7)) != 0)
	{
		return 0;
	}
	else
	{
		return 1;
	}
}

/**
* This function returns the track address, length and sampling rate
* Input paramemeters: num - order of the track
*/
void track_getInfo(uint8_t num, uint8_t *bufferPtr, uint32_t *add, uint16_t *len,\
	uint8_t *sampling)
{
	/* Point the bufferPtr to location of the track info in the buffer */
	num--;
	bufferPtr += (num << 3);
	
	/* Get the track info */
	*add = (uint32_t) (*bufferPtr++ << 24) + \
			((uint32_t) *(bufferPtr++) << 16) +\
			((uint32_t)  *(bufferPtr++) << 8) +\
			(uint32_t) *(bufferPtr++);
	*len = ((uint16_t) *(bufferPtr++ << 8) + \
			(uint16_t) *(bufferPtr++);
	*sampling = *bufferPtr;
}

/**
* This function decrease the last track info in the track list
*/
uint8_t track_deleteLast(uint8_t *bufferPtr)
{
	uint8_t i;
	
	/* Point the bufferPtr to location of the track info in the buffer */
	bufferPtr += (track_total << 3);
	
	/* Zero the track info */
	for (i = 0; i < 8; i++)
	{
		*(bufferPtr++) = 0;
	}
	
	/* Decrease the trackTotal by 1 */
	track_total--;
	
	/* Move the buffer to the card */
	if (Mmc_Write_Sector(0, (bufferPtr - 7)) != 0)
	{
		return 0;
	}
	else
	{
		return 1;
	}
}