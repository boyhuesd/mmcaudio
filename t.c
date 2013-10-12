/******************************************************************************
uint8_t selectTrack
returns:
	- trackID
	- 0: play the whole card
******************************************************************************/
uint8_t
selectTrack(void)
{
	uint8_t temp = 0;
	uint8_t trackID;
	uint8_t i = 1;
	
	UWR("Whch?");
	temp = readTotalTrack();
	trackID = 0;
	if (temp != 0)
	{
		while (OK)
		{
			if (!SLCT)
			{
				Delay_ms(300);
				i++;
				if (i == (temp + 1))
				{
					i = 1;
				}
			}
			
			trackID = i;
			IntToStr(i, text);
			UWR(text);
			Delay_ms(200);
		}
		
		return trackID;
	}
	else
	{
		return 0; // play the whole card
	}
}

/*
* void addTrack(uint32_t address, uint32_t length)
* Caution! Sampling rate will be place at 8MSBs in address.
* This function add the track to tracklist on EEPROM.
* Arguments: address: 32 bit address of the track
* 			 length: 32 bit length of the track
* Returns: none
*/
void
addTrack(uint32_t address, uint32_t length)
{
	static volatile uint8_t romAddr;
	static volatile uint8_t totalTrack;
	
	/* Encode the sampling rate to address's first octet */
	address &= 0x1fffffff; /* Clear the first 3 MSBs */
	switch (samplingDelay)
	{
		case _MAXIMUM_RATE:
		{
			address |= (ENC_MAXIMUM_RATE << 29);
			break;
		}
		case _22_KSPS:
		{
			address |= (ENC_22_KSPS << 29);
			break;
		}
		case _16_KSPS:
		{
			address |= (ENC_16_KSPS << 29);
			break;
		}
	}
	totalTrack = EEPROM_Read(0x00) & 0b000111111; // Read the totalTrack value
	romAddr = 8*totalTrack; // Address to place new track metadata
	/* Write new track address */
	EEPROM_Write((romAddr + 1), (uint8_t) (address >> 24)); // MSB first
	EEPROM_Write((romAddr + 2), (uint8_t) (address >> 16));
	EEPROM_Write((romAddr + 3), (uint8_t) (address >> 8));
	EEPROM_Write((romAddr + 4), (uint8_t) address);
	/* Write new track length */
	EEPROM_Write((romAddr + 5), (uint8_t) (length >> 24)); // MSB first
	EEPROM_Write((romAddr + 6), (uint8_t) (length >> 16));
	EEPROM_Write((romAddr + 7), (uint8_t) (length >> 8));
	EEPROM_Write((romAddr + 8), (uint8_t) length);
	/* Write new totalTrack */
	totalTrack++;
	totalTrack |= 0b10100000;
	EEPROM_Write(0x00, totalTrack);
}

uint8_t
readTotalTrack(void)
{
	static volatile uint8_t totalTrack;
	
	totalTrack = EEPROM_Read(0x00);
	// check if totalTrack is a valid number
	if (((totalTrack & 0b11100000) >> 5) != 0x05)
	{
		// invalid, totalTrack = 0;
		EEPROM_Write(0x00, 0b10100000);
		return 0;
	}
	else
	{
		// valid, return totalTrack
		totalTrack &= 0b00011111;
		return totalTrack;
	}
}

void
trackList(void)
{
	uint8_t tTrack;
	uint8_t t;
	uint8_t temp;
	
	tTrack = readTotalTrack(); // beware of nesting fucntion call!
	
	if (tTrack != 0)
	{
		UWR("Track list:");
		temp = tTrack;
		IntToStr(temp, text); // convert total track to string
		UART_Write_Text("Tk: ");
		UWR(text);
		/* print track list */
		for (t = 1; t <= temp; t++)
		{
			UART_Write_Text("Tr ");
			IntToStr(t, text);
			UART_Write_Text(text);
			UART_Write_Text(": ");
			/* Write track address */
			// !!! Beware of nesting function call
			LongWordToStr((readTrackMeta(t, _ADDRESS)), text); // trackAddr to string
			UART_Write_Text(text); // write track address
			UART_Write_Text("  "); // write inline spaces
			/* Write track length */
			LongWordToStr((readTrackMeta(t, _LENGTH)), text); // trackLnght to strng
			UWR(text); // write track length and break line
		}
	}
	else 
	{
		// tTrack = 0;
		UWR("e!");						/* No track avaiable */
	}
}

uint32_t
readTrackMeta(uint8_t trackID, uint8_t returnType)
{
	uint32_t returnInfo = 0;
	uint8_t romAddr; // first rom location for track
	
	romAddr = 8 * (trackID - 1);
	switch (returnType)
	{
		case _ADDRESS:
		{
			returnInfo |= (uint32_t) (EEPROM_Read(romAddr + 1) << 24); // MSB
			returnInfo |= (uint32_t) (EEPROM_Read(romAddr + 2) << 16);
			returnInfo |= (uint32_t) (EEPROM_Read(romAddr + 3) << 8);
			returnInfo |= (uint32_t) (EEPROM_Read(romAddr + 4)); // LSB
			returnInfo &= 0x1fffffff; /* Clear 3 MSBs */
			break;
		}
		case _LENGTH:
		{
			returnInfo |= (uint32_t) (EEPROM_Read(romAddr + 5) << 24); // MSB
			returnInfo |= (uint32_t) (EEPROM_Read(romAddr + 6) << 16);
			returnInfo |= (uint32_t) (EEPROM_Read(romAddr + 7) << 8);
			returnInfo |= (uint32_t) (EEPROM_Read(romAddr + 8)); // LSB
			break;
		}
		case _TRACK_SAMPLING_RATE:
		{
			returnInfo = (uint32_t) (EEPROM_Read(romAddr + 1) >> 5);
			break;
		}
		default:
		{
			break;
		}
	}
	return returnInfo;
}


/******************************************************************************
uint8_t changeSamplingRate();
UI to prompt user select sampling rate
returns: delay amount
******************************************************************************/
uint8_t
changeSamplingRate()
{
	static uint8_t select, lastSelect;
	static uint8_t delay = _MAXIMUM_RATE;
	
	select = 1;
	lastSelect = 0;
	
	while (!OK || !SLCT); // make sure none are pressed
	UWR("Select sampling rate:");
	while (OK)
	{
		if (!SLCT)
		{
			Delay_ms(300);
			select++;
			if (select == 4)
			{
				select = 1;
			}
		}
		
		if ((select == 1) & (lastSelect != select))
		{
			UWR("-- Max");
			delay = _MAXIMUM_RATE;
		}
		else if ((select == 2) & (lastSelect != select))
		{
			UWR("-- 22");
			delay = _22_KSPS;
		}
		else if ((select == 3) & (lastSelect != select))
		{
			UWR("-- 16");
			delay = _16_KSPS;
		}
		
		lastSelect = select;
	}
	return delay;
}