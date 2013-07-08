sfr sbit Mmc_Chip_Select at LATC2_bit;
sfr sbit Mmc_Chip_Select_Direction at TRISC2_bit;

#define TP0 LATC0_bit

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

#define GHI RD2_bit
#define DOC RD3_bit
#define dulieura PORTB
//#define dulieuvao PORTD

unsigned int j=0;
int       i,t=0,b,bien=0,x,tam=0;
unsigned int dulieu1, dulieu2;
char *text="000000";
unsigned int giatri;
void docADC()
{
        giatri=ADC_Read(0);
}

/*********** BEGIN ADC *****************/
void
adcInit(void)
{
        ADCON1 |= 0x0e; // AIN0 as analog input
        ADCON2 |= 0x2d; // 12 Tad and FOSC/16
        ADFM_bit = 0; // Left justified
        ADON_bit = 1; // Enable ADC module
        Delay_ms(100);
}

unsigned char
adcRead(void)
{
        TP0 = 1;
        Delay_us(8);
        GO_bit = 1; // Begin conversion
        while (!GO); // Wait for conversion completed
        TP0 = 0;
        return ADRESH;
}
/*********** END ADC *****************/

void caidatMMC()
{
        Lcd_Out(1,1,"Detecting MMC");
        Delay_ms(1000);
        SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);

        while (MMC_Init() != 0)
        {
        }
        // thiet lap toc do f/4 de bao dam luu du lieu
        SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
        LCD_CMD(_LCD_CLEAR);
        Lcd_Out(1,2,"MMC Detected");
        Delay_ms (1000);
}
//// ham ghi du lieu
unsigned int hamghi()
{
        char a[512];
        for(i=0; i<512; i++)
        {
                //TP0 = 1;
                //docADC();
                a[i] =  adcRead();
                //LATB = a[i];
//                TP0 = 0;
        }
        Mmc_Write_Sector(t,a);
        t++;
        return t;
}
/// ham doc du lieu tu sector
void hamdoc()
{
        char a[512];
        Mmc_Read_Sector(t,a);
        for(i=0; i< 512; i++)
        {dulieu1=a[i];
                dulieura=dulieu1;
                Delay_us(14);    // QD 40us
                if(GHI==0)
                {
                        bien=1;
                        SPI1_Write(0xff);
                        SPI1_Write (0xff);  //ghi phan hoi ngung doc card
                        SPI1_Write (0x8D);
                        break;
                }
        }
        t++;
}
unsigned int hamcaidat()
{
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Cmd(_LCD_CURSOR_OFF);
        while (1)
        {
                if(GHI==0)
                {
                        Delay_ms(500);
                        tam++;
                        if(tam==3)tam=1;

                }
                if(tam==1)Lcd_Out(1,6,"GHI");
                if(tam==2)Lcd_Out(1,6,"DOC");
                if(DOC==0)
                {
                        Lcd_Out(1,6,"SETUP OK");
                        return tam;
                        break;
                }
        }
}

void main()
{

        adcInit();
        TRISD=0xf3;
        TRISA2_bit=1;
        TRISD2_bit=1;
        TRISD3_bit=1;
        TRISB=0;
        TRISC = 0x00;

        Lcd_Init();
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Cmd(_LCD_CURSOR_OFF);

        // QUOCDAT
        Uart1_Init(9600);
        Delay_ms(100);

        caidatMMC();
        hamcaidat();
        
//        TRISB = 0x00;
//        TRISC = 0x00;
        if(tam==1)
        {
                Lcd_Cmd(_LCD_CLEAR);
                Lcd_Out(1,6,"DANG GHI");
                while (1)
                {
                        PORTB = 0;
                        hamghi();
                        if(GHI==0)break;}
                b=hamghi();
                x=b;
                text[3]=b/100 + 48 ;
                text[4]=(b/10)%10+48;
                text[5]=b%10+48;
                Lcd_Out(2,6,text);
                while (DOC==1){};
                Delay_ms(1000);
                Lcd_Cmd(_LCD_CLEAR);
                Lcd_Out(1,6,"DANG DOC");
                while (1)
                {
                        t=0;
                        while (1)
                        {hamdoc();
                                if(t>x)
                                {
                                        SPI1_Write(0xff);
                                        SPI1_Write(0xff);
                                        SPI1_Write(0x8D);
                                        break;
                                }
                                if(bien==1)break;
                        }
                        while(DOC==1){};
                }
        }
        if(tam==2)
        {
                Lcd_Cmd(_LCD_CLEAR);
                Lcd_Out(1,6,"DANG DOC");
                while(1)
                {t=0;
                        while(1)
                        {
                                hamdoc();
                                if(t>30000)
                                {
                                        SPI1_Write(0xff);
                                        SPI1_Write(0xff);
                                        SPI1_Write(0x8D);
                                        break;
                                }
                                if(bien==1)break;
                        }
                        while (DOC==1){};

                }
        }
}