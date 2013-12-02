#include "track.h"

/*
* This function add info for the next track
* 8-bit samplingRate (prev track) + 32-bit new track address
*/

void trackNext(uint32_t address, uint8_t samplingRate) 
{
	uint8_t totalTrack;
	uint8_t i = 0;
	
	totalTrack = trackGetTotal();
	
	/* Get free byte location to write new track info */
	i = 4 + totalTrack * 5;
	
	/* Write a new track info */
	buffer[i+1] = (uint8_t) samplingRate;
	buffer[i+2] = (uint8_t) address;		/* LSB */
	buffer[i+3] = (uint8_t) address >> 8;
	buffer[i+4] = (uint8_t) address >> 16;
	buffer[i+5] = (uint8_t) address >> 24;
	
	/* Increase total Track by 1 */
	totalTrack++;
	buffer[4] = totalTrack;
	
	/* Write new sector to info sector */
	mmcWrite(_INFO_SECTOR_, buffer0);
}

/*
* This function returns free address location for a new unrecorded track
*/
uint32_t trackFree(void)
{
	uint8_t totalTrack;
	uint8_t i;
	uint32_t address;
	
	totalTrack = trackGetTotal();
	
	i = 4 + totalTrack * 5;
	
	address = (uint32_t) (buffer[i] << 24 + \
						buffer[i-1] << 16 + \
						buffer[i-2] << 8 + \
						buffer[i-3]);
						
	return address;
}

/*
* This function get info for a recorded song
*/
struct songInfo trackGet(uint8_t track)
{
	struct songInfo song;
	uint8_t i = 0;
	
	/* Read the info sector of the card */
	while (mmcRead(_INFO_SECTOR_, buffer0) != 0);
	
	/* Calculate the track location in buffer sector */
	i = 4 + track * 5;
	
	if (track != 1)
	{
		/* Return the track information */
		song.address = (uint32_t) (buffer[i-8] + \
						buffer[i-7] << 8 + \
						buffer[i-6] << 16 + \
						buffer[i-5] << 24);
		song.samplingRate = buffer[i-4];
		song.nextAddress = (uint32_t) (buffer[i-3] + \
						buffer[i-2] << 8 + \
						buffer[i-1] << 15 + \
						buffer[i] << 24);
	}
	else
	{
		/* Return track 1 info */
		song.address = 0;
		song.samplingRate = buffer[5];
		song.nextAdress = (uint32_t) (buffer[6] + \
							buffer[7] << 8 + \
							buffer[8] << 16 + \
							buffer[9] << 24);
	}
	
	return song;
}


/*
* This function return total tracks available on the card.
* It first check for the security ID
* If the security ID is not valid, it will clear the sector a rewrite a new
* track management sector.
*/
uint8_t trackGetTotal(void)
{
	uint8_t i;
	uint8_t totalTrack = 0;
	
	/* Read the info sector of the card */
	while (mmcRead(_INFO_SECTOR_, buffer0) != 0);
	
	/* IDs check */
	if (buffer[0] != ID0)
	else if (buffer[1] != ID1)
	else if (buffer[2] != ID2)
	else if (buffer[3] != ID3) {
		/* Sector not contain true ids, wipe out */
		for (i = 0; i < 512; i++) {
			buffer[i] = 0;
		}
		buffer[0] = ID0;
		buffer[1] = ID1;
		buffer[2] = ID2;
		buffer[3] = ID3;
	}
	else {
		/* Sector contain valid information */
		/*-- Read number of tracks */
		totalTrack = buffer[4];
	}
	
	return totalTrack
}