#line 1 "E:/DEV/Embedded/PIC/mmc_audio/mikroc/soundrec.c"
#line 1 "e:/mikroelektronika/mikroc pro for pic/include/stdint.h"




typedef signed char int8_t;
typedef signed int int16_t;
typedef signed long int int32_t;


typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
typedef unsigned long int uint32_t;


typedef signed char int_least8_t;
typedef signed int int_least16_t;
typedef signed long int int_least32_t;


typedef unsigned char uint_least8_t;
typedef unsigned int uint_least16_t;
typedef unsigned long int uint_least32_t;



typedef signed char int_fast8_t;
typedef signed int int_fast16_t;
typedef signed long int int_fast32_t;


typedef unsigned char uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned long int uint_fast32_t;


typedef signed int intptr_t;
typedef unsigned int uintptr_t;


typedef signed long int intmax_t;
typedef unsigned long int uintmax_t;
#line 16 "E:/DEV/Embedded/PIC/mmc_audio/mikroc/soundrec.c"
sfr sbit Mmc_Chip_Select at LATC2_bit;
sfr sbit Mmc_Chip_Select_Direction at TRISC2_bit;
#line 27 "E:/DEV/Embedded/PIC/mmc_audio/mikroc/soundrec.c"
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






volatile unsigned char samplingRate = 1;
volatile unsigned int mode = 0;
volatile unsigned int t = 0;
volatile unsigned char x;
volatile unsigned int numberOfSectors = 0;
volatile unsigned char error;
volatile uint8_t spiReadData;
volatile uint32_t arg;
volatile uint8_t count;

char* codeToRam(const char* ctxt){
 static char txt[20];
 char i;
 for(i =0; txt[i] = ctxt[i]; i++);

 return txt;
}




unsigned char
adcRead(void)
{

 Delay_us(8);
 GO_bit = 1;
 while (!GO);

 return ADRESH;
}


void caidatMMC()
{

  UART_Write_Text("Detecting MMC"); UART_Write(13); UART_Write(10); ;
 Delay_ms(1000);
#line 104 "E:/DEV/Embedded/PIC/mmc_audio/mikroc/soundrec.c"
 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);

 while (MMC_Init() != 0)
 {
 }
#line 111 "E:/DEV/Embedded/PIC/mmc_audio/mikroc/soundrec.c"
 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);


  UART_Write_Text("MMC Detected!"); UART_Write(13); UART_Write(10); ;
 Delay_ms (1000);
}
#line 124 "E:/DEV/Embedded/PIC/mmc_audio/mikroc/soundrec.c"
void
command(char command, uint32_t fourbyte_arg, char CRCbits)
{
  SPI1_Write(0xff) ;
  SPI1_Write(0b01000000 | command) ;
  SPI1_Write((uint8_t) (fourbyte_arg >> 24)) ;
  SPI1_Write((uint8_t) (fourbyte_arg >> 16)) ;
  SPI1_Write((uint8_t) (fourbyte_arg >> 8)) ;
  SPI1_Write((uint8_t) (fourbyte_arg)) ;
  SPI1_Write(CRCbits) ;
 spiReadData =  SPI1_Read(0xff) ;
}

void
writeSingleBlock(void)
{
 uint16_t g = 0;
  SPI1_Write(0xff) ;

 spiReadData =  SPI1_Read(0xff) ;
 while (spiReadData != 0xff)
 {
 spiReadData =  SPI1_Read(0xff) ;
  UART_Write_Text("Card busy!"); UART_Write(13); UART_Write(10); ;
 }

 command(24, arg, 0x95);

 while (spiReadData != 0)
 {
 spiReadData =  SPI1_Read(0xff) ;
 }
  UART_Write_Text("Command accepted!"); UART_Write(13); UART_Write(10); ;
  SPI1_Write(0xff) ;
  SPI1_Write(0xff) ;
  SPI1_Write(0b11111110) ;
 for (g = 0; g < 512; g++)
 {
  SPI1_Write(0x99) ;
 }
  SPI1_Write(0xff) ;
  SPI1_Write(0xff) ;
 spiReadData =  SPI1_Read(0xff) ;

 if ((spiReadData & 0b00011111) == 0x05)
 {
  UART_Write_Text("Data accepted!"); UART_Write(13); UART_Write(10); ;
 }
 spiReadData =  SPI1_Read(0xff) ;
 while (spiReadData != 0xff)
 {
 spiReadData =  SPI1_Read(0xff) ;
 }
  UART_Write_Text("Card is idle"); UART_Write(13); UART_Write(10); ;
}



void hamghi(void)
{
 unsigned int i;
 char a[512];
 for(i=0; i<512; i++)
 {
  LATC0_bit  = 1;
 Delay_us(15);
  LATC0_bit  = 0;
 a[i] = adcRead();


 }

 error = MMC_Write_Sector(t, a);
 if (error == 1)
 {
  UART_Write_Text("Command error!"); UART_Write(13); UART_Write(10); ;
 }
 else if (error == 2)
 {
  UART_Write_Text("Write error!"); UART_Write(13); UART_Write(10); ;
 }
 t++;
}


void hamdoc()
{
 unsigned int i;
 char a[512];
 char txt[7];
 if (Mmc_Read_Sector(t, a))
 {
  UART_Write_Text("Read error!"); UART_Write(13); UART_Write(10); ;
 }
 for(i=0; i< 512; i++)
 {
  LATB  = a[i];

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
 if( RD2_bit ==0)
 {
 Delay_ms(500);
 mode++;
 if(mode==3)mode=1;

 }


 if (mode == 1)  UART_Write_Text("Record"); UART_Write(13); UART_Write(10); ;
 if (mode == 2)  UART_Write_Text("Play"); UART_Write(13); UART_Write(10); ;
 if( RD3_bit ==0)
 {

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


 ADCON1 |= 0x0e;
 ADCON2 |= 0x2d;
 ADFM_bit = 0;
 ADON_bit = 1;
 Delay_ms(100);


 TRISD=0xf3;
 TRISA2_bit=1;
 TRISD2_bit=1;
 TRISD3_bit=1;
 TRISB=0;
 TRISC = 0x00;


 UART1_Init(9600);
 caidatMMC();






 for ( ; ; )
 {

 while ( RD2_bit  != 0)
 {
 }




  UART_Write_Text("Select a Menu"); UART_Write(13); UART_Write(10); ;
 while ( RD3_bit )
 {
 if (! RD2_bit )
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

  UART_Write_Text("Record\n"); UART_Write(13); UART_Write(10); ;
 }
 else if ((mode == 2) & (lastMode != mode))
 {

  UART_Write_Text("Play\n"); UART_Write(13); UART_Write(10); ;
 }




 lastMode = mode;
 }
#line 385 "E:/DEV/Embedded/PIC/mmc_audio/mikroc/soundrec.c"
 if (mode == 1)
 {



 t = 0;
  UART_Write_Text("Writing"); UART_Write(13); UART_Write(10); ;
 PORTB = 0x00;
#line 415 "E:/DEV/Embedded/PIC/mmc_audio/mikroc/soundrec.c"
 writeSingleBlock();

 }

 if (mode == 2)
 {


  UART_Write_Text("Reading"); UART_Write(13); UART_Write(10); ;
 t = 0;
 numberOfSectors = 0;

 x = EEPROM_Read(0x82);
 numberOfSectors |= x << 8;
 Delay_ms(25);
 x = EEPROM_Read(0x81);
 numberOfSectors |= x;
 IntToStr(numberOfSectors, strNumOfSec);
  UART_Write_Text(strNumOfSec); UART_Write(13); UART_Write(10); ;
 while(t < numberOfSectors)
 {
 hamdoc();





 }



 SPI1_Write(0xff);
 SPI1_Write(0xff);
 SPI1_Write(0x8D);



  UART_Write_Text("Stopped. Press anykey!"); UART_Write(13); UART_Write(10); ;
 while ( RD2_bit  &&  RD3_bit )
 {
 }
 }

 }
}
