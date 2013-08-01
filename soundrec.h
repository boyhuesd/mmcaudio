uint8_t
betterMmcInit(void);

uint8_t
getResponse(uint8_t type);

/******************************************************************************
EEPROM data placement (00h - ffh)
[8-bits totalTrack][32-bits trackAdd1][32-bits trackLength1][32-bits trackAdd2]

totalTrack = 0b101xxxxxx - 101 to verify that a real total track
TODO:: need to write a block that verify totalTrack when the program start, if 
totalTrack is not verified, initialize it as 0 (0b101000000)

void addTrack(uint32_t address, uint32_t length)
Function to add the sectors recored in current session to the eeprom
Returns: none

void readTotalTrack()
Function to read the total track in the EEPROM, if total track is not a valid 
number, initialize it at 0.
returns: totalTrack

void trackList()
Function print track list via UART.

uint32_t readTrackMeta(uint8_t trackID, uint8_t returnType)
Function returns track address or track length.

uint8_t selectTrack(void)
An UI that ask for which track to play.
returns: trackID
******************************************************************************/

uint8_t
selectTrack(void);

void
addTrack(uint32_t address, uint32_t length); // track address, numberOfSectors

uint8_t
readTotalTrack(void);

void
trackList(void);

uint32_t
readTrackMeta(uint8_t trackID, uint8_t returnType);

