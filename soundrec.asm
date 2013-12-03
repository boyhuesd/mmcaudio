
_codeToRam:

;soundrec.c,105 :: 		char* codeToRam(const char* ctxt)
;soundrec.c,109 :: 		for(i =0; txt[i] = ctxt[i]; i++);
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
;soundrec.c,111 :: 		return txt;
	MOVLW       codeToRam_txt_L0+0
	MOVWF       R0 
	MOVLW       hi_addr(codeToRam_txt_L0+0)
	MOVWF       R1 
;soundrec.c,112 :: 		}
L_end_codeToRam:
	RETURN      0
; end of _codeToRam

_main:

;soundrec.c,114 :: 		void main()
;soundrec.c,117 :: 		unsigned int mode = 0;
	CLRF        main_mode_L0+0 
	CLRF        main_mode_L0+1 
;soundrec.c,124 :: 		INTCON2 &= ~(1 << 7); // nRBPU = 0
	MOVLW       127
	ANDWF       INTCON2+0, 1 
;soundrec.c,126 :: 		ptr = &buffer0[0];
	MOVLW       _buffer0+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,127 :: 		currentBuffer = 0;
	CLRF        _currentBuffer+0 
;soundrec.c,128 :: 		adcInit();
	CALL        _adcInit+0, 0
;soundrec.c,129 :: 		Delay_ms(100);
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
;soundrec.c,133 :: 		TRISD = 0x00; 							// Output for DAC0808
	CLRF        TRISD+0 
;soundrec.c,134 :: 		TRISB = (1 << RB0) | (1 << RB1); 		// B0, B1 input; remains output
	MOVLW       3
	MOVWF       TRISB+0 
;soundrec.c,135 :: 		TRISC &= ~(1 << 2); 					// Output for CS pin
	BCF         TRISC+0, 2 
;soundrec.c,138 :: 		LATD = 0x40;
	MOVLW       64
	MOVWF       LATD+0 
;soundrec.c,145 :: 		Lcd_Init();								// Init LCD for display
	CALL        _Lcd_Init+0, 0
;soundrec.c,146 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,147 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,148 :: 		Lcd_Out(1, 2, codeToRam(lcd_welcome));
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
;soundrec.c,151 :: 		mmcBuiltinInit();
	CALL        _mmcBuiltinInit+0, 0
;soundrec.c,158 :: 		INTCON |= (1 << GIE) | (1 << PEIE);		/* Global interrupt */
	MOVLW       192
	IORWF       INTCON+0, 1 
;soundrec.c,160 :: 		for (;;)        						/* Repeat forever */
L_main4:
;soundrec.c,162 :: 		while (SLCT != 0)
L_main7:
	BTFSS       RB0_bit+0, BitPos(RB0_bit+0) 
	GOTO        L_main8
;soundrec.c,164 :: 		}
	GOTO        L_main7
L_main8:
;soundrec.c,201 :: 		Lcd_Cmd(_LCD_CLEAR);               		// Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,204 :: 		while (OK)	/* OK not pressed */
L_main9:
	BTFSS       RB1_bit+0, BitPos(RB1_bit+0) 
	GOTO        L_main10
;soundrec.c,206 :: 		if (!SLCT)	/* SLCT */
	BTFSC       RB0_bit+0, BitPos(RB0_bit+0) 
	GOTO        L_main11
;soundrec.c,208 :: 		Delay_ms(300);
	MOVLW       8
	MOVWF       R11, 0
	MOVLW       157
	MOVWF       R12, 0
	MOVLW       5
	MOVWF       R13, 0
L_main12:
	DECFSZ      R13, 1, 1
	BRA         L_main12
	DECFSZ      R12, 1, 1
	BRA         L_main12
	DECFSZ      R11, 1, 1
	BRA         L_main12
	NOP
	NOP
;soundrec.c,209 :: 		mode++;
	INFSNZ      main_mode_L0+0, 1 
	INCF        main_mode_L0+1, 1 
;soundrec.c,210 :: 		if (mode == 5)
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main81
	MOVLW       5
	XORWF       main_mode_L0+0, 0 
L__main81:
	BTFSS       STATUS+0, 2 
	GOTO        L_main13
;soundrec.c,212 :: 		mode = 1;
	MOVLW       1
	MOVWF       main_mode_L0+0 
	MOVLW       0
	MOVWF       main_mode_L0+1 
;soundrec.c,213 :: 		}
L_main13:
;soundrec.c,214 :: 		}
L_main11:
;soundrec.c,216 :: 		if ((mode == 1) & (lastMode != mode))
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main82
	MOVLW       1
	XORWF       main_mode_L0+0, 0 
L__main82:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main83
	MOVF        main_mode_L0+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main83:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main14
;soundrec.c,218 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,219 :: 		lcdDisplay(1, 2, codeToRam(lcd_record));
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
;soundrec.c,220 :: 		}
	GOTO        L_main15
L_main14:
;soundrec.c,221 :: 		else if ((mode == 2) & (lastMode != mode))
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main84
	MOVLW       2
	XORWF       main_mode_L0+0, 0 
L__main84:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main85
	MOVF        main_mode_L0+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main85:
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
;soundrec.c,224 :: 		lcdDisplay(1, 2, codeToRam(lcd_play));
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
;soundrec.c,225 :: 		}
	GOTO        L_main17
L_main16:
;soundrec.c,226 :: 		else if ((mode == 3) & (lastMode != mode))
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main86
	MOVLW       3
	XORWF       main_mode_L0+0, 0 
L__main86:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main87
	MOVF        main_mode_L0+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main87:
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
;soundrec.c,229 :: 		lcdDisplay(1, 2, codeToRam(lcd_totaltrack));
	MOVLW       _lcd_totaltrack+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_lcd_totaltrack+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_lcd_totaltrack+0)
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
;soundrec.c,231 :: 		else if ((mode == 4) & (lastMode != mode))
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main88
	MOVLW       4
	XORWF       main_mode_L0+0, 0 
L__main88:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main89
	MOVF        main_mode_L0+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main89:
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
L_main15:
;soundrec.c,237 :: 		lastMode = mode;
	MOVF        main_mode_L0+0, 0 
	MOVWF       main_lastMode_L0+0 
;soundrec.c,238 :: 		}
	GOTO        L_main9
L_main10:
;soundrec.c,242 :: 		if (mode == 1)
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main90
	MOVLW       1
	XORWF       main_mode_L0+0, 0 
L__main90:
	BTFSS       STATUS+0, 2 
	GOTO        L_main21
;soundrec.c,245 :: 		timer1Config();
	CALL        _timer1Config+0, 0
;soundrec.c,251 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,252 :: 		lcdDisplay(1, 2, codeToRam(lcd_writing));
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
;soundrec.c,255 :: 		ptr = buffer0;
	MOVLW       _buffer0+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,256 :: 		ptrIndex = 0;
	CLRF        soundrec_ptrIndex+0 
	CLRF        soundrec_ptrIndex+1 
;soundrec.c,257 :: 		sectorIndex = trackFree();	/* Get address for new track */
	CALL        _trackFree+0, 0
	MOVF        R0, 0 
	MOVWF       _sectorIndex+0 
	MOVF        R1, 0 
	MOVWF       _sectorIndex+1 
	MOVF        R2, 0 
	MOVWF       _sectorIndex+2 
	MOVF        R3, 0 
	MOVWF       _sectorIndex+3 
;soundrec.c,258 :: 		trackFirstSector = sectorIndex;
	MOVF        _sectorIndex+0, 0 
	MOVWF       main_trackFirstSector_L0+0 
	MOVF        _sectorIndex+1, 0 
	MOVWF       main_trackFirstSector_L0+1 
	MOVF        _sectorIndex+2, 0 
	MOVWF       main_trackFirstSector_L0+2 
	MOVF        _sectorIndex+3, 0 
	MOVWF       main_trackFirstSector_L0+3 
;soundrec.c,259 :: 		bufferFull = 0;
	CLRF        _bufferFull+0 
;soundrec.c,261 :: 		T1CON = (1 << TMR1ON);		/* Start hardware timer */
	MOVLW       1
	MOVWF       T1CON+0 
;soundrec.c,262 :: 		while (SLCT)				/* Wait until SLCT pressed */
L_main22:
	BTFSS       RB0_bit+0, BitPos(RB0_bit+0) 
	GOTO        L_main23
;soundrec.c,264 :: 		if (bufferFull == 1)
	MOVF        _bufferFull+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main24
;soundrec.c,266 :: 		bufferFull = 0;
	CLRF        _bufferFull+0 
;soundrec.c,267 :: 		if (currentBuffer)	/* Write buffer 0 */
	MOVF        _currentBuffer+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main25
;soundrec.c,269 :: 		if (Mmc_Write_Sector(sectorIndex++, buffer0) != 0)
	MOVF        _sectorIndex+0, 0 
	MOVWF       R4 
	MOVF        _sectorIndex+1, 0 
	MOVWF       R5 
	MOVF        _sectorIndex+2, 0 
	MOVWF       R6 
	MOVF        _sectorIndex+3, 0 
	MOVWF       R7 
	MOVLW       1
	ADDWF       _sectorIndex+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _sectorIndex+1, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      _sectorIndex+2, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      _sectorIndex+3, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _sectorIndex+0 
	MOVF        R1, 0 
	MOVWF       _sectorIndex+1 
	MOVF        R2, 0 
	MOVWF       _sectorIndex+2 
	MOVF        R3, 0 
	MOVWF       _sectorIndex+3 
	MOVF        R4, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+0 
	MOVF        R5, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+1 
	MOVF        R6, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+2 
	MOVF        R7, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+3 
	MOVLW       _buffer0+0
	MOVWF       FARG_Mmc_Write_Sector_dbuff+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       FARG_Mmc_Write_Sector_dbuff+1 
	CALL        _Mmc_Write_Sector+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main26
;soundrec.c,274 :: 		}
L_main26:
;soundrec.c,275 :: 		}
	GOTO        L_main27
L_main25:
;soundrec.c,278 :: 		if (Mmc_Write_Sector(sectorIndex++, buffer1) != 0)
	MOVF        _sectorIndex+0, 0 
	MOVWF       R4 
	MOVF        _sectorIndex+1, 0 
	MOVWF       R5 
	MOVF        _sectorIndex+2, 0 
	MOVWF       R6 
	MOVF        _sectorIndex+3, 0 
	MOVWF       R7 
	MOVLW       1
	ADDWF       _sectorIndex+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _sectorIndex+1, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      _sectorIndex+2, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      _sectorIndex+3, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _sectorIndex+0 
	MOVF        R1, 0 
	MOVWF       _sectorIndex+1 
	MOVF        R2, 0 
	MOVWF       _sectorIndex+2 
	MOVF        R3, 0 
	MOVWF       _sectorIndex+3 
	MOVF        R4, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+0 
	MOVF        R5, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+1 
	MOVF        R6, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+2 
	MOVF        R7, 0 
	MOVWF       FARG_Mmc_Write_Sector_sector+3 
	MOVLW       _buffer1+0
	MOVWF       FARG_Mmc_Write_Sector_dbuff+0 
	MOVLW       hi_addr(_buffer1+0)
	MOVWF       FARG_Mmc_Write_Sector_dbuff+1 
	CALL        _Mmc_Write_Sector+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main28
;soundrec.c,283 :: 		}
L_main28:
;soundrec.c,284 :: 		}
L_main27:
;soundrec.c,285 :: 		}
L_main24:
;soundrec.c,286 :: 		}
	GOTO        L_main22
L_main23:
;soundrec.c,287 :: 		T1CON &= ~(1 << TMR1ON);
	BCF         T1CON+0, 0 
;soundrec.c,289 :: 		trackNext(sectorIndex, samplingRate); /* Write the track info */
	MOVF        _sectorIndex+0, 0 
	MOVWF       FARG_trackNext_address+0 
	MOVF        _sectorIndex+1, 0 
	MOVWF       FARG_trackNext_address+1 
	MOVF        _sectorIndex+2, 0 
	MOVWF       FARG_trackNext_address+2 
	MOVF        _sectorIndex+3, 0 
	MOVWF       FARG_trackNext_address+3 
	MOVF        soundrec_samplingRate+0, 0 
	MOVWF       FARG_trackNext_samplingRate+0 
	CALL        _trackNext+0, 0
;soundrec.c,291 :: 		Delay_ms(500);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_main29:
	DECFSZ      R13, 1, 1
	BRA         L_main29
	DECFSZ      R12, 1, 1
	BRA         L_main29
	DECFSZ      R11, 1, 1
	BRA         L_main29
	NOP
;soundrec.c,295 :: 		intToStr((sectorIndex - trackFirstSector), text);	/* Calculate track length */
	MOVF        main_trackFirstSector_L0+0, 0 
	SUBWF       _sectorIndex+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        main_trackFirstSector_L0+1, 0 
	SUBWFB      _sectorIndex+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _text+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,300 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,301 :: 		lcdDisplay(1, 2, codeToRam(lcd_done));
	MOVLW       _lcd_done+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_lcd_done+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_lcd_done+0)
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
;soundrec.c,302 :: 		lcdDisplay(2, 2, text);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _text+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;soundrec.c,304 :: 		}
	GOTO        L_main30
L_main21:
;soundrec.c,307 :: 		else if (mode == 2)
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main91
	MOVLW       2
	XORWF       main_mode_L0+0, 0 
L__main91:
	BTFSS       STATUS+0, 2 
	GOTO        L_main31
;soundrec.c,309 :: 		totalTrack = trackGetTotal(); /* Get total track for menu display */
	CALL        _trackGetTotal+0, 0
	MOVF        R0, 0 
	MOVWF       main_totalTrack_L0+0 
;soundrec.c,311 :: 		if (totalTrack == 0) { /* No tracks avaialbe */
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main32
;soundrec.c,312 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,313 :: 		lcdDisplay(1, 2, codeToRam(lcd_t_notrack));
	MOVLW       _lcd_t_notrack+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_lcd_t_notrack+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_lcd_t_notrack+0)
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
;soundrec.c,314 :: 		}
	GOTO        L_main33
L_main32:
;soundrec.c,317 :: 		temp = mode;
	MOVF        main_mode_L0+0, 0 
	MOVWF       main_temp_L0+0 
;soundrec.c,318 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,321 :: 		while (OK) { /* OK not pressed */
L_main34:
	BTFSS       RB1_bit+0, BitPos(RB1_bit+0) 
	GOTO        L_main35
;soundrec.c,322 :: 		if (!SLCT) { /* SLCT */
	BTFSC       RB0_bit+0, BitPos(RB0_bit+0) 
	GOTO        L_main36
;soundrec.c,323 :: 		Delay_ms(300);
	MOVLW       8
	MOVWF       R11, 0
	MOVLW       157
	MOVWF       R12, 0
	MOVLW       5
	MOVWF       R13, 0
L_main37:
	DECFSZ      R13, 1, 1
	BRA         L_main37
	DECFSZ      R12, 1, 1
	BRA         L_main37
	DECFSZ      R11, 1, 1
	BRA         L_main37
	NOP
	NOP
;soundrec.c,324 :: 		mode++;
	INFSNZ      main_mode_L0+0, 1 
	INCF        main_mode_L0+1, 1 
;soundrec.c,325 :: 		if (mode == (totalTrack+1)) {
	MOVF        main_totalTrack_L0+0, 0 
	ADDLW       1
	MOVWF       R1 
	CLRF        R2 
	MOVLW       0
	ADDWFC      R2, 1 
	MOVF        main_mode_L0+1, 0 
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main92
	MOVF        R1, 0 
	XORWF       main_mode_L0+0, 0 
L__main92:
	BTFSS       STATUS+0, 2 
	GOTO        L_main38
;soundrec.c,326 :: 		mode = 1;
	MOVLW       1
	MOVWF       main_mode_L0+0 
	MOVLW       0
	MOVWF       main_mode_L0+1 
;soundrec.c,327 :: 		}
L_main38:
;soundrec.c,328 :: 		}
L_main36:
;soundrec.c,331 :: 		if (lastMode != mode) {
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main93
	MOVF        main_mode_L0+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main93:
	BTFSC       STATUS+0, 2 
	GOTO        L_main39
;soundrec.c,332 :: 		intToStr(mode, text);
	MOVF        main_mode_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        main_mode_L0+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _text+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,333 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,334 :: 		lcdDisplay(1, 2, text);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _text+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;soundrec.c,335 :: 		}
L_main39:
;soundrec.c,337 :: 		lastMode = mode;
	MOVF        main_mode_L0+0, 0 
	MOVWF       main_lastMode_L0+0 
;soundrec.c,338 :: 		}
	GOTO        L_main34
L_main35:
;soundrec.c,340 :: 		}
L_main33:
;soundrec.c,343 :: 		trackInfo = trackGet(mode);
	MOVF        main_mode_L0+0, 0 
	MOVWF       FARG_trackGet_track+0 
	MOVLW       FLOC__main+0
	MOVWF       R0 
	MOVLW       hi_addr(FLOC__main+0)
	MOVWF       R1 
	CALL        _trackGet+0, 0
	MOVLW       9
	MOVWF       R0 
	MOVLW       main_trackInfo_L0+0
	MOVWF       FSR1 
	MOVLW       hi_addr(main_trackInfo_L0+0)
	MOVWF       FSR1H 
	MOVLW       FLOC__main+0
	MOVWF       FSR0 
	MOVLW       hi_addr(FLOC__main+0)
	MOVWF       FSR0H 
L_main40:
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	DECF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main40
;soundrec.c,344 :: 		mode = temp;	/* Return saved state to mode !important! */
	MOVF        main_temp_L0+0, 0 
	MOVWF       main_mode_L0+0 
	MOVLW       0
	MOVWF       main_mode_L0+1 
;soundrec.c,345 :: 		samplingRate = trackInfo.samplingRate; /* Change sampling rate */
	MOVF        main_trackInfo_L0+8, 0 
	MOVWF       soundrec_samplingRate+0 
;soundrec.c,348 :: 		timer1Config();
	CALL        _timer1Config+0, 0
;soundrec.c,354 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,355 :: 		lcdDisplay(1, 2, codeToRam(lcd_playing));
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
;soundrec.c,357 :: 		ptr = buffer0;
	MOVLW       _buffer0+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,358 :: 		ptrIndex = 0;
	CLRF        soundrec_ptrIndex+0 
	CLRF        soundrec_ptrIndex+1 
;soundrec.c,359 :: 		sectorIndex = trackInfo.address;
	MOVF        main_trackInfo_L0+0, 0 
	MOVWF       _sectorIndex+0 
	MOVF        main_trackInfo_L0+1, 0 
	MOVWF       _sectorIndex+1 
	MOVF        main_trackInfo_L0+2, 0 
	MOVWF       _sectorIndex+2 
	MOVF        main_trackInfo_L0+3, 0 
	MOVWF       _sectorIndex+3 
;soundrec.c,360 :: 		bufferFull = 0;
	CLRF        _bufferFull+0 
;soundrec.c,361 :: 		currentBuffer = 0;
	CLRF        _currentBuffer+0 
;soundrec.c,364 :: 		if (Mmc_Read_Sector(sectorIndex, buffer0) != 0)
	MOVF        _sectorIndex+0, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+0 
	MOVF        _sectorIndex+1, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+1 
	MOVF        _sectorIndex+2, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+2 
	MOVF        _sectorIndex+3, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+3 
	MOVLW       _buffer0+0
	MOVWF       FARG_Mmc_Read_Sector_dbuff+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       FARG_Mmc_Read_Sector_dbuff+1 
	CALL        _Mmc_Read_Sector+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main41
;soundrec.c,369 :: 		}
L_main41:
;soundrec.c,372 :: 		T1CON |= (1 << TMR1ON);
	BSF         T1CON+0, 0 
;soundrec.c,378 :: 		while (sectorIndex < trackInfo.nextAddress)				/* Wait until SLCT pressed */
L_main42:
	MOVF        main_trackInfo_L0+7, 0 
	SUBWF       _sectorIndex+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main94
	MOVF        main_trackInfo_L0+6, 0 
	SUBWF       _sectorIndex+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main94
	MOVF        main_trackInfo_L0+5, 0 
	SUBWF       _sectorIndex+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main94
	MOVF        main_trackInfo_L0+4, 0 
	SUBWF       _sectorIndex+0, 0 
L__main94:
	BTFSC       STATUS+0, 0 
	GOTO        L_main43
;soundrec.c,380 :: 		if (bufferFull == 1)
	MOVF        _bufferFull+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main44
;soundrec.c,382 :: 		bufferFull = 0;
	CLRF        _bufferFull+0 
;soundrec.c,383 :: 		if (currentBuffer)	/* Read buffer 0 */
	MOVF        _currentBuffer+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main45
;soundrec.c,385 :: 		if (Mmc_Read_Sector(sectorIndex++, buffer0) != 0)
	MOVF        _sectorIndex+0, 0 
	MOVWF       R4 
	MOVF        _sectorIndex+1, 0 
	MOVWF       R5 
	MOVF        _sectorIndex+2, 0 
	MOVWF       R6 
	MOVF        _sectorIndex+3, 0 
	MOVWF       R7 
	MOVLW       1
	ADDWF       _sectorIndex+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _sectorIndex+1, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      _sectorIndex+2, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      _sectorIndex+3, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _sectorIndex+0 
	MOVF        R1, 0 
	MOVWF       _sectorIndex+1 
	MOVF        R2, 0 
	MOVWF       _sectorIndex+2 
	MOVF        R3, 0 
	MOVWF       _sectorIndex+3 
	MOVF        R4, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+0 
	MOVF        R5, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+1 
	MOVF        R6, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+2 
	MOVF        R7, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+3 
	MOVLW       _buffer0+0
	MOVWF       FARG_Mmc_Read_Sector_dbuff+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       FARG_Mmc_Read_Sector_dbuff+1 
	CALL        _Mmc_Read_Sector+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main46
;soundrec.c,390 :: 		}
L_main46:
;soundrec.c,391 :: 		}
	GOTO        L_main47
L_main45:
;soundrec.c,394 :: 		if (Mmc_Read_Sector(sectorIndex++, buffer1) != 0)
	MOVF        _sectorIndex+0, 0 
	MOVWF       R4 
	MOVF        _sectorIndex+1, 0 
	MOVWF       R5 
	MOVF        _sectorIndex+2, 0 
	MOVWF       R6 
	MOVF        _sectorIndex+3, 0 
	MOVWF       R7 
	MOVLW       1
	ADDWF       _sectorIndex+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _sectorIndex+1, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      _sectorIndex+2, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      _sectorIndex+3, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _sectorIndex+0 
	MOVF        R1, 0 
	MOVWF       _sectorIndex+1 
	MOVF        R2, 0 
	MOVWF       _sectorIndex+2 
	MOVF        R3, 0 
	MOVWF       _sectorIndex+3 
	MOVF        R4, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+0 
	MOVF        R5, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+1 
	MOVF        R6, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+2 
	MOVF        R7, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+3 
	MOVLW       _buffer1+0
	MOVWF       FARG_Mmc_Read_Sector_dbuff+0 
	MOVLW       hi_addr(_buffer1+0)
	MOVWF       FARG_Mmc_Read_Sector_dbuff+1 
	CALL        _Mmc_Read_Sector+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main48
;soundrec.c,399 :: 		}
L_main48:
;soundrec.c,400 :: 		}
L_main47:
;soundrec.c,401 :: 		}
L_main44:
;soundrec.c,402 :: 		}
	GOTO        L_main42
L_main43:
;soundrec.c,405 :: 		T1CON &= ~(1 << TMR1ON);
	BCF         T1CON+0, 0 
;soundrec.c,410 :: 		Delay_ms(500);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_main49:
	DECFSZ      R13, 1, 1
	BRA         L_main49
	DECFSZ      R12, 1, 1
	BRA         L_main49
	DECFSZ      R11, 1, 1
	BRA         L_main49
	NOP
;soundrec.c,414 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,415 :: 		lcdDisplay(1, 2, codeToRam(lcd_done));
	MOVLW       _lcd_done+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_lcd_done+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_lcd_done+0)
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
;soundrec.c,417 :: 		}
	GOTO        L_main50
L_main31:
;soundrec.c,420 :: 		else if (mode == 3)	{
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main95
	MOVLW       3
	XORWF       main_mode_L0+0, 0 
L__main95:
	BTFSS       STATUS+0, 2 
	GOTO        L_main51
;soundrec.c,421 :: 		temp = mode; /* Save current mode state */
	MOVF        main_mode_L0+0, 0 
	MOVWF       main_temp_L0+0 
;soundrec.c,422 :: 		mode = 1;
	MOVLW       1
	MOVWF       main_mode_L0+0 
	MOVLW       0
	MOVWF       main_mode_L0+1 
;soundrec.c,425 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,427 :: 		while (OK) { /* OK not pressed */
L_main52:
	BTFSS       RB1_bit+0, BitPos(RB1_bit+0) 
	GOTO        L_main53
;soundrec.c,428 :: 		if (!SLCT) { /* SLCT */
	BTFSC       RB0_bit+0, BitPos(RB0_bit+0) 
	GOTO        L_main54
;soundrec.c,429 :: 		Delay_ms(300);
	MOVLW       8
	MOVWF       R11, 0
	MOVLW       157
	MOVWF       R12, 0
	MOVLW       5
	MOVWF       R13, 0
L_main55:
	DECFSZ      R13, 1, 1
	BRA         L_main55
	DECFSZ      R12, 1, 1
	BRA         L_main55
	DECFSZ      R11, 1, 1
	BRA         L_main55
	NOP
	NOP
;soundrec.c,430 :: 		mode++;
	INFSNZ      main_mode_L0+0, 1 
	INCF        main_mode_L0+1, 1 
;soundrec.c,431 :: 		if (mode == 3) {
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main96
	MOVLW       3
	XORWF       main_mode_L0+0, 0 
L__main96:
	BTFSS       STATUS+0, 2 
	GOTO        L_main56
;soundrec.c,432 :: 		mode = 1;
	MOVLW       1
	MOVWF       main_mode_L0+0 
	MOVLW       0
	MOVWF       main_mode_L0+1 
;soundrec.c,433 :: 		}
L_main56:
;soundrec.c,434 :: 		}
L_main54:
;soundrec.c,436 :: 		if ((mode == 1) & (lastMode != mode)) {
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main97
	MOVLW       1
	XORWF       main_mode_L0+0, 0 
L__main97:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main98
	MOVF        main_mode_L0+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main98:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main57
;soundrec.c,437 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,438 :: 		lcdDisplay(1, 2, codeToRam(lcd_s_16khz));
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
;soundrec.c,439 :: 		}
	GOTO        L_main58
L_main57:
;soundrec.c,440 :: 		else if ((mode == 2) & (lastMode != mode)) {
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main99
	MOVLW       2
	XORWF       main_mode_L0+0, 0 
L__main99:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main100
	MOVF        main_mode_L0+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main100:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main59
;soundrec.c,441 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,442 :: 		lcdDisplay(1, 2, codeToRam(lcd_s_8khz));
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
;soundrec.c,443 :: 		}
L_main59:
L_main58:
;soundrec.c,445 :: 		lastMode = mode;
	MOVF        main_mode_L0+0, 0 
	MOVWF       main_lastMode_L0+0 
;soundrec.c,446 :: 		}
	GOTO        L_main52
L_main53:
;soundrec.c,448 :: 		if (mode == 1) {
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main101
	MOVLW       1
	XORWF       main_mode_L0+0, 0 
L__main101:
	BTFSS       STATUS+0, 2 
	GOTO        L_main60
;soundrec.c,449 :: 		samplingRate = _16KHZ;
	CLRF        soundrec_samplingRate+0 
;soundrec.c,450 :: 		}
	GOTO        L_main61
L_main60:
;soundrec.c,451 :: 		else if (mode == 2) {
	MOVLW       0
	XORWF       main_mode_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main102
	MOVLW       2
	XORWF       main_mode_L0+0, 0 
L__main102:
	BTFSS       STATUS+0, 2 
	GOTO        L_main62
;soundrec.c,452 :: 		samplingRate = _8KHZ;
	MOVLW       1
	MOVWF       soundrec_samplingRate+0 
;soundrec.c,453 :: 		}
L_main62:
L_main61:
;soundrec.c,455 :: 		lcdClear();
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,456 :: 		lcdDisplay(1, 2, codeToRam(lcd_saved));
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
;soundrec.c,458 :: 		mode = temp;
	MOVF        main_temp_L0+0, 0 
	MOVWF       main_mode_L0+0 
	MOVLW       0
	MOVWF       main_mode_L0+1 
;soundrec.c,460 :: 		}
L_main51:
L_main50:
L_main30:
;soundrec.c,463 :: 		}
	GOTO        L_main4
;soundrec.c,464 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_mmcBuiltinInit:

;soundrec.c,466 :: 		void mmcBuiltinInit(void)
;soundrec.c,470 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,473 :: 		while (MMC_Init() != 0)
L_mmcBuiltinInit63:
	CALL        _Mmc_Init+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_mmcBuiltinInit64
;soundrec.c,475 :: 		}
	GOTO        L_mmcBuiltinInit63
L_mmcBuiltinInit64:
;soundrec.c,479 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	CLRF        FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,480 :: 		}
L_end_mmcBuiltinInit:
	RETURN      0
; end of _mmcBuiltinInit

_interrupt:

;soundrec.c,482 :: 		void interrupt()
;soundrec.c,484 :: 		if (PIR1.TMR1IF == 1)
	BTFSS       PIR1+0, 0 
	GOTO        L_interrupt65
;soundrec.c,487 :: 		PIR1.TMR1IF = 0;
	BCF         PIR1+0, 0 
;soundrec.c,492 :: 		TMR1H = timerH;
	MOVF        soundrec_timerH+0, 0 
	MOVWF       TMR1H+0 
;soundrec.c,493 :: 		TMR1L = timerL;
	MOVF        soundrec_timerL+0, 0 
	MOVWF       TMR1L+0 
;soundrec.c,495 :: 		if (mode == 1)					/* Record mode */
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt106
	MOVLW       1
	XORWF       _mode+0, 0 
L__interrupt106:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt66
;soundrec.c,498 :: 		GO_bit = 1;
	BSF         GO_bit+0, BitPos(GO_bit+0) 
;soundrec.c,499 :: 		}
	GOTO        L_interrupt67
L_interrupt66:
;soundrec.c,501 :: 		else if (mode == 2)				/* Play mode */
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt107
	MOVLW       2
	XORWF       _mode+0, 0 
L__interrupt107:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt68
;soundrec.c,508 :: 		LATD = *(ptr + (ptrIndex++));
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
;soundrec.c,512 :: 		if (ptrIndex == 512)
	MOVF        soundrec_ptrIndex+1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt108
	MOVLW       0
	XORWF       soundrec_ptrIndex+0, 0 
L__interrupt108:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt69
;soundrec.c,514 :: 		ptrIndex = 0;
	CLRF        soundrec_ptrIndex+0 
	CLRF        soundrec_ptrIndex+1 
;soundrec.c,515 :: 		bufferFull = 1;
	MOVLW       1
	MOVWF       _bufferFull+0 
;soundrec.c,516 :: 		if (currentBuffer == 0)
	MOVF        _currentBuffer+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt70
;soundrec.c,518 :: 		ptr = buffer1;
	MOVLW       _buffer1+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer1+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,519 :: 		currentBuffer = 1;
	MOVLW       1
	MOVWF       _currentBuffer+0 
;soundrec.c,520 :: 		}
	GOTO        L_interrupt71
L_interrupt70:
;soundrec.c,523 :: 		ptr = buffer0;
	MOVLW       _buffer0+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,524 :: 		currentBuffer = 0;
	CLRF        _currentBuffer+0 
;soundrec.c,525 :: 		}
L_interrupt71:
;soundrec.c,526 :: 		}
L_interrupt69:
;soundrec.c,527 :: 		}
L_interrupt68:
L_interrupt67:
;soundrec.c,528 :: 		}
L_interrupt65:
;soundrec.c,530 :: 		if (PIR1 & (1 << ADIF))
	BTFSS       PIR1+0, 6 
	GOTO        L_interrupt72
;soundrec.c,533 :: 		PIR1 &= ~(1 << ADIF);
	BCF         PIR1+0, 6 
;soundrec.c,536 :: 		adcResult = ADRESH;
	MOVF        ADRESH+0, 0 
	MOVWF       _adcResult+0 
;soundrec.c,538 :: 		*(ptr + (ptrIndex++)) = adcResult;
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
;soundrec.c,541 :: 		if (ptrIndex == 512)
	MOVF        soundrec_ptrIndex+1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt109
	MOVLW       0
	XORWF       soundrec_ptrIndex+0, 0 
L__interrupt109:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt73
;soundrec.c,543 :: 		ptrIndex = 0;
	CLRF        soundrec_ptrIndex+0 
	CLRF        soundrec_ptrIndex+1 
;soundrec.c,544 :: 		bufferFull = 1;
	MOVLW       1
	MOVWF       _bufferFull+0 
;soundrec.c,545 :: 		if (currentBuffer == 0)
	MOVF        _currentBuffer+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt74
;soundrec.c,547 :: 		ptr = buffer1;
	MOVLW       _buffer1+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer1+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,548 :: 		currentBuffer = 1;
	MOVLW       1
	MOVWF       _currentBuffer+0 
;soundrec.c,549 :: 		}
	GOTO        L_interrupt75
L_interrupt74:
;soundrec.c,552 :: 		ptr = buffer0;
	MOVLW       _buffer0+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,553 :: 		currentBuffer = 0;
	CLRF        _currentBuffer+0 
;soundrec.c,554 :: 		}
L_interrupt75:
;soundrec.c,555 :: 		}
L_interrupt73:
;soundrec.c,556 :: 		}
L_interrupt72:
;soundrec.c,557 :: 		}
L_end_interrupt:
L__interrupt105:
	RETFIE      1
; end of _interrupt

_timer1Config:

;soundrec.c,562 :: 		void timer1Config(void)
;soundrec.c,564 :: 		PIE1 = (1 << TMR1IE);
	MOVLW       1
	MOVWF       PIE1+0 
;soundrec.c,566 :: 		if (samplingRate == _16KHZ) {
	MOVF        soundrec_samplingRate+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_timer1Config76
;soundrec.c,567 :: 		timerH = _16KHZ_HIGHBYTE;
	MOVLW       254
	MOVWF       soundrec_timerH+0 
;soundrec.c,568 :: 		timerL = _16KHZ_LOWBYTE;
	MOVLW       199
	MOVWF       soundrec_timerL+0 
;soundrec.c,569 :: 		}
	GOTO        L_timer1Config77
L_timer1Config76:
;soundrec.c,570 :: 		else if (samplingRate == _8KHZ) {
	MOVF        soundrec_samplingRate+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_timer1Config78
;soundrec.c,571 :: 		timerH = _8KHZ_HIGHBYTE;
	MOVLW       253
	MOVWF       soundrec_timerH+0 
;soundrec.c,572 :: 		timerL = _8KHZ_LOWBYTE;
	MOVLW       142
	MOVWF       soundrec_timerL+0 
;soundrec.c,573 :: 		}
L_timer1Config78:
L_timer1Config77:
;soundrec.c,575 :: 		TMR1H = timerH;
	MOVF        soundrec_timerH+0, 0 
	MOVWF       TMR1H+0 
;soundrec.c,576 :: 		TMR1L = timerL;
	MOVF        soundrec_timerL+0, 0 
	MOVWF       TMR1L+0 
;soundrec.c,577 :: 		}
L_end_timer1Config:
	RETURN      0
; end of _timer1Config

_pwmConfig:

;soundrec.c,583 :: 		void pwmConfig(void)
;soundrec.c,585 :: 		PR2 = 77; 							/* 16.025 kHz */
	MOVLW       77
	MOVWF       PR2+0 
;soundrec.c,586 :: 		TRISB &= ~(1 << RB3);				/* Output for PWM */
	BCF         TRISB+0, 3 
;soundrec.c,587 :: 		CCPR2L	= 128;						/* Initial duty cycle is 0 */
	MOVLW       128
	MOVWF       CCPR2L+0 
;soundrec.c,588 :: 		T2CON = (1 << TMR2ON);				/* Enable timer 2 */
	MOVLW       4
	MOVWF       T2CON+0 
;soundrec.c,589 :: 		}
L_end_pwmConfig:
	RETURN      0
; end of _pwmConfig

_pwmStart:

;soundrec.c,594 :: 		void pwmStart(void)
;soundrec.c,596 :: 		CCP2CON = (1 << CCP2M3) | (1 << CCP2M2);	/* PWM mode */
	MOVLW       12
	MOVWF       CCP2CON+0 
;soundrec.c,597 :: 		}
L_end_pwmStart:
	RETURN      0
; end of _pwmStart

_pwmStop:

;soundrec.c,602 :: 		void pwmStop(void)
;soundrec.c,604 :: 		CCP2CON = 0;
	CLRF        CCP2CON+0 
;soundrec.c,605 :: 		}
L_end_pwmStop:
	RETURN      0
; end of _pwmStop

_pwmChangeDutyCycle:

;soundrec.c,610 :: 		void pwmChangeDutyCycle(uint8_t dutyCycle)
;soundrec.c,612 :: 		CCPR2L = dutyCycle;
	MOVF        FARG_pwmChangeDutyCycle_dutyCycle+0, 0 
	MOVWF       CCPR2L+0 
;soundrec.c,613 :: 		}
L_end_pwmChangeDutyCycle:
	RETURN      0
; end of _pwmChangeDutyCycle
