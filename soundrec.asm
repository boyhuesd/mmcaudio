
_codeToRam:

;soundrec.c,55 :: 		char* codeToRam(const char* ctxt){
;soundrec.c,58 :: 		for(i =0; txt[i] = ctxt[i]; i++);
	CLRF        R3 
L_codeToRam0:
	MOVLW       codeToRam_txt_L0+0
	MOVWF       R1 
	MOVLW       hi_addr(codeToRam_txt_L0+0)
	MOVWF       R2 
	MOVF        R3, 0 
	ADDWF       R1, 1 
	BTFSC       STATUS+0, 0 
	INCF        R2, 1 
	MOVF        R3, 0 
	ADDWF       FARG_codeToRam_ctxt+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       0
	ADDWFC      FARG_codeToRam_ctxt+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      FARG_codeToRam_ctxt+2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVFF       R1, FSR1
	MOVFF       R2, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_codeToRam1
	INCF        R3, 1 
	GOTO        L_codeToRam0
L_codeToRam1:
;soundrec.c,60 :: 		return txt;
	MOVLW       codeToRam_txt_L0+0
	MOVWF       R0 
	MOVLW       hi_addr(codeToRam_txt_L0+0)
	MOVWF       R1 
;soundrec.c,61 :: 		}
L_end_codeToRam:
	RETURN      0
; end of _codeToRam

_adcRead:

;soundrec.c,113 :: 		adcRead(void)
;soundrec.c,116 :: 		Delay_us(8);
	MOVLW       13
	MOVWF       R13, 0
L_adcRead3:
	DECFSZ      R13, 1, 1
	BRA         L_adcRead3
;soundrec.c,117 :: 		GO_bit = 1; // Begin conversion
	BSF         GO_bit+0, BitPos(GO_bit+0) 
;soundrec.c,118 :: 		while (!GO); // Wait for conversion completed
L_adcRead5:
;soundrec.c,120 :: 		return ADRESH;
	MOVF        ADRESH+0, 0 
	MOVWF       R0 
;soundrec.c,121 :: 		}
L_end_adcRead:
	RETURN      0
; end of _adcRead

_caidatMMC:

;soundrec.c,124 :: 		void caidatMMC()
;soundrec.c,127 :: 		UWR("Detecting MMC");
	MOVLW       ?lstr1_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr1_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,128 :: 		Delay_ms(1000);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_caidatMMC6:
	DECFSZ      R13, 1, 1
	BRA         L_caidatMMC6
	DECFSZ      R12, 1, 1
	BRA         L_caidatMMC6
	DECFSZ      R11, 1, 1
	BRA         L_caidatMMC6
	NOP
;soundrec.c,129 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,131 :: 		while (MMC_Init() != 0)
L_caidatMMC7:
	CALL        _Mmc_Init+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_caidatMMC8
;soundrec.c,133 :: 		}
	GOTO        L_caidatMMC7
L_caidatMMC8:
;soundrec.c,135 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV4, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	CLRF        FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,138 :: 		UWR("MMC Detected!");
	MOVLW       ?lstr2_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,139 :: 		Delay_ms (1000);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_caidatMMC9:
	DECFSZ      R13, 1, 1
	BRA         L_caidatMMC9
	DECFSZ      R12, 1, 1
	BRA         L_caidatMMC9
	DECFSZ      R11, 1, 1
	BRA         L_caidatMMC9
	NOP
;soundrec.c,140 :: 		}
L_end_caidatMMC:
	RETURN      0
; end of _caidatMMC

_hamghi:

;soundrec.c,144 :: 		void hamghi(void)
;soundrec.c,148 :: 		for(i=0; i<512; i++)
	CLRF        hamghi_i_L0+0 
	CLRF        hamghi_i_L0+1 
L_hamghi10:
	MOVLW       2
	SUBWF       hamghi_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamghi69
	MOVLW       0
	SUBWF       hamghi_i_L0+0, 0 
L__hamghi69:
	BTFSC       STATUS+0, 0 
	GOTO        L_hamghi11
;soundrec.c,150 :: 		TP0 = 1;
	BSF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;soundrec.c,151 :: 		Delay_us(15);
	MOVLW       24
	MOVWF       R13, 0
L_hamghi13:
	DECFSZ      R13, 1, 1
	BRA         L_hamghi13
	NOP
	NOP
;soundrec.c,152 :: 		TP0 = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;soundrec.c,153 :: 		a[i] =  adcRead();
	MOVLW       hamghi_a_L0+0
	ADDWF       hamghi_i_L0+0, 0 
	MOVWF       FLOC__hamghi+0 
	MOVLW       hi_addr(hamghi_a_L0+0)
	ADDWFC      hamghi_i_L0+1, 0 
	MOVWF       FLOC__hamghi+1 
	CALL        _adcRead+0, 0
	MOVFF       FLOC__hamghi+0, FSR1
	MOVFF       FLOC__hamghi+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;soundrec.c,148 :: 		for(i=0; i<512; i++)
	INFSNZ      hamghi_i_L0+0, 1 
	INCF        hamghi_i_L0+1, 1 
;soundrec.c,156 :: 		}
	GOTO        L_hamghi10
L_hamghi11:
;soundrec.c,158 :: 		error = MMC_Write_Sector(t, a);
	MOVF        _t+0, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+0 
	MOVF        _t+1, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+1 
	MOVLW       0
	MOVWF       FARG_Mmc_Write_Sector_sector+2 
	MOVWF       FARG_Mmc_Write_Sector_sector+3 
	MOVLW       hamghi_a_L0+0
	MOVWF       FARG_Mmc_Write_Sector_dbuff+0 
	MOVLW       hi_addr(hamghi_a_L0+0)
	MOVWF       FARG_Mmc_Write_Sector_dbuff+1 
	CALL        _Mmc_Write_Sector+0, 0
	MOVF        R0, 0 
	MOVWF       _error+0 
;soundrec.c,159 :: 		if (error == 1)
	MOVF        _error+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_hamghi14
;soundrec.c,161 :: 		UWR("Command error!");
	MOVLW       ?lstr3_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,162 :: 		}
	GOTO        L_hamghi15
L_hamghi14:
;soundrec.c,163 :: 		else if (error == 2)
	MOVF        _error+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_hamghi16
;soundrec.c,165 :: 		UWR("Write error!");
	MOVLW       ?lstr4_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr4_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,166 :: 		}
L_hamghi16:
L_hamghi15:
;soundrec.c,167 :: 		t++;
	MOVLW       1
	ADDWF       _t+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _t+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _t+0 
	MOVF        R1, 0 
	MOVWF       _t+1 
;soundrec.c,168 :: 		}
L_end_hamghi:
	RETURN      0
; end of _hamghi

_hamdoc:

;soundrec.c,171 :: 		void hamdoc()
;soundrec.c,176 :: 		if (Mmc_Read_Sector(t, a))
	MOVF        _t+0, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+0 
	MOVF        _t+1, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+1 
	MOVLW       0
	MOVWF       FARG_Mmc_Read_Sector_sector+2 
	MOVWF       FARG_Mmc_Read_Sector_sector+3 
	MOVLW       hamdoc_a_L0+0
	MOVWF       FARG_Mmc_Read_Sector_dbuff+0 
	MOVLW       hi_addr(hamdoc_a_L0+0)
	MOVWF       FARG_Mmc_Read_Sector_dbuff+1 
	CALL        _Mmc_Read_Sector+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_hamdoc17
;soundrec.c,178 :: 		UWR("Read error!");
	MOVLW       ?lstr5_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr5_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,179 :: 		}
L_hamdoc17:
;soundrec.c,180 :: 		for(i=0; i< 512; i++)
	CLRF        hamdoc_i_L0+0 
	CLRF        hamdoc_i_L0+1 
L_hamdoc18:
	MOVLW       2
	SUBWF       hamdoc_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamdoc71
	MOVLW       0
	SUBWF       hamdoc_i_L0+0, 0 
L__hamdoc71:
	BTFSC       STATUS+0, 0 
	GOTO        L_hamdoc19
;soundrec.c,182 :: 		DACOUT = a[i];
	MOVLW       hamdoc_a_L0+0
	ADDWF       hamdoc_i_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(hamdoc_a_L0+0)
	ADDWFC      hamdoc_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       LATB+0 
;soundrec.c,184 :: 		Delay_us(25);
	MOVLW       41
	MOVWF       R13, 0
L_hamdoc21:
	DECFSZ      R13, 1, 1
	BRA         L_hamdoc21
	NOP
;soundrec.c,180 :: 		for(i=0; i< 512; i++)
	INFSNZ      hamdoc_i_L0+0, 1 
	INCF        hamdoc_i_L0+1, 1 
;soundrec.c,185 :: 		}
	GOTO        L_hamdoc18
L_hamdoc19:
;soundrec.c,186 :: 		t++;
	MOVLW       1
	ADDWF       _t+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _t+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _t+0 
	MOVF        R1, 0 
	MOVWF       _t+1 
;soundrec.c,187 :: 		}
L_end_hamdoc:
	RETURN      0
; end of _hamdoc

_hamcaidat:

;soundrec.c,254 :: 		unsigned int hamcaidat()
;soundrec.c,256 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,257 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,258 :: 		while (1)
L_hamcaidat22:
;soundrec.c,260 :: 		if(SLCT==0)
	BTFSC       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_hamcaidat24
;soundrec.c,262 :: 		Delay_ms(500);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_hamcaidat25:
	DECFSZ      R13, 1, 1
	BRA         L_hamcaidat25
	DECFSZ      R12, 1, 1
	BRA         L_hamcaidat25
	DECFSZ      R11, 1, 1
	BRA         L_hamcaidat25
	NOP
;soundrec.c,263 :: 		mode++;
	MOVLW       1
	ADDWF       _mode+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _mode+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _mode+0 
	MOVF        R1, 0 
	MOVWF       _mode+1 
;soundrec.c,264 :: 		if(mode==3)mode=1;
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamcaidat73
	MOVLW       3
	XORWF       _mode+0, 0 
L__hamcaidat73:
	BTFSS       STATUS+0, 2 
	GOTO        L_hamcaidat26
	MOVLW       1
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
L_hamcaidat26:
;soundrec.c,266 :: 		}
L_hamcaidat24:
;soundrec.c,269 :: 		if (mode == 1) UWR("Record");
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamcaidat74
	MOVLW       1
	XORWF       _mode+0, 0 
L__hamcaidat74:
	BTFSS       STATUS+0, 2 
	GOTO        L_hamcaidat27
	MOVLW       ?lstr6_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr6_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
L_hamcaidat27:
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,270 :: 		if (mode == 2) UWR("Play");
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamcaidat75
	MOVLW       2
	XORWF       _mode+0, 0 
L__hamcaidat75:
	BTFSS       STATUS+0, 2 
	GOTO        L_hamcaidat28
	MOVLW       ?lstr7_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr7_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
L_hamcaidat28:
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,271 :: 		if(OK==0)
	BTFSC       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_hamcaidat29
;soundrec.c,274 :: 		return mode;
	MOVF        _mode+0, 0 
	MOVWF       R0 
	MOVF        _mode+1, 0 
	MOVWF       R1 
	GOTO        L_end_hamcaidat
;soundrec.c,276 :: 		}
L_hamcaidat29:
;soundrec.c,277 :: 		}
	GOTO        L_hamcaidat22
;soundrec.c,278 :: 		}
L_end_hamcaidat:
	RETURN      0
; end of _hamcaidat

_main:

;soundrec.c,280 :: 		void main()
;soundrec.c,287 :: 		ADCON1 |= 0x0e; // AIN0 as analog input
	MOVLW       14
	IORWF       ADCON1+0, 1 
;soundrec.c,288 :: 		ADCON2 |= 0x2d; // 12 Tad and FOSC/16
	MOVLW       45
	IORWF       ADCON2+0, 1 
;soundrec.c,289 :: 		ADFM_bit = 0; // Left justified
	BCF         ADFM_bit+0, BitPos(ADFM_bit+0) 
;soundrec.c,290 :: 		ADON_bit = 1; // Enable ADC module
	BSF         ADON_bit+0, BitPos(ADON_bit+0) 
;soundrec.c,291 :: 		Delay_ms(100);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main30:
	DECFSZ      R13, 1, 1
	BRA         L_main30
	DECFSZ      R12, 1, 1
	BRA         L_main30
	DECFSZ      R11, 1, 1
	BRA         L_main30
	NOP
	NOP
;soundrec.c,294 :: 		TRISD=0xf3;
	MOVLW       243
	MOVWF       TRISD+0 
;soundrec.c,295 :: 		TRISA2_bit=1;
	BSF         TRISA2_bit+0, BitPos(TRISA2_bit+0) 
;soundrec.c,296 :: 		TRISD2_bit=1;
	BSF         TRISD2_bit+0, BitPos(TRISD2_bit+0) 
;soundrec.c,297 :: 		TRISD3_bit=1;
	BSF         TRISD3_bit+0, BitPos(TRISD3_bit+0) 
;soundrec.c,298 :: 		TRISB=0;
	CLRF        TRISB+0 
;soundrec.c,299 :: 		TRISC = 0x00;
	CLRF        TRISC+0 
;soundrec.c,302 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	MOVLW       2
	MOVWF       SPBRGH+0 
	MOVLW       8
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;soundrec.c,303 :: 		caidatMMC();
	CALL        _caidatMMC+0, 0
;soundrec.c,310 :: 		for ( ; ; )        // Repeats forever
L_main31:
;soundrec.c,313 :: 		while (SLCT != 0)        // Wait until SELECT pressed
L_main34:
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main35
;soundrec.c,315 :: 		}
	GOTO        L_main34
L_main35:
;soundrec.c,320 :: 		UWR("Select a Menu");
	MOVLW       ?lstr8_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr8_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,321 :: 		while (OK)
L_main36:
	BTFSS       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_main37
;soundrec.c,323 :: 		if (!SLCT)
	BTFSC       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main38
;soundrec.c,325 :: 		Delay_ms(300);
	MOVLW       8
	MOVWF       R11, 0
	MOVLW       157
	MOVWF       R12, 0
	MOVLW       5
	MOVWF       R13, 0
L_main39:
	DECFSZ      R13, 1, 1
	BRA         L_main39
	DECFSZ      R12, 1, 1
	BRA         L_main39
	DECFSZ      R11, 1, 1
	BRA         L_main39
	NOP
	NOP
;soundrec.c,326 :: 		mode++;
	MOVLW       1
	ADDWF       _mode+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _mode+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _mode+0 
	MOVF        R1, 0 
	MOVWF       _mode+1 
;soundrec.c,327 :: 		if (mode == 3)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main77
	MOVLW       3
	XORWF       _mode+0, 0 
L__main77:
	BTFSS       STATUS+0, 2 
	GOTO        L_main40
;soundrec.c,329 :: 		mode = 1;
	MOVLW       1
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
;soundrec.c,330 :: 		}
L_main40:
;soundrec.c,331 :: 		}
L_main38:
;soundrec.c,333 :: 		if ((mode == 1) & (lastMode != mode))
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main78
	MOVLW       1
	XORWF       _mode+0, 0 
L__main78:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main79
	MOVF        _mode+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main79:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main41
;soundrec.c,336 :: 		UWR("Record\n");
	MOVLW       ?lstr9_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr9_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,337 :: 		}
	GOTO        L_main42
L_main41:
;soundrec.c,338 :: 		else if ((mode == 2) & (lastMode != mode))
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main80
	MOVLW       2
	XORWF       _mode+0, 0 
L__main80:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main81
	MOVF        _mode+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main81:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main43
;soundrec.c,341 :: 		UWR("Play\n");
	MOVLW       ?lstr10_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr10_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,342 :: 		}
L_main43:
L_main42:
;soundrec.c,347 :: 		lastMode = mode;
	MOVF        _mode+0, 0 
	MOVWF       main_lastMode_L0+0 
;soundrec.c,348 :: 		}
	GOTO        L_main36
L_main37:
;soundrec.c,412 :: 		if (mode == 1)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main82
	MOVLW       1
	XORWF       _mode+0, 0 
L__main82:
	BTFSS       STATUS+0, 2 
	GOTO        L_main44
;soundrec.c,417 :: 		t = 0;
	CLRF        _t+0 
	CLRF        _t+1 
;soundrec.c,418 :: 		UWR("Writing");
	MOVLW       ?lstr11_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr11_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,419 :: 		PORTB = 0x00;
	CLRF        PORTB+0 
;soundrec.c,420 :: 		while (SLCT)
L_main45:
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main46
;soundrec.c,422 :: 		hamghi();
	CALL        _hamghi+0, 0
;soundrec.c,423 :: 		}
	GOTO        L_main45
L_main46:
;soundrec.c,425 :: 		Delay_ms(25);
	MOVLW       163
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main47:
	DECFSZ      R13, 1, 1
	BRA         L_main47
	DECFSZ      R12, 1, 1
	BRA         L_main47
;soundrec.c,426 :: 		EEPROM_Write(0x81, t);
	MOVLW       129
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        _t+0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;soundrec.c,427 :: 		Delay_ms(25);
	MOVLW       163
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main48:
	DECFSZ      R13, 1, 1
	BRA         L_main48
	DECFSZ      R12, 1, 1
	BRA         L_main48
;soundrec.c,428 :: 		EEPROM_Write(0x82, t >> 8);
	MOVLW       130
	MOVWF       FARG_EEPROM_Write_address+0 
	MOVF        _t+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVF        R0, 0 
	MOVWF       FARG_EEPROM_Write_data_+0 
	CALL        _EEPROM_Write+0, 0
;soundrec.c,429 :: 		Delay_ms(25);
	MOVLW       163
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main49:
	DECFSZ      R13, 1, 1
	BRA         L_main49
	DECFSZ      R12, 1, 1
	BRA         L_main49
;soundrec.c,430 :: 		IntToStr(t, strNumOfSec);
	MOVF        _t+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _t+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_strNumOfSec_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_strNumOfSec_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,431 :: 		UWR(strNumOfSec);
	MOVLW       main_strNumOfSec_L0+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(main_strNumOfSec_L0+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,434 :: 		Delay_ms(500);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_main50:
	DECFSZ      R13, 1, 1
	BRA         L_main50
	DECFSZ      R12, 1, 1
	BRA         L_main50
	DECFSZ      R11, 1, 1
	BRA         L_main50
	NOP
;soundrec.c,435 :: 		UWR("STOPPED");
	MOVLW       ?lstr12_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr12_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,436 :: 		UWR("Press any key!");
	MOVLW       ?lstr13_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr13_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,439 :: 		while (SLCT && OK)
L_main51:
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main52
	BTFSS       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_main52
L__main64:
;soundrec.c,441 :: 		}
	GOTO        L_main51
L_main52:
;soundrec.c,443 :: 		}
L_main44:
;soundrec.c,445 :: 		if (mode == 2)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main83
	MOVLW       2
	XORWF       _mode+0, 0 
L__main83:
	BTFSS       STATUS+0, 2 
	GOTO        L_main55
;soundrec.c,449 :: 		UWR("Reading");
	MOVLW       ?lstr14_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr14_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,450 :: 		t = 0;
	CLRF        _t+0 
	CLRF        _t+1 
;soundrec.c,451 :: 		numberOfSectors = 0;
	CLRF        _numberOfSectors+0 
	CLRF        _numberOfSectors+1 
;soundrec.c,453 :: 		x = EEPROM_Read(0x82);
	MOVLW       130
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _x+0 
;soundrec.c,454 :: 		numberOfSectors |= x << 8;
	MOVF        _x+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R0, 0 
	IORWF       _numberOfSectors+0, 1 
	MOVF        R1, 0 
	IORWF       _numberOfSectors+1, 1 
;soundrec.c,455 :: 		Delay_ms(25);
	MOVLW       163
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main56:
	DECFSZ      R13, 1, 1
	BRA         L_main56
	DECFSZ      R12, 1, 1
	BRA         L_main56
;soundrec.c,456 :: 		x = EEPROM_Read(0x81);
	MOVLW       129
	MOVWF       FARG_EEPROM_Read_address+0 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _x+0 
;soundrec.c,457 :: 		numberOfSectors |= x;
	MOVF        _x+0, 0 
	IORWF       _numberOfSectors+0, 1 
	MOVLW       0
	IORWF       _numberOfSectors+1, 1 
;soundrec.c,458 :: 		IntToStr(numberOfSectors, strNumOfSec);
	MOVF        _numberOfSectors+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _numberOfSectors+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_strNumOfSec_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_strNumOfSec_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,459 :: 		UWR(strNumOfSec);
	MOVLW       main_strNumOfSec_L0+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(main_strNumOfSec_L0+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,460 :: 		while(t < numberOfSectors)
L_main57:
	MOVF        _numberOfSectors+1, 0 
	SUBWF       _t+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main84
	MOVF        _numberOfSectors+0, 0 
	SUBWF       _t+0, 0 
L__main84:
	BTFSC       STATUS+0, 0 
	GOTO        L_main58
;soundrec.c,462 :: 		hamdoc();
	CALL        _hamdoc+0, 0
;soundrec.c,468 :: 		}
	GOTO        L_main57
L_main58:
;soundrec.c,472 :: 		SPI1_Write(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,473 :: 		SPI1_Write(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,474 :: 		SPI1_Write(0x8D);
	MOVLW       141
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,478 :: 		UWR("Stopped. Press anykey!");
	MOVLW       ?lstr15_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr15_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,479 :: 		while (SLCT && OK)
L_main59:
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main60
	BTFSS       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_main60
L__main63:
;soundrec.c,481 :: 		}
	GOTO        L_main59
L_main60:
;soundrec.c,482 :: 		}
L_main55:
;soundrec.c,484 :: 		}
	GOTO        L_main31
;soundrec.c,485 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
