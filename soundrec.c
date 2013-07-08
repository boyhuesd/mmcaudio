#include <stdint.h>

sfr sbit Mmc_Chip_Select at LATC2_bit;
sfr sbit Mmc_Chip_Select_Direction at TRISC2_bit;
sfr sbit CS at LATC2_bit;

#define TP0 LATC0_bit
#define UWR(x) UART_Write_Text(x);\
				UART_Write(13);\
				UART_Write(10);

#define spiWrite(x) SPI1_Write(x)
#define spiRead() SPI1_Read(0xff)

sbit LCD_RS at LATD0_bit;
sbit LCD_EN at LATD1_bit;
sbit LCD_D7 at LATD7_bit;
sbit LCD_D6 at LATD6_bit;
sbit LCD_D5 at LATD5_bit;
sbit LCD_D4 at LATD4_bit;


sbit LCD_RS_Direction at TRISD0_bit;
sbit LCD_EN_Direction at TRISD1_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;

const char infProgName[] = "AUDIO RECORDER";
const char infPressSelect[] = "PRESS SELECT!";
const char infModeSlct[] = "CHOOSE A MENU";
const char infSamplingSelect[] = "SLCT SMPLNG RATE";
const char infSamplingSelected[] = "SMPLNG RATE SLCTD";
const char inf8Ksps[] = "8 KSPS";
const char inf16Ksps[] = "16 KSPS";
const char infMax[] = "MAXIMUM";
const char infMMCDttng[] = "DETECTING MMC";
const char infMMCDttd[] = "MMC DETECTED";
const char infWrtng[] = "RECORDING!";
const char infRdng[] = "PLAYING";
const char infWrt[] = "RECORD";
const char infRd[] = "PLAY  ";
const char infPressToStop[] = "PRSS SLCT TO STP";
const char infStopped[] = "STOPPED";
const char infPressAnyKey[] = "PRESS ANY KEY!";

#define SLCT RD2_bit
#define OK RD3_bit
#define DACOUT LATB
//#define dulieuvao PORTD

volatile unsigned char samplingRate = 1;
volatile unsigned int mode = 0;
volatile unsigned int t = 0;
volatile unsigned char x;
volatile unsigned int numberOfSectors = 0;
volatile unsigned char error;
volatile uint8_t spiReadData;

char* codeToRam(const char* ctxt){
        static char txt[20];
        char i;
        for(i =0; txt[i] = ctxt[i]; i++);

        return txt;
}



/*********** BEGIN ADC *****************/
unsigned char
adcRead(void)
{
        //TP0 = 1;
        Delay_us(8);
        GO_bit = 1; // Begin conversion
        while (!GO); // Wait for conversion completed
        //TP0 = 0;
        return ADRESH;
}
/*********** END ADC *****************/

void caidatMMC()
{
        //Lcd_Out(1,1, codeToRam(infMMCDttng));  // Detecting MMC
		UWR("Detecting MMC");
        Delay_ms(1000);
        SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE,\
		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);

        while (MMC_Init() != 0)
        {
        }
        // change spi clock rate to achive maximum speed
        SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE,\
		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
        //LCD_CMD(_LCD_CLEAR);
        //Lcd_Out(1,2, codeToRam(infMMCDttd));  // MMC Detected
		UWR("MMC Detected!");
        Delay_ms (1000);
}


/******************************************************************************
MMC functions: 
- command(command, fourbyte_arg, CRCbits)
- writeSingleBlock() : write a single block
******************************************************************************/
void
command(char command, uint32_t fourbyte_arg, char CRCbitss)
{
	spiWrite(0xff);
	spiWrite(0b01000000 | command);
	spiWrite((uint8_t) (fourbyte_arg >> 24));
	spiWrite((uint8_t) (fourbyte_arg >> 16));
	spiWrite((uint8_t) (fourbyte_arg >> 8));
	spiWrite((uint8_t) (fourbyte_art));
	spiWrite(CRCbits);
	spiReadData = spiRead();
}

void
writeSingleBlock(void)
{
	spiWrite(0xff);
	// check if the card is ready to receive command
	spiReadData = spiRead();
	while (spiReadData != 0xff)
	{
		spiReadData = spiRead();
		UWR("Card busy!");
	}
	// Send CMD 24 to write single block
	
}

//// ham ghi du lieu
/* TODO:: Need to write MMC Write error handling */
void hamghi(void)
{
        unsigned int i;
        char a[512];
        for(i=0; i<512; i++)
        {
                TP0 = 1;
                Delay_us(15);
                TP0 = 0;
                a[i] =  adcRead();
				//a[i] = i;  // !TESTING 
                //writeDelay(samplingRate);  // Sampling delay
        }
		//MMC_Write_Sector(t, a);
		error = MMC_Write_Sector(t, a);
        if (error == 1)
		{
			UWR("Command error!");
		}
		else if (error == 2)
		{
			UWR("Write error!");
		}
        t++;
}

/// ham doc du lieu tu sector
void hamdoc()
{
        unsigned int i;
        char a[512];
		char txt[7];
        if (Mmc_Read_Sector(t, a)) 
		{
			UWR("Read error!");
		}
        for(i=0; i< 512; i++)
        {
                DACOUT = a[i];
                //readDelay(samplingRate);
				Delay_us(25);
        }
        t++;
}

unsigned int hamcaidat()
{
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Cmd(_LCD_CURSOR_OFF);
        while (1)
        {
                if(SLCT==0)
                {
                        Delay_ms(500);
                        mode++;
                        if(mode==3)mode=1;

                }
                // if(mode==1)Lcd_Out(1,6, codeToRam(infWrt));
                // if(mode==2)Lcd_Out(1,6,codeToRam(infRd));
				if (mode == 1) UWR("Record");
				if (mode == 2) UWR("Play");
                if(OK==0)
                {
                        //Lcd_Out(1,6,"SETUP OK");
                        return mode;
                        break;
                }
        }
}

void main()
{
        unsigned char select;
		unsigned char lastMode;
		char strNumOfSec[7];

        // adcInit();
        ADCON1 |= 0x0e; // AIN0 as analog input
        ADCON2 |= 0x2d; // 12 Tad and FOSC/16
        ADFM_bit = 0; // Left justified
        ADON_bit = 1; // Enable ADC module
        Delay_ms(100);

        /**** END ADC INIT ****/
        TRISD=0xf3;
        TRISA2_bit=1;
        TRISD2_bit=1;
        TRISD3_bit=1;
        TRISB=0;
        TRISC = 0x00;

        //Lcd_Init();
		UART1_Init(9600);
        caidatMMC();
        // Welcome message
        // LCD_CMD(_LCD_CLEAR);
        // LCD_CMD(_LCD_CURSOR_OFF);
        // LCD_OUT(1, 1, codeToRam(infProgName));
        // LCD_OUT(2, 1, codeToRam(infPressSelect));

        for ( ; ; )        // Repeats forever
        {
                /****** REWRITE NEW SETUP GUI ******/
                while (SLCT != 0)        // Wait until SELECT pressed
                {
                }
                // LCD_CMD(_LCD_CLEAR);
                // LCD_CMD(_LCD_CURSOR_OFF);
                // LCD_OUT(1, 1, codeToRam(infModeSlct));
				
				UWR("Select a Menu");
                while (OK)
                {
					if (!SLCT)
					{
							Delay_ms(300);
							mode++;
							if (mode == 3)
							{
									mode = 1;
							}
					}

					if ((mode == 1) & (lastMode != mode))
					{
							//LCD_OUT(2, 1, codeToRam(infWrt));
							UWR("Record\n");
					}
					else if ((mode == 2) & (lastMode != mode))
					{
							//LCD_OUT(2, 1, codeToRam(infRd));
							UWR("Play\n");
					}
					// else
					// {
							// LCD_OUT(2, 1, codeToRam(infSamplingSelect));
					// }
					lastMode = mode;					
                }
                /****** END REWRITE NEW SETUP GUI ******/

                /********** BEGIN SAMPLING SETUP *********
                if (mode == 3)
                {
                        LCD_CMD(_LCD_CLEAR);
                        LCD_CMD(_LCD_CURSOR_OFF);
                        LCD_OUT(1, 1, codeToRam(infSamplingSelect));
                        Delay_ms(100);
                        samplingRate = 1;
                        LCD_OUT(2, 6, "8 KSPS");
                        select = 0;

                        while (OK != 0)
                        {
                                if (SLCT == 0)
                                {
                                        Delay_ms(500);
                                        select++;
                                        if (select == 4)
                                        {
                                                select = 1;
                                        }
                                }

                                if (select == 1)
                                {
                                        LCD_OUT(2, 6, codeToRam(inf8Ksps));
                                        samplingRate = 1;
                                }
                                if (select == 2)
                                {
                                        LCD_OUT(2, 6, codeToRam(inf16Ksps));
                                        samplingRate = 2;
                                }
                                if (select == 3)
                                {
                                        LCD_OUT(2, 6, codeToRam(infMax));
                                        samplingRate = 3;
                                }
                        }
                        // Save new sampling rate
                        LCD_CMD(_LCD_CLEAR);
                        //LCD_CMD(_LCD_CURSOR_OFF);
                        LCD_OUT(1, 1, codeToRam(infSamplingSelected));
                        if (select == 1)
                        {
                                LCD_OUT(2, 4, codeToRam(inf8Ksps));
                        }
                        if (select == 2)
                        {
                                LCD_OUT(2, 4, codeToRam(inf16Ksps));
                        }
                        if (select == 3)
                        {
                                LCD_OUT(2, 4, codeToRam(infMax));
                        }
                        Delay_ms(1000);
                }
                ********* END SAMPLING SETUP *********/


                /**** BEGIN WORKING MODE *******/
                if (mode == 1)
                {
                        // Lcd_Cmd(_LCD_CLEAR);
                        // Lcd_Out(1, 1, codeToRam(infWrtng)); //DANG GHI
                        // LCD_OUT(2, 1, codeToRam(infPressToStop));
						t = 0;
						UWR("Writing");
                        PORTB = 0x00;
                        while (SLCT)
                        {
                                hamghi();
                        }
                        // Writing number of sectors to EEPROM
						Delay_ms(25);
                        EEPROM_Write(0x81, t);
                        Delay_ms(25);
                        EEPROM_Write(0x82, t >> 8);
                        Delay_ms(25);
						IntToStr(t, strNumOfSec);
						UWR(strNumOfSec);

                        //LCD_CMD(_LCD_CLEAR);
                        Delay_ms(500);
						UWR("STOPPED");
						UWR("Press any key!");
                        // LCD_OUT(1, 1, codeToRam(infStopped));
                        // LCD_OUT(2, 1, codeToRam(infPressAnykey));
                        while (SLCT && OK)
                        {
                        }

                }

                if (mode == 2)
                {
                        // LCD_CMD(_LCD_CLEAR);
                        // LCD_OUT(1, 6, codeToRam(infRdng));
						UWR("Reading");
                        t = 0;
						numberOfSectors = 0;
                        // Reading number of sectors from EEPROM
                        x = EEPROM_Read(0x82);
                        numberOfSectors |= x << 8;
                        Delay_ms(25);
                        x = EEPROM_Read(0x81);
                        numberOfSectors |= x;
						IntToStr(numberOfSectors, strNumOfSec);
						UWR(strNumOfSec);
                         while(t < numberOfSectors)
                        {
                                hamdoc();
								// LATB = 0xff;
								// Delay_ms(50);
								// LATB = 0xf0;
								// Delay_ms(50);
								
                        }
						// t = 1;
						//hamdoc();
                        // Stop reading MMC
                        SPI1_Write(0xff);
                        SPI1_Write(0xff);
                        SPI1_Write(0x8D);
                        // LCD_CMD(_LCD_CLEAR);
                        // LCD_OUT(1, 1, codeToRam(infStopped));
                        // LCD_OUT(2, 1, codeToRam(infPressAnyKey));
						UWR("Stopped. Press anykey!");
                        while (SLCT && OK)
                        {
                        }
                }
                /**** END WORKING MODE *******/
        }
}