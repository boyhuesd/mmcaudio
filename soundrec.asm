
_codeToRam:

;soundrec.c,90 :: 		char* codeToRam(const char* ctxt)
;soundrec.c,94 :: 		for(i =0; txt[i] = ctxt[i]; i++);
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
;soundrec.c,96 :: 		return txt;
	MOVLW       codeToRam_txt_L0+0
	MOVWF       R0 
	MOVLW       hi_addr(codeToRam_txt_L0+0)
	MOVWF       R1 
;soundrec.c,97 :: 		}
L_end_codeToRam:
	RETURN      0
; end of _codeToRam

_main:

;soundrec.c,99 :: 		void main()
;soundrec.c,105 :: 		INTCON2 &= ~(1 << 7); // nRBPU = 0
	MOVLW       127
	ANDWF       INTCON2+0, 1 
;soundrec.c,107 :: 		ptr = &buffer0[0];
	MOVLW       _buffer0+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,108 :: 		currentBuffer = 0;
	CLRF        _currentBuffer+0 
;soundrec.c,109 :: 		adcInit();
	CALL        _adcInit+0, 0
;soundrec.c,110 :: 		Delay_ms(100);
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
;soundrec.c,115 :: 		TRISD = 0x00; // output for DAC0808
	CLRF        TRISD+0 
;soundrec.c,117 :: 		TRISB = (1 << RB0) | (1 << RB1); // B0, B1 input; remains output
	MOVLW       3
	MOVWF       TRISB+0 
;soundrec.c,118 :: 		TRISC &= ~(1 << 2); // output for CS pin
	BCF         TRISC+0, 2 
;soundrec.c,121 :: 		LATD = 0x40;
	MOVLW       64
	MOVWF       LATD+0 
;soundrec.c,123 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	MOVLW       2
	MOVWF       SPBRGH+0 
	MOVLW       8
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;soundrec.c,124 :: 		UWR(codeToRam(uart_welcome));
	MOVLW       _uart_welcome+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_uart_welcome+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_uart_welcome+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,125 :: 		mmcBuiltinInit();
	CALL        _mmcBuiltinInit+0, 0
;soundrec.c,126 :: 		specialEventTriggerSetup();
	CALL        _specialEventTriggerSetup+0, 0
;soundrec.c,127 :: 		timer1Config();
	CALL        _timer1Config+0, 0
;soundrec.c,134 :: 		INTCON |= (1 << GIE) | (1 << PEIE);	/* Global interrupt */
	MOVLW       192
	IORWF       INTCON+0, 1 
;soundrec.c,136 :: 		for (;;)        					/* Repeat forever */
L_main4:
;soundrec.c,138 :: 		while (SLCT != 0)
L_main7:
	BTFSS       RB0_bit+0, BitPos(RB0_bit+0) 
	GOTO        L_main8
;soundrec.c,140 :: 		}
	GOTO        L_main7
L_main8:
;soundrec.c,142 :: 		UWR(codeToRam(uart_menu));
	MOVLW       _uart_menu+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_uart_menu+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_uart_menu+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,144 :: 		while (OK)	/* OK not pressed */
L_main9:
	BTFSS       RB1_bit+0, BitPos(RB1_bit+0) 
	GOTO        L_main10
;soundrec.c,146 :: 		if (!SLCT)	/* SLCT */
	BTFSC       RB0_bit+0, BitPos(RB0_bit+0) 
	GOTO        L_main11
;soundrec.c,148 :: 		Delay_ms(300);
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
;soundrec.c,149 :: 		mode++;
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
;soundrec.c,150 :: 		if (mode == 5)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main64
	MOVLW       5
	XORWF       _mode+0, 0 
L__main64:
	BTFSS       STATUS+0, 2 
	GOTO        L_main13
;soundrec.c,152 :: 		mode = 1;
	MOVLW       1
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
;soundrec.c,153 :: 		}
L_main13:
;soundrec.c,154 :: 		}
L_main11:
;soundrec.c,156 :: 		if ((mode == 1) & (lastMode != mode))
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main65
	MOVLW       1
	XORWF       _mode+0, 0 
L__main65:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main66
	MOVF        _mode+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main66:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main14
;soundrec.c,158 :: 		UWR(codeToRam(uart_record));
	MOVLW       _uart_record+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_uart_record+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_uart_record+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,159 :: 		}
	GOTO        L_main15
L_main14:
;soundrec.c,160 :: 		else if ((mode == 2) & (lastMode != mode))
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main67
	MOVLW       2
	XORWF       _mode+0, 0 
L__main67:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main68
	MOVF        _mode+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main68:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main16
;soundrec.c,162 :: 		UWR(codeToRam(uart_play));
	MOVLW       _uart_play+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_uart_play+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_uart_play+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,163 :: 		}
	GOTO        L_main17
L_main16:
;soundrec.c,164 :: 		else if ((mode == 3) & (lastMode != mode))
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main69
	MOVLW       3
	XORWF       _mode+0, 0 
L__main69:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main70
	MOVF        _mode+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main70:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main18
;soundrec.c,166 :: 		UWR(codeToRam(uart_trackList));
	MOVLW       _uart_trackList+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_uart_trackList+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_uart_trackList+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,167 :: 		}
	GOTO        L_main19
L_main18:
;soundrec.c,168 :: 		else if ((mode == 4) & (lastMode != mode))
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main71
	MOVLW       4
	XORWF       _mode+0, 0 
L__main71:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main72
	MOVF        _mode+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main72:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main20
;soundrec.c,170 :: 		UWR(codeToRam(uart_changeSampleRate));
	MOVLW       _uart_changeSampleRate+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_uart_changeSampleRate+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_uart_changeSampleRate+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,171 :: 		}
L_main20:
L_main19:
L_main17:
L_main15:
;soundrec.c,173 :: 		lastMode = mode;
	MOVF        _mode+0, 0 
	MOVWF       main_lastMode_L0+0 
;soundrec.c,174 :: 		}
	GOTO        L_main9
L_main10:
;soundrec.c,177 :: 		if (mode == 1)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main73
	MOVLW       1
	XORWF       _mode+0, 0 
L__main73:
	BTFSS       STATUS+0, 2 
	GOTO        L_main21
;soundrec.c,180 :: 		UWR(codeToRam(uart_writing));
	MOVLW       _uart_writing+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_uart_writing+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_uart_writing+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,181 :: 		ptr = buffer0;
	MOVLW       _buffer0+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,182 :: 		ptrIndex = 0;
	CLRF        soundrec_ptrIndex+0 
	CLRF        soundrec_ptrIndex+1 
;soundrec.c,183 :: 		sectorIndex = 0;
	CLRF        _sectorIndex+0 
	CLRF        _sectorIndex+1 
	CLRF        _sectorIndex+2 
	CLRF        _sectorIndex+3 
;soundrec.c,184 :: 		bufferFull = 0;
	CLRF        _bufferFull+0 
;soundrec.c,186 :: 		T1CON = (1 << TMR1ON);
	MOVLW       1
	MOVWF       T1CON+0 
;soundrec.c,187 :: 		while (SLCT)				/* Wait until SLCT pressed */
L_main22:
	BTFSS       RB0_bit+0, BitPos(RB0_bit+0) 
	GOTO        L_main23
;soundrec.c,189 :: 		if (bufferFull == 1)
	MOVF        _bufferFull+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main24
;soundrec.c,191 :: 		bufferFull = 0;
	CLRF        _bufferFull+0 
;soundrec.c,192 :: 		if (currentBuffer)	/* Write buffer 0 */
	MOVF        _currentBuffer+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main25
;soundrec.c,194 :: 		if (Mmc_Write_Sector(sectorIndex++, buffer0) != 0)
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
;soundrec.c,196 :: 		UWR(codeToRam(uart_errorWrite));
	MOVLW       _uart_errorWrite+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_uart_errorWrite+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_uart_errorWrite+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,197 :: 		}
L_main26:
;soundrec.c,198 :: 		}
	GOTO        L_main27
L_main25:
;soundrec.c,201 :: 		if (Mmc_Write_Sector(sectorIndex++, buffer1) != 0)
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
;soundrec.c,203 :: 		UWR(codeToRam(uart_errorWrite));
	MOVLW       _uart_errorWrite+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_uart_errorWrite+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_uart_errorWrite+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,204 :: 		}
L_main28:
;soundrec.c,205 :: 		}
L_main27:
;soundrec.c,206 :: 		}
L_main24:
;soundrec.c,207 :: 		}
	GOTO        L_main22
L_main23:
;soundrec.c,208 :: 		T1CON &= ~(1 << TMR1ON);
	BCF         T1CON+0, 0 
;soundrec.c,209 :: 		Delay_ms(500);
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
;soundrec.c,212 :: 		intToStr(sectorIndex, text);
	MOVF        _sectorIndex+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _sectorIndex+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _text+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,213 :: 		UWR(codeToRam(uart_done));
	MOVLW       _uart_done+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_uart_done+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_uart_done+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,214 :: 		UWR(text);
	MOVLW       _text+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,215 :: 		intToStr(adcCount, text);
	MOVF        _adcCount+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _adcCount+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _text+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,216 :: 		UWR(text);
	MOVLW       _text+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,217 :: 		}
	GOTO        L_main30
L_main21:
;soundrec.c,220 :: 		else if (mode == 2)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main74
	MOVLW       2
	XORWF       _mode+0, 0 
L__main74:
	BTFSS       STATUS+0, 2 
	GOTO        L_main31
;soundrec.c,223 :: 		UWR(codeToRam(uart_reading));
	MOVLW       _uart_reading+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_uart_reading+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_uart_reading+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,224 :: 		ptr = buffer0;
	MOVLW       _buffer0+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,225 :: 		ptrIndex = 0;
	CLRF        soundrec_ptrIndex+0 
	CLRF        soundrec_ptrIndex+1 
;soundrec.c,226 :: 		sectorIndex = 0;
	CLRF        _sectorIndex+0 
	CLRF        _sectorIndex+1 
	CLRF        _sectorIndex+2 
	CLRF        _sectorIndex+3 
;soundrec.c,227 :: 		bufferFull = 0;
	CLRF        _bufferFull+0 
;soundrec.c,228 :: 		currentBuffer = 0;
	CLRF        _currentBuffer+0 
;soundrec.c,231 :: 		if (Mmc_Read_Sector(sectorIndex, buffer0) != 0)
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
	GOTO        L_main32
;soundrec.c,233 :: 		UWR(codeToRam(uart_initReadError));
	MOVLW       _uart_initReadError+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_uart_initReadError+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_uart_initReadError+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,234 :: 		}
L_main32:
;soundrec.c,237 :: 		T1CON |= (1 << TMR1ON);
	BSF         T1CON+0, 0 
;soundrec.c,243 :: 		while (SLCT)				/* Wait until SLCT pressed */
L_main33:
	BTFSS       RB0_bit+0, BitPos(RB0_bit+0) 
	GOTO        L_main34
;soundrec.c,245 :: 		if (bufferFull == 1)
	MOVF        _bufferFull+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main35
;soundrec.c,247 :: 		bufferFull = 0;
	CLRF        _bufferFull+0 
;soundrec.c,248 :: 		if (currentBuffer)	/* Read buffer 0 */
	MOVF        _currentBuffer+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main36
;soundrec.c,250 :: 		if (Mmc_Read_Sector(sectorIndex++, buffer0) != 0)
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
	GOTO        L_main37
;soundrec.c,252 :: 		UWR(codeToRam(uart_errorRead));
	MOVLW       _uart_errorRead+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_uart_errorRead+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_uart_errorRead+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,253 :: 		}
L_main37:
;soundrec.c,254 :: 		}
	GOTO        L_main38
L_main36:
;soundrec.c,257 :: 		if (Mmc_Read_Sector(sectorIndex++, buffer1) != 0)
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
	GOTO        L_main39
;soundrec.c,259 :: 		UWR(codeToRam(uart_errorRead));
	MOVLW       _uart_errorRead+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_uart_errorRead+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_uart_errorRead+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,260 :: 		}
L_main39:
;soundrec.c,261 :: 		}
L_main38:
;soundrec.c,262 :: 		}
L_main35:
;soundrec.c,263 :: 		}
	GOTO        L_main33
L_main34:
;soundrec.c,266 :: 		T1CON &= ~(1 << TMR1ON);
	BCF         T1CON+0, 0 
;soundrec.c,271 :: 		Delay_ms(500);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_main40:
	DECFSZ      R13, 1, 1
	BRA         L_main40
	DECFSZ      R12, 1, 1
	BRA         L_main40
	DECFSZ      R11, 1, 1
	BRA         L_main40
	NOP
;soundrec.c,273 :: 		UWR(codeToRam(uart_done));
	MOVLW       _uart_done+0
	MOVWF       FARG_codeToRam_ctxt+0 
	MOVLW       hi_addr(_uart_done+0)
	MOVWF       FARG_codeToRam_ctxt+1 
	MOVLW       higher_addr(_uart_done+0)
	MOVWF       FARG_codeToRam_ctxt+2 
	CALL        _codeToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVF        R1, 0 
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,274 :: 		}
	GOTO        L_main41
L_main31:
;soundrec.c,277 :: 		else if (mode == 3)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main75
	MOVLW       3
	XORWF       _mode+0, 0 
L__main75:
	BTFSS       STATUS+0, 2 
	GOTO        L_main42
;soundrec.c,280 :: 		for (i = 0; i < 512; i++)
	CLRF        main_i_L0+0 
	CLRF        main_i_L0+1 
L_main43:
	MOVLW       2
	SUBWF       main_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main76
	MOVLW       0
	SUBWF       main_i_L0+0, 0 
L__main76:
	BTFSC       STATUS+0, 0 
	GOTO        L_main44
;soundrec.c,282 :: 		buffer0[i] = 0;
	MOVLW       _buffer0+0
	ADDWF       main_i_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_buffer0+0)
	ADDWFC      main_i_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;soundrec.c,283 :: 		buffer1[i] = 0;
	MOVLW       _buffer1+0
	ADDWF       main_i_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_buffer1+0)
	ADDWFC      main_i_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;soundrec.c,280 :: 		for (i = 0; i < 512; i++)
	INFSNZ      main_i_L0+0, 1 
	INCF        main_i_L0+1, 1 
;soundrec.c,284 :: 		}
	GOTO        L_main43
L_main44:
;soundrec.c,287 :: 		Mmc_Read_Sector(5, buffer0);
	MOVLW       5
	MOVWF       FARG_Mmc_Read_Sector_sector+0 
	MOVLW       0
	MOVWF       FARG_Mmc_Read_Sector_sector+1 
	MOVWF       FARG_Mmc_Read_Sector_sector+2 
	MOVWF       FARG_Mmc_Read_Sector_sector+3 
	MOVLW       _buffer0+0
	MOVWF       FARG_Mmc_Read_Sector_dbuff+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       FARG_Mmc_Read_Sector_dbuff+1 
	CALL        _Mmc_Read_Sector+0, 0
;soundrec.c,288 :: 		Mmc_Read_Sector(10, buffer1);
	MOVLW       10
	MOVWF       FARG_Mmc_Read_Sector_sector+0 
	MOVLW       0
	MOVWF       FARG_Mmc_Read_Sector_sector+1 
	MOVWF       FARG_Mmc_Read_Sector_sector+2 
	MOVWF       FARG_Mmc_Read_Sector_sector+3 
	MOVLW       _buffer1+0
	MOVWF       FARG_Mmc_Read_Sector_dbuff+0 
	MOVLW       hi_addr(_buffer1+0)
	MOVWF       FARG_Mmc_Read_Sector_dbuff+1 
	CALL        _Mmc_Read_Sector+0, 0
;soundrec.c,291 :: 		for (i = 0; i < 512; i++)
	CLRF        main_i_L0+0 
	CLRF        main_i_L0+1 
L_main46:
	MOVLW       2
	SUBWF       main_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main77
	MOVLW       0
	SUBWF       main_i_L0+0, 0 
L__main77:
	BTFSC       STATUS+0, 0 
	GOTO        L_main47
;soundrec.c,293 :: 		intToStr(buffer0[i], text);
	MOVLW       _buffer0+0
	ADDWF       main_i_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_buffer0+0)
	ADDWFC      main_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _text+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,294 :: 		UWR(text);
	MOVLW       _text+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,291 :: 		for (i = 0; i < 512; i++)
	INFSNZ      main_i_L0+0, 1 
	INCF        main_i_L0+1, 1 
;soundrec.c,295 :: 		}
	GOTO        L_main46
L_main47:
;soundrec.c,296 :: 		}
L_main42:
L_main41:
L_main30:
;soundrec.c,301 :: 		}
	GOTO        L_main4
;soundrec.c,302 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_mmcBuiltinInit:

;soundrec.c,304 :: 		void mmcBuiltinInit(void)
;soundrec.c,308 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,311 :: 		while (MMC_Init() != 0)
L_mmcBuiltinInit49:
	CALL        _Mmc_Init+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_mmcBuiltinInit50
;soundrec.c,313 :: 		}
	GOTO        L_mmcBuiltinInit49
L_mmcBuiltinInit50:
;soundrec.c,317 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	CLRF        FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,318 :: 		}
L_end_mmcBuiltinInit:
	RETURN      0
; end of _mmcBuiltinInit

_interrupt:

;soundrec.c,320 :: 		void interrupt()
;soundrec.c,322 :: 		if (PIR1.TMR1IF == 1)
	BTFSS       PIR1+0, 0 
	GOTO        L_interrupt51
;soundrec.c,325 :: 		PIR1.TMR1IF = 0;
	BCF         PIR1+0, 0 
;soundrec.c,330 :: 		TMR1H = 0xfe;
	MOVLW       254
	MOVWF       TMR1H+0 
;soundrec.c,331 :: 		TMR1L = 0xc7;
	MOVLW       199
	MOVWF       TMR1L+0 
;soundrec.c,333 :: 		if (mode == 1)					/* Record mode */
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt81
	MOVLW       1
	XORWF       _mode+0, 0 
L__interrupt81:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt52
;soundrec.c,336 :: 		GO_bit = 1;
	BSF         GO_bit+0, BitPos(GO_bit+0) 
;soundrec.c,337 :: 		}
	GOTO        L_interrupt53
L_interrupt52:
;soundrec.c,339 :: 		else if (mode == 2)				/* Play mode */
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt82
	MOVLW       2
	XORWF       _mode+0, 0 
L__interrupt82:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt54
;soundrec.c,346 :: 		LATD = *(ptr + (ptrIndex++));
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
;soundrec.c,350 :: 		if (ptrIndex == 512)
	MOVF        soundrec_ptrIndex+1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt83
	MOVLW       0
	XORWF       soundrec_ptrIndex+0, 0 
L__interrupt83:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt55
;soundrec.c,352 :: 		ptrIndex = 0;
	CLRF        soundrec_ptrIndex+0 
	CLRF        soundrec_ptrIndex+1 
;soundrec.c,353 :: 		bufferFull = 1;
	MOVLW       1
	MOVWF       _bufferFull+0 
;soundrec.c,354 :: 		if (currentBuffer == 0)
	MOVF        _currentBuffer+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt56
;soundrec.c,356 :: 		ptr = buffer1;
	MOVLW       _buffer1+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer1+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,357 :: 		currentBuffer = 1;
	MOVLW       1
	MOVWF       _currentBuffer+0 
;soundrec.c,358 :: 		}
	GOTO        L_interrupt57
L_interrupt56:
;soundrec.c,361 :: 		ptr = buffer0;
	MOVLW       _buffer0+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,362 :: 		currentBuffer = 0;
	CLRF        _currentBuffer+0 
;soundrec.c,363 :: 		}
L_interrupt57:
;soundrec.c,364 :: 		}
L_interrupt55:
;soundrec.c,365 :: 		}
L_interrupt54:
L_interrupt53:
;soundrec.c,366 :: 		}
L_interrupt51:
;soundrec.c,368 :: 		if (PIR1 & (1 << ADIF))
	BTFSS       PIR1+0, 6 
	GOTO        L_interrupt58
;soundrec.c,371 :: 		PIR1 &= ~(1 << ADIF);
	BCF         PIR1+0, 6 
;soundrec.c,374 :: 		adcResult = ADRESH;
	MOVF        ADRESH+0, 0 
	MOVWF       _adcResult+0 
;soundrec.c,376 :: 		*(ptr + (ptrIndex++)) = adcResult;
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
;soundrec.c,379 :: 		if (ptrIndex == 512)
	MOVF        soundrec_ptrIndex+1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt84
	MOVLW       0
	XORWF       soundrec_ptrIndex+0, 0 
L__interrupt84:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt59
;soundrec.c,381 :: 		ptrIndex = 0;
	CLRF        soundrec_ptrIndex+0 
	CLRF        soundrec_ptrIndex+1 
;soundrec.c,382 :: 		bufferFull = 1;
	MOVLW       1
	MOVWF       _bufferFull+0 
;soundrec.c,383 :: 		if (currentBuffer == 0)
	MOVF        _currentBuffer+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt60
;soundrec.c,385 :: 		ptr = buffer1;
	MOVLW       _buffer1+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer1+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,386 :: 		currentBuffer = 1;
	MOVLW       1
	MOVWF       _currentBuffer+0 
;soundrec.c,387 :: 		}
	GOTO        L_interrupt61
L_interrupt60:
;soundrec.c,390 :: 		ptr = buffer0;
	MOVLW       _buffer0+0
	MOVWF       soundrec_ptr+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       soundrec_ptr+1 
;soundrec.c,391 :: 		currentBuffer = 0;
	CLRF        _currentBuffer+0 
;soundrec.c,392 :: 		}
L_interrupt61:
;soundrec.c,393 :: 		}
L_interrupt59:
;soundrec.c,394 :: 		}
L_interrupt58:
;soundrec.c,395 :: 		}
L_end_interrupt:
L__interrupt80:
	RETFIE      1
; end of _interrupt

_timer1Config:

;soundrec.c,400 :: 		void timer1Config(void)
;soundrec.c,402 :: 		PIE1 = (1 << TMR1IE);
	MOVLW       1
	MOVWF       PIE1+0 
;soundrec.c,404 :: 		TMR1H = 0xfe;
	MOVLW       254
	MOVWF       TMR1H+0 
;soundrec.c,405 :: 		TMR1L = 0xc7;
	MOVLW       199
	MOVWF       TMR1L+0 
;soundrec.c,406 :: 		}
L_end_timer1Config:
	RETURN      0
; end of _timer1Config

_pwmConfig:

;soundrec.c,412 :: 		void pwmConfig(void)
;soundrec.c,414 :: 		PR2 = 77; 							/* 16.025 kHz */
	MOVLW       77
	MOVWF       PR2+0 
;soundrec.c,415 :: 		TRISB &= ~(1 << RB3);				/* Output for PWM */
	BCF         TRISB+0, 3 
;soundrec.c,416 :: 		CCPR2L	= 128;						/* Initial duty cycle is 0 */
	MOVLW       128
	MOVWF       CCPR2L+0 
;soundrec.c,417 :: 		T2CON = (1 << TMR2ON);				/* Enable timer 2 */
	MOVLW       4
	MOVWF       T2CON+0 
;soundrec.c,418 :: 		}
L_end_pwmConfig:
	RETURN      0
; end of _pwmConfig

_pwmStart:

;soundrec.c,423 :: 		void pwmStart(void)
;soundrec.c,425 :: 		CCP2CON = (1 << CCP2M3) | (1 << CCP2M2);	/* PWM mode */
	MOVLW       12
	MOVWF       CCP2CON+0 
;soundrec.c,426 :: 		}
L_end_pwmStart:
	RETURN      0
; end of _pwmStart

_pwmStop:

;soundrec.c,431 :: 		void pwmStop(void)
;soundrec.c,433 :: 		CCP2CON = 0;
	CLRF        CCP2CON+0 
;soundrec.c,434 :: 		}
L_end_pwmStop:
	RETURN      0
; end of _pwmStop

_pwmChangeDutyCycle:

;soundrec.c,439 :: 		void pwmChangeDutyCycle(uint8_t dutyCycle)
;soundrec.c,441 :: 		CCPR2L = dutyCycle;
	MOVF        FARG_pwmChangeDutyCycle_dutyCycle+0, 0 
	MOVWF       CCPR2L+0 
;soundrec.c,442 :: 		}
L_end_pwmChangeDutyCycle:
	RETURN      0
; end of _pwmChangeDutyCycle
