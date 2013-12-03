#ifndef _TRACK_H
#define _TRACK_H

#include <stdint.h>
#include "global.h"

/*
* This function add info for the next track
* 8-bit samplingRate (prev track) + 32-bit new track address
*/

void trackNext(uint32_t address, uint8_t samplingRate);

/*
* This function returns free address location for a new unrecorded track
*/
uint32_t trackFree(void);

/*
* This function get info for a recorded song
*/
struct songInfo trackGet(uint8_t track);

/*
* This function return total tracks available on the card.
* It first check for the security ID
* If the security ID is not valid, it will clear the sector a rewrite a new
* track management sector.
*/
uint8_t trackGetTotal(void);

#endif /* _TRACK_H */