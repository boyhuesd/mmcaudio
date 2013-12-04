
_codeToRam:

;soundrec.c,135 :: 		char* codeToRam(const char* ctxt)
;soundrec.c,139 :: 		for(i =0; txt[i] = ctxt[i]; i++);
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
;soundrec.c,141 :: 		return txt;
	MOVLW       codeToRam_txt_L0+0
	MOVWF       R0 
	MOVLW       hi_addr(codeToRam_txt_L0+0)
	MOVWF       R1 
;soundrec.c,142 :: 		}
L_end_codeToRam:
	RETURN      0
; end of _codeToRam

_main:

;soundrec.c,144 :: 		void main()
;soundrec.c,153 :: 		ptrIndex = 0;
	CLRF        soundrec_ptrIndex+0 
	CLRF        soundrec_ptrIndex+1 
;soundrec.c,154 :: 		currentBuffer = 0;
	CLRF        _currentBuffer+0 
;soundrec.c,155 :: 		bufferFull = 0;
	CLRF        _bufferFull+0 
;soundrec.c,156 :: 		mode = 0;
	CLRF        _mode+0 
;soundrec.c,157 :: 		adcResult = 0;
	CLRF        _adcResult+0 
;soundrec.c,160 :: 		INTCON2 &= ~(1 << 7); // nRBPU = 0
	MOVLW       127
	ANDWF       INTCON2+0, 1 
;soundrec.c,162 :: 		ptr = &buffer0[0];
	MOVLW       _buffer0+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,163 :: 		adcInit();
	CALL        _adcInit+0, 0
;soundrec.c,164 :: 		Delay_ms(100);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	DECFSZ      R11, 1, 1
	BRA         L_main3
	NOP
	NOP
;soundrec.c,168 :: 		TRISD = 0x00; 							// Output for DAC0808
	CLRF        TRISD+0 
;soundrec.c,169 :: 		TRISB = (1 << RB0) | (1 << RB1); 		// B0, B1 input; remains output
	MOVLW       3
	MOVWF       TRISB+0 
;soundrec.c,170 :: 		TRISC &= ~((1 << 2) | (1 << 6)); 					// Output for CS pin
	MOVLW       187
	ANDWF       TRISC+0, 1 
;soundrec.c,173 :: 		LATD = 0x40;
	MOVLW       64
	MOVWF       LATD+0 
;soundrec.c,176 :: 		Lcd_Init();								// Init LCD for display
	CALL        _Lcd_Init+0, 0
;soundrec.c,177 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,178 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,179 :: 		Lcd_Out(1, 2, codeToRam(lcd_welcome));
	MOVLW       _lcd_welcome+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_lcd_welcome+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_lcd_welcome+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	CALL        _Lcd_Out+0, 0
;soundrec.c,185 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,188 :: 		while (MMC_Init() != 0)
L_main4:
	CALL        _Mmc_Init+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main5
;soundrec.c,190 :: 		}
	GOTO        L_main4
L_main5:
;soundrec.c,194 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	CLRF        FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,198 :: 		INTCON |= (1 << GIE) | (1 << PEIE);		/* Global interrupt */
	MOVLW       192
	IORWF       INTCON+0, 1 
;soundrec.c,200 :: 		for (;;)        						/* Repeat forever */
L_main6:
;soundrec.c,202 :: 		while (SLCT != 0){
L_main9:
	BTFSS       RB0_bit+0, BitPos(RB0_bit+0) 
	GOTO        L_main10
;soundrec.c,203 :: 		}
	GOTO        L_main9
L_main10:
;soundrec.c,206 :: 		Lcd_Cmd(_LCD_CLEAR);               		// Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,209 :: 		while (OK)	/* OK not pressed */
L_main11:
	BTFSS       RB1_bit+0, BitPos(RB1_bit+0) 
	GOTO        L_main12
;soundrec.c,211 :: 		if (!SLCT)	/* SLCT */
	BTFSC       RB0_bit+0, BitPos(RB0_bit+0) 
	GOTO        L_main13
;soundrec.c,213 :: 		Delay_ms(300);
	MOVLW       8
	MOVWF       R11, 0
	MOVLW       157
	MOVWF       R12, 0
	MOVLW       5
	MOVWF       R13, 0
L_main14:
	DECFSZ      R13, 1, 1
	BRA         L_main14
	DECFSZ      R12, 1, 1
	BRA         L_main14
	DECFSZ      R11, 1, 1
	BRA         L_main14
	NOP
	NOP
;soundrec.c,214 :: 		mode++;
	MOVF        _mode+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _mode+0 
;soundrec.c,215 :: 		if (mode == 4)
	MOVF        _mode+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_main15
;soundrec.c,217 :: 		mode = 1;
	MOVLW       1
	MOVWF       _mode+0 
;soundrec.c,218 :: 		}
L_main15:
;soundrec.c,219 :: 		}
L_main13:
;soundrec.c,221 :: 		if ((mode == 1) & (lastMode != mode))
	MOVF        _mode+0, 0 
	XORLW       1
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        main_lastMode_L0+0, 0 
	XORWF       _mode+0, 0 
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main16
;soundrec.c,223 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,224 :: 		lcdDisplay(1, 2, codeToRam(lcd_record));
	MOVLW       _lcd_record+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_lcd_record+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_lcd_record+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	CALL        _Lcd_Out+0, 0
;soundrec.c,225 :: 		}
	GOTO        L_main17
L_main16:
;soundrec.c,226 :: 		else if ((mode == 2) & (lastMode != mode))
	MOVF        _mode+0, 0 
	XORLW       2
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        main_lastMode_L0+0, 0 
	XORWF       _mode+0, 0 
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main18
;soundrec.c,228 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,229 :: 		lcdDisplay(1, 2, codeToRam(lcd_play));
	MOVLW       _lcd_play+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_lcd_play+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_lcd_play+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	CALL        _Lcd_Out+0, 0
;soundrec.c,230 :: 		}
	GOTO        L_main19
L_main18:
;soundrec.c,231 :: 		else if ((mode == 3) & (lastMode != mode))
	MOVF        _mode+0, 0 
	XORLW       3
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        main_lastMode_L0+0, 0 
	XORWF       _mode+0, 0 
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main20
;soundrec.c,233 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,234 :: 		lcdDisplay(1, 2, codeToRam(lcd_sampleRate));
	MOVLW       _lcd_sampleRate+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_lcd_sampleRate+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_lcd_sampleRate+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	CALL        _Lcd_Out+0, 0
;soundrec.c,235 :: 		}
L_main20:
L_main19:
L_main17:
;soundrec.c,237 :: 		lastMode = mode;
	MOVF        _mode+0, 0 
	MOVWF       main_lastMode_L0+0 
;soundrec.c,238 :: 		}
	GOTO        L_main11
L_main12:
;soundrec.c,241 :: 		if (mode == 1)
	MOVF        _mode+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main21
;soundrec.c,244 :: 		timer1Config();
	CALL        _timer1Config+0, 0
;soundrec.c,247 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,248 :: 		lcdDisplay(1, 2, codeToRam(lcd_writing));
	MOVLW       _lcd_writing+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_lcd_writing+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_lcd_writing+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	CALL        _Lcd_Out+0, 0
;soundrec.c,251 :: 		ptr = buffer0;
	MOVLW       _buffer0+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,252 :: 		ptrIndex = 0;
	CLRF        soundrec_ptrIndex+0 
	CLRF        soundrec_ptrIndex+1 
;soundrec.c,253 :: 		sectorIndex = 0;
	CLRF        main_sectorIndex_L0+0 
	CLRF        main_sectorIndex_L0+1 
	CLRF        main_sectorIndex_L0+2 
	CLRF        main_sectorIndex_L0+3 
;soundrec.c,254 :: 		bufferFull = 0;
	CLRF        _bufferFull+0 
;soundrec.c,255 :: 		currentBuffer = 0;
	CLRF        _currentBuffer+0 
;soundrec.c,257 :: 		T1CON = (1 << TMR1ON);		/* Start hardware timer */
	MOVLW       1
	MOVWF       T1CON+0 
;soundrec.c,258 :: 		while (SLCT)				/* Wait until SLCT pressed */
L_main22:
	BTFSS       RB0_bit+0, BitPos(RB0_bit+0) 
	GOTO        L_main23
;soundrec.c,260 :: 		if (bufferFull == 1)
	MOVF        _bufferFull+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main24
;soundrec.c,262 :: 		bufferFull = 0;
	CLRF        _bufferFull+0 
;soundrec.c,263 :: 		if (currentBuffer)	/* Write buffer 0 */
	MOVF        _currentBuffer+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main25
;soundrec.c,265 :: 		if (Mmc_Write_Sector(sectorIndex++, buffer0) != 0) {
	MOVF        main_sectorIndex_L0+0, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+0 
	MOVF        main_sectorIndex_L0+1, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+1 
	MOVF        main_sectorIndex_L0+2, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+2 
	MOVF        main_sectorIndex_L0+3, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+3 
	MOVLW       1
	ADDWF       main_sectorIndex_L0+0, 1 
	MOVLW       0
	ADDWFC      main_sectorIndex_L0+1, 1 
	ADDWFC      main_sectorIndex_L0+2, 1 
	ADDWFC      main_sectorIndex_L0+3, 1 
	MOVLW       _buffer0+0
	MOVWF       FARG_Mmc_Write_Sector_dbuff+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       FARG_Mmc_Write_Sector_dbuff+1 
	CALL        _Mmc_Write_Sector+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main26
;soundrec.c,266 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,267 :: 		lcdDisplay(2, 2, "E");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_soundrec+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_soundrec+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;soundrec.c,268 :: 		}
L_main26:
;soundrec.c,269 :: 		}
	GOTO        L_main27
L_main25:
;soundrec.c,272 :: 		if (Mmc_Write_Sector(sectorIndex++, buffer1) != 0) {
	MOVF        main_sectorIndex_L0+0, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+0 
	MOVF        main_sectorIndex_L0+1, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+1 
	MOVF        main_sectorIndex_L0+2, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+2 
	MOVF        main_sectorIndex_L0+3, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+3 
	MOVLW       1
	ADDWF       main_sectorIndex_L0+0, 1 
	MOVLW       0
	ADDWFC      main_sectorIndex_L0+1, 1 
	ADDWFC      main_sectorIndex_L0+2, 1 
	ADDWFC      main_sectorIndex_L0+3, 1 
	MOVLW       _buffer1+0
	MOVWF       FARG_Mmc_Write_Sector_dbuff+0 
	MOVLW       hi_addr(_buffer1+0)
	MOVWF       FARG_Mmc_Write_Sector_dbuff+1 
	CALL        _Mmc_Write_Sector+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main28
;soundrec.c,273 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,274 :: 		lcdDisplay(2,2, "E");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_soundrec+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_soundrec+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;soundrec.c,275 :: 		}
L_main28:
;soundrec.c,276 :: 		}
L_main27:
;soundrec.c,277 :: 		}
L_main24:
;soundrec.c,278 :: 		}
	GOTO        L_main22
L_main23:
;soundrec.c,279 :: 		T1CON &= ~(1 << TMR1ON);
	BCF         T1CON+0, 0 
;soundrec.c,281 :: 		Delay_ms(100);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main29:
	DECFSZ      R13, 1, 1
	BRA         L_main29
	DECFSZ      R12, 1, 1
	BRA         L_main29
	DECFSZ      R11, 1, 1
	BRA         L_main29
	NOP
	NOP
;soundrec.c,287 :: 		}
	GOTO        L_main30
L_main21:
;soundrec.c,290 :: 		else if (mode == 2)
	MOVF        _mode+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main31
;soundrec.c,293 :: 		sectorIndex = 0;
	CLRF        main_sectorIndex_L0+0 
	CLRF        main_sectorIndex_L0+1 
	CLRF        main_sectorIndex_L0+2 
	CLRF        main_sectorIndex_L0+3 
;soundrec.c,296 :: 		timer1Config();
	CALL        _timer1Config+0, 0
;soundrec.c,299 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,300 :: 		lcdDisplay(1, 2, codeToRam(lcd_playing));
	MOVLW       _lcd_playing+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_lcd_playing+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_lcd_playing+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	CALL        _Lcd_Out+0, 0
;soundrec.c,301 :: 		ptr = buffer0;
	MOVLW       _buffer0+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,302 :: 		ptrIndex = 0;
	CLRF        soundrec_ptrIndex+0 
	CLRF        soundrec_ptrIndex+1 
;soundrec.c,303 :: 		bufferFull = 0;
	CLRF        _bufferFull+0 
;soundrec.c,304 :: 		currentBuffer = 0;
	CLRF        _currentBuffer+0 
;soundrec.c,307 :: 		if (Mmc_Read_Sector(sectorIndex, buffer0) != 0)	{
	MOVF        main_sectorIndex_L0+0, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+0 
	MOVF        main_sectorIndex_L0+1, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+1 
	MOVF        main_sectorIndex_L0+2, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+2 
	MOVF        main_sectorIndex_L0+3, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+3 
	MOVLW       _buffer0+0
	MOVWF       FARG_Mmc_Read_Sector_dbuff+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       FARG_Mmc_Read_Sector_dbuff+1 
	CALL        _Mmc_Read_Sector+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main32
;soundrec.c,308 :: 		}
L_main32:
;soundrec.c,311 :: 		T1CON |= (1 << TMR1ON);
	BSF         T1CON+0, 0 
;soundrec.c,314 :: 		while (SLCT)
L_main33:
	BTFSS       RB0_bit+0, BitPos(RB0_bit+0) 
	GOTO        L_main34
;soundrec.c,316 :: 		if (bufferFull == 1) {
	MOVF        _bufferFull+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main35
;soundrec.c,317 :: 		bufferFull = 0;
	CLRF        _bufferFull+0 
;soundrec.c,318 :: 		if (currentBuffer) { /* Read buffer 0 */
	MOVF        _currentBuffer+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main36
;soundrec.c,320 :: 		if (Mmc_Read_Sector(sectorIndex++, buffer0) != 0) {
	MOVF        main_sectorIndex_L0+0, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+0 
	MOVF        main_sectorIndex_L0+1, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+1 
	MOVF        main_sectorIndex_L0+2, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+2 
	MOVF        main_sectorIndex_L0+3, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+3 
	MOVLW       1
	ADDWF       main_sectorIndex_L0+0, 1 
	MOVLW       0
	ADDWFC      main_sectorIndex_L0+1, 1 
	ADDWFC      main_sectorIndex_L0+2, 1 
	ADDWFC      main_sectorIndex_L0+3, 1 
	MOVLW       _buffer0+0
	MOVWF       FARG_Mmc_Read_Sector_dbuff+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       FARG_Mmc_Read_Sector_dbuff+1 
	CALL        _Mmc_Read_Sector+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main37
;soundrec.c,321 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,322 :: 		lcdDisplay(2,2, "E");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_soundrec+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_soundrec+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;soundrec.c,323 :: 		}
L_main37:
;soundrec.c,324 :: 		}
	GOTO        L_main38
L_main36:
;soundrec.c,327 :: 		if (Mmc_Read_Sector(sectorIndex++, buffer1) != 0) {
	MOVF        main_sectorIndex_L0+0, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+0 
	MOVF        main_sectorIndex_L0+1, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+1 
	MOVF        main_sectorIndex_L0+2, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+2 
	MOVF        main_sectorIndex_L0+3, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+3 
	MOVLW       1
	ADDWF       main_sectorIndex_L0+0, 1 
	MOVLW       0
	ADDWFC      main_sectorIndex_L0+1, 1 
	ADDWFC      main_sectorIndex_L0+2, 1 
	ADDWFC      main_sectorIndex_L0+3, 1 
	MOVLW       _buffer1+0
	MOVWF       FARG_Mmc_Read_Sector_dbuff+0 
	MOVLW       hi_addr(_buffer1+0)
	MOVWF       FARG_Mmc_Read_Sector_dbuff+1 
	CALL        _Mmc_Read_Sector+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main39
;soundrec.c,328 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,329 :: 		lcdDisplay(2,2, "E");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_soundrec+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_soundrec+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;soundrec.c,330 :: 		}
L_main39:
;soundrec.c,331 :: 		}
L_main38:
;soundrec.c,332 :: 		}
L_main35:
;soundrec.c,333 :: 		}
	GOTO        L_main33
L_main34:
;soundrec.c,336 :: 		T1CON &= ~(1 << TMR1ON);
	BCF         T1CON+0, 0 
;soundrec.c,338 :: 		Delay_ms(100);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main40:
	DECFSZ      R13, 1, 1
	BRA         L_main40
	DECFSZ      R12, 1, 1
	BRA         L_main40
	DECFSZ      R11, 1, 1
	BRA         L_main40
	NOP
	NOP
;soundrec.c,341 :: 		}
	GOTO        L_main41
L_main31:
;soundrec.c,344 :: 		else if (mode == 3)	{
	MOVF        _mode+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main42
;soundrec.c,345 :: 		temp = mode; /* Save current mode state */
	MOVF        _mode+0, 0 
	MOVWF       main_temp_L0+0 
;soundrec.c,346 :: 		mode = 1;
	MOVLW       1
	MOVWF       _mode+0 
;soundrec.c,347 :: 		Delay_ms(500);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_main43:
	DECFSZ      R13, 1, 1
	BRA         L_main43
	DECFSZ      R12, 1, 1
	BRA         L_main43
	DECFSZ      R11, 1, 1
	BRA         L_main43
	NOP
;soundrec.c,348 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,350 :: 		while (OK) { /* OK not pressed */
L_main44:
	BTFSS       RB1_bit+0, BitPos(RB1_bit+0) 
	GOTO        L_main45
;soundrec.c,351 :: 		if (!SLCT) { /* SLCT */
	BTFSC       RB0_bit+0, BitPos(RB0_bit+0) 
	GOTO        L_main46
;soundrec.c,352 :: 		Delay_ms(300);
	MOVLW       8
	MOVWF       R11, 0
	MOVLW       157
	MOVWF       R12, 0
	MOVLW       5
	MOVWF       R13, 0
L_main47:
	DECFSZ      R13, 1, 1
	BRA         L_main47
	DECFSZ      R12, 1, 1
	BRA         L_main47
	DECFSZ      R11, 1, 1
	BRA         L_main47
	NOP
	NOP
;soundrec.c,353 :: 		mode++;
	MOVF        _mode+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _mode+0 
;soundrec.c,354 :: 		if (mode == 3) {
	MOVF        _mode+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main48
;soundrec.c,355 :: 		mode = 1;
	MOVLW       1
	MOVWF       _mode+0 
;soundrec.c,356 :: 		}
L_main48:
;soundrec.c,357 :: 		}
L_main46:
;soundrec.c,359 :: 		if ((mode == 1) & (lastMode != mode)) {
	MOVF        _mode+0, 0 
	XORLW       1
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        main_lastMode_L0+0, 0 
	XORWF       _mode+0, 0 
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main49
;soundrec.c,360 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,361 :: 		lcdDisplay(1, 2, codeToRam(lcd_s_16khz));
	MOVLW       _lcd_s_16khz+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_lcd_s_16khz+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_lcd_s_16khz+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	CALL        _Lcd_Out+0, 0
;soundrec.c,362 :: 		}
	GOTO        L_main50
L_main49:
;soundrec.c,363 :: 		else if ((mode == 2) & (lastMode != mode)) {
	MOVF        _mode+0, 0 
	XORLW       2
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        main_lastMode_L0+0, 0 
	XORWF       _mode+0, 0 
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main51
;soundrec.c,364 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,365 :: 		lcdDisplay(1, 2, codeToRam(lcd_s_8khz));
	MOVLW       _lcd_s_8khz+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_lcd_s_8khz+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_lcd_s_8khz+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	CALL        _Lcd_Out+0, 0
;soundrec.c,366 :: 		}
L_main51:
L_main50:
;soundrec.c,368 :: 		lastMode = mode;
	MOVF        _mode+0, 0 
	MOVWF       main_lastMode_L0+0 
;soundrec.c,369 :: 		}
	GOTO        L_main44
L_main45:
;soundrec.c,371 :: 		if (mode == 1) {
	MOVF        _mode+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main52
;soundrec.c,372 :: 		samplingRate = _16KHZ;
	CLRF        soundrec_samplingRate+0 
;soundrec.c,373 :: 		}
	GOTO        L_main53
L_main52:
;soundrec.c,374 :: 		else if (mode == 2) {
	MOVF        _mode+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main54
;soundrec.c,375 :: 		samplingRate = _8KHZ;
	MOVLW       1
	MOVWF       soundrec_samplingRate+0 
;soundrec.c,376 :: 		}
L_main54:
L_main53:
;soundrec.c,378 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,379 :: 		lcdDisplay(1, 2, codeToRam(lcd_saved));
	MOVLW       _lcd_saved+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_lcd_saved+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_lcd_saved+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	CALL        _Lcd_Out+0, 0
;soundrec.c,381 :: 		mode = temp;
	MOVF        main_temp_L0+0, 0 
	MOVWF       _mode+0 
;soundrec.c,382 :: 		}
L_main42:
L_main41:
L_main30:
;soundrec.c,385 :: 		}
	GOTO        L_main6
;soundrec.c,387 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;soundrec.c,407 :: 		void interrupt()
;soundrec.c,409 :: 		if (PIR1.TMR1IF == 1) {
	BTFSS       PIR1+0, 0 
	GOTO        L_interrupt55
;soundrec.c,411 :: 		PIR1.TMR1IF = 0;
	BCF         PIR1+0, 0 
;soundrec.c,416 :: 		TMR1H = timerH;
	MOVF        soundrec_timerH+0, 0 
	MOVWF       TMR1H+0 
;soundrec.c,417 :: 		TMR1L = timerL;
	MOVF        soundrec_timerL+0, 0 
	MOVWF       TMR1L+0 
;soundrec.c,419 :: 		if (mode == 1) { /* Record mode */
	MOVF        _mode+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt56
;soundrec.c,421 :: 		GO_bit = 1;
	BSF         GO_bit+0, BitPos(GO_bit+0) 
;soundrec.c,424 :: 		LATC |= (1 << 6);
	BSF         LATC+0, 6 
;soundrec.c,425 :: 		Delay_us(1);
	NOP
	NOP
	NOP
	NOP
	NOP
;soundrec.c,426 :: 		LATC &= ~(1 << 6);
	BCF         LATC+0, 6 
;soundrec.c,427 :: 		}
	GOTO        L_interrupt57
L_interrupt56:
;soundrec.c,430 :: 		LATD = *(ptr + (ptrIndex++));
	MOVF        soundrec_ptrIndex+0, 0 
	ADDWF       soundrec_ptr+0, 0 
	MOVWF       FSR0 
	MOVF        soundrec_ptrIndex+1, 0 
	ADDWFC      soundrec_ptr+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       LATD+0 
	MOVLW       1
	ADDWF       soundrec_ptrIndex+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      soundrec_ptrIndex+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       soundrec_ptrIndex+0 
	MOVF        R1, 0 
	MOVWF       soundrec_ptrIndex+1 
;soundrec.c,433 :: 		if (ptrIndex == 512) {
	MOVF        soundrec_ptrIndex+1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt72
	MOVLW       0
	XORWF       soundrec_ptrIndex+0, 0 
L__interrupt72:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt58
;soundrec.c,434 :: 		ptrIndex = 0;
	CLRF        soundrec_ptrIndex+0 
	CLRF        soundrec_ptrIndex+1 
;soundrec.c,435 :: 		bufferFull = 1;
	MOVLW       1
	MOVWF       _bufferFull+0 
;soundrec.c,436 :: 		if (currentBuffer == 0)	{
	MOVF        _currentBuffer+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt59
;soundrec.c,437 :: 		ptr = buffer1;
	MOVLW       _buffer1+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer1+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,438 :: 		currentBuffer = 1;
	MOVLW       1
	MOVWF       _currentBuffer+0 
;soundrec.c,439 :: 		}
	GOTO        L_interrupt60
L_interrupt59:
;soundrec.c,441 :: 		ptr = buffer0;
	MOVLW       _buffer0+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,442 :: 		currentBuffer = 0;
	CLRF        _currentBuffer+0 
;soundrec.c,443 :: 		}
L_interrupt60:
;soundrec.c,444 :: 		}
L_interrupt58:
;soundrec.c,445 :: 		}
L_interrupt57:
;soundrec.c,446 :: 		}
L_interrupt55:
;soundrec.c,448 :: 		if (PIR1 & (1 << ADIF)) {
	BTFSS       PIR1+0, 6 
	GOTO        L_interrupt61
;soundrec.c,450 :: 		PIR1 &= ~(1 << ADIF);
	BCF         PIR1+0, 6 
;soundrec.c,453 :: 		adcResult = ADRESH;
	MOVF        ADRESH+0, 0 
	MOVWF       _adcResult+0 
;soundrec.c,455 :: 		*(ptr + (ptrIndex++)) = adcResult;
	MOVF        soundrec_ptrIndex+0, 0 
	ADDWF       soundrec_ptr+0, 0 
	MOVWF       FSR1 
	MOVF        soundrec_ptrIndex+1, 0 
	ADDWFC      soundrec_ptr+1, 0 
	MOVWF       FSR1H 
	MOVF        _adcResult+0, 0 
	MOVWF       POSTINC1+0 
	MOVLW       1
	ADDWF       soundrec_ptrIndex+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      soundrec_ptrIndex+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       soundrec_ptrIndex+0 
	MOVF        R1, 0 
	MOVWF       soundrec_ptrIndex+1 
;soundrec.c,458 :: 		if (ptrIndex == 512)
	MOVF        soundrec_ptrIndex+1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt73
	MOVLW       0
	XORWF       soundrec_ptrIndex+0, 0 
L__interrupt73:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt62
;soundrec.c,460 :: 		ptrIndex = 0;
	CLRF        soundrec_ptrIndex+0 
	CLRF        soundrec_ptrIndex+1 
;soundrec.c,461 :: 		bufferFull = 1;
	MOVLW       1
	MOVWF       _bufferFull+0 
;soundrec.c,462 :: 		if (currentBuffer == 0)
	MOVF        _currentBuffer+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt63
;soundrec.c,464 :: 		ptr = buffer1;
	MOVLW       _buffer1+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer1+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,465 :: 		currentBuffer = 1;
	MOVLW       1
	MOVWF       _currentBuffer+0 
;soundrec.c,466 :: 		}
	GOTO        L_interrupt64
L_interrupt63:
;soundrec.c,469 :: 		ptr = buffer0;
	MOVLW       _buffer0+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,470 :: 		currentBuffer = 0;
	CLRF        _currentBuffer+0 
;soundrec.c,471 :: 		}
L_interrupt64:
;soundrec.c,472 :: 		}
L_interrupt62:
;soundrec.c,473 :: 		}
L_interrupt61:
;soundrec.c,474 :: 		}
L_end_interrupt:
L__interrupt71:
	RETFIE      1
; end of _interrupt

_timer1Config:

;soundrec.c,480 :: 		void timer1Config(void)
;soundrec.c,482 :: 		PIE1 = (1 << TMR1IE);
	MOVLW       1
	MOVWF       PIE1+0 
;soundrec.c,484 :: 		if (samplingRate == _16KHZ) {
	MOVF        soundrec_samplingRate+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_timer1Config65
;soundrec.c,485 :: 		timerH = _16KHZ_HIGHBYTE;
	MOVLW       254
	MOVWF       soundrec_timerH+0 
;soundrec.c,486 :: 		timerL = _16KHZ_LOWBYTE;
	MOVLW       199
	MOVWF       soundrec_timerL+0 
;soundrec.c,487 :: 		}
	GOTO        L_timer1Config66
L_timer1Config65:
;soundrec.c,488 :: 		else if (samplingRate == _8KHZ) {
	MOVF        soundrec_samplingRate+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_timer1Config67
;soundrec.c,489 :: 		timerH = _8KHZ_HIGHBYTE;
	MOVLW       253
	MOVWF       soundrec_timerH+0 
;soundrec.c,490 :: 		timerL = _8KHZ_LOWBYTE;
	MOVLW       142
	MOVWF       soundrec_timerL+0 
;soundrec.c,491 :: 		}
L_timer1Config67:
L_timer1Config66:
;soundrec.c,493 :: 		TMR1H = timerH;
	MOVF        soundrec_timerH+0, 0 
	MOVWF       TMR1H+0 
;soundrec.c,494 :: 		TMR1L = timerL;
	MOVF        soundrec_timerL+0, 0 
	MOVWF       TMR1L+0 
;soundrec.c,495 :: 		}
L_end_timer1Config:
	RETURN      0
; end of _timer1Config
