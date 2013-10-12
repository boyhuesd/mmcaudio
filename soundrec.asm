
_codeToRam:

;soundrec.c,86 :: 		char* codeToRam(const char* ctxt)
;soundrec.c,90 :: 		for(i =0; txt[i] = ctxt[i]; i++);
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
;soundrec.c,92 :: 		return txt;
	MOVLW       codeToRam_txt_L0+0
	MOVWF       R0 
	MOVLW       hi_addr(codeToRam_txt_L0+0)
	MOVWF       R1 
;soundrec.c,93 :: 		}
L_end_codeToRam:
	RETURN      0
; end of _codeToRam

_main:

;soundrec.c,95 :: 		void main()
;soundrec.c,99 :: 		ptr = &buffer0[0];
	MOVLW       _buffer0+0
	MOVWF       _ptr+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       _ptr+1 
;soundrec.c,100 :: 		currentBuffer = 0;
	CLRF        _currentBuffer+0 
;soundrec.c,101 :: 		adcInit();
	CALL        _adcInit+0, 0
;soundrec.c,102 :: 		Delay_ms(100);
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
;soundrec.c,105 :: 		TRISD = 0xff;
	MOVLW       255
	MOVWF       TRISD+0 
;soundrec.c,106 :: 		TRISA2_bit=1;
	BSF         TRISA2_bit+0, BitPos(TRISA2_bit+0) 
;soundrec.c,107 :: 		TRISD2_bit=1;
	BSF         TRISD2_bit+0, BitPos(TRISD2_bit+0) 
;soundrec.c,108 :: 		TRISD3_bit=1;
	BSF         TRISD3_bit+0, BitPos(TRISD3_bit+0) 
;soundrec.c,109 :: 		TRISD7_bit = 0;
	BCF         TRISD7_bit+0, BitPos(TRISD7_bit+0) 
;soundrec.c,110 :: 		TRISB=0;
	CLRF        TRISB+0 
;soundrec.c,111 :: 		TRISC = 0x00;
	CLRF        TRISC+0 
;soundrec.c,113 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	MOVLW       2
	MOVWF       SPBRGH+0 
	MOVLW       8
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;soundrec.c,114 :: 		UWR(codeToRam(uart_welcome));
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
;soundrec.c,115 :: 		mmcBuiltinInit();
	CALL        _mmcBuiltinInit+0, 0
;soundrec.c,116 :: 		specialEventTriggerSetup();
	CALL        _specialEventTriggerSetup+0, 0
;soundrec.c,117 :: 		timer1Config();
	CALL        _timer1Config+0, 0
;soundrec.c,118 :: 		LATD7_bit = 0;
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
;soundrec.c,119 :: 		INTCON |= (1 << GIE) | (1 << PEIE);
	MOVLW       192
	IORWF       INTCON+0, 1 
;soundrec.c,121 :: 		for (;;)        					/* Repeat forever */
L_main4:
;soundrec.c,123 :: 		while (SLCT != 0)
L_main7:
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main8
;soundrec.c,125 :: 		}
	GOTO        L_main7
L_main8:
;soundrec.c,127 :: 		UWR(codeToRam(uart_menu));
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
;soundrec.c,129 :: 		while (OK)	/* OK not pressed */
L_main9:
	BTFSS       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_main10
;soundrec.c,131 :: 		if (!SLCT)	/* SLCT */
	BTFSC       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main11
;soundrec.c,133 :: 		Delay_ms(300);
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
;soundrec.c,134 :: 		mode++;
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
;soundrec.c,135 :: 		if (mode == 5)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main41
	MOVLW       5
	XORWF       _mode+0, 0 
L__main41:
	BTFSS       STATUS+0, 2 
	GOTO        L_main13
;soundrec.c,137 :: 		mode = 1;
	MOVLW       1
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
;soundrec.c,138 :: 		}
L_main13:
;soundrec.c,139 :: 		}
L_main11:
;soundrec.c,141 :: 		if ((mode == 1) & (lastMode != mode))
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main42
	MOVLW       1
	XORWF       _mode+0, 0 
L__main42:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main43
	MOVF        _mode+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main43:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main14
;soundrec.c,143 :: 		UWR(codeToRam(uart_record));
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
;soundrec.c,144 :: 		}
	GOTO        L_main15
L_main14:
;soundrec.c,145 :: 		else if ((mode == 2) & (lastMode != mode))
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main44
	MOVLW       2
	XORWF       _mode+0, 0 
L__main44:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main45
	MOVF        _mode+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main45:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main16
;soundrec.c,147 :: 		UWR(codeToRam(uart_play));
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
;soundrec.c,148 :: 		}
	GOTO        L_main17
L_main16:
;soundrec.c,149 :: 		else if ((mode == 3) & (lastMode != mode))
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main46
	MOVLW       3
	XORWF       _mode+0, 0 
L__main46:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main47
	MOVF        _mode+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main47:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main18
;soundrec.c,151 :: 		UWR(codeToRam(uart_trackList));
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
;soundrec.c,152 :: 		}
	GOTO        L_main19
L_main18:
;soundrec.c,153 :: 		else if ((mode == 4) & (lastMode != mode))
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main48
	MOVLW       4
	XORWF       _mode+0, 0 
L__main48:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main49
	MOVF        _mode+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main49:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main20
;soundrec.c,155 :: 		UWR(codeToRam(uart_changeSampleRate));
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
;soundrec.c,156 :: 		}
L_main20:
L_main19:
L_main17:
L_main15:
;soundrec.c,158 :: 		lastMode = mode;
	MOVF        _mode+0, 0 
	MOVWF       main_lastMode_L0+0 
;soundrec.c,159 :: 		}
	GOTO        L_main9
L_main10:
;soundrec.c,162 :: 		if (mode == 1)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main50
	MOVLW       1
	XORWF       _mode+0, 0 
L__main50:
	BTFSS       STATUS+0, 2 
	GOTO        L_main21
;soundrec.c,165 :: 		UWR(codeToRam(uart_writing));
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
;soundrec.c,166 :: 		ptr = buffer0;
	MOVLW       _buffer0+0
	MOVWF       _ptr+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       _ptr+1 
;soundrec.c,167 :: 		ptrIndex = 0;
	CLRF        _ptrIndex+0 
	CLRF        _ptrIndex+1 
;soundrec.c,168 :: 		sectorIndex = 0;
	CLRF        _sectorIndex+0 
	CLRF        _sectorIndex+1 
	CLRF        _sectorIndex+2 
	CLRF        _sectorIndex+3 
;soundrec.c,170 :: 		T1CON = (1 << TMR1ON);
	MOVLW       1
	MOVWF       T1CON+0 
;soundrec.c,171 :: 		while (SLCT)		/* Wait until SLCT pressed */
L_main22:
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main23
;soundrec.c,173 :: 		if (bufferFull == 1)
	MOVF        _bufferFull+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main24
;soundrec.c,175 :: 		bufferFull = 0;
	CLRF        _bufferFull+0 
;soundrec.c,176 :: 		if (currentBuffer)	/* Write buffer 0 */
	MOVF        _currentBuffer+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main25
;soundrec.c,178 :: 		if (Mmc_Write_Sector(sectorIndex++, buffer0) != 0)
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
;soundrec.c,180 :: 		UWR(codeToRam(uart_errorWrite));
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
;soundrec.c,181 :: 		}
L_main26:
;soundrec.c,182 :: 		}
	GOTO        L_main27
L_main25:
;soundrec.c,185 :: 		if (Mmc_Write_Sector(sectorIndex++, buffer1) != 0)
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
;soundrec.c,187 :: 		UWR(codeToRam(uart_errorWrite));
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
;soundrec.c,188 :: 		}
L_main28:
;soundrec.c,189 :: 		}
L_main27:
;soundrec.c,190 :: 		}
L_main24:
;soundrec.c,191 :: 		}
	GOTO        L_main22
L_main23:
;soundrec.c,192 :: 		T1CON &= ~(1 << TMR1ON);
	BCF         T1CON+0, 0 
;soundrec.c,193 :: 		Delay_ms(500);
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
;soundrec.c,196 :: 		intToStr(sectorIndex, text);
	MOVF        _sectorIndex+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _sectorIndex+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _text+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,197 :: 		UWR(codeToRam(uart_done));
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
;soundrec.c,198 :: 		UWR(text);
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
;soundrec.c,199 :: 		intToStr(adcCount, text);
	MOVF        _adcCount+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _adcCount+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _text+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_text+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,200 :: 		UWR(text);
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
;soundrec.c,201 :: 		}
	GOTO        L_main30
L_main21:
;soundrec.c,204 :: 		else if (mode == 2)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main51
	MOVLW       2
	XORWF       _mode+0, 0 
L__main51:
	BTFSS       STATUS+0, 2 
	GOTO        L_main31
;soundrec.c,206 :: 		UWR("fu");
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
;soundrec.c,207 :: 		TMR1H = 0xc2;
	MOVLW       194
	MOVWF       TMR1H+0 
;soundrec.c,208 :: 		TMR1L = 0xf6;
	MOVLW       246
	MOVWF       TMR1L+0 
;soundrec.c,210 :: 		T1CON |= (1 << TMR1ON);
	BSF         T1CON+0, 0 
;soundrec.c,211 :: 		}
L_main31:
L_main30:
;soundrec.c,214 :: 		}
	GOTO        L_main4
;soundrec.c,215 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_mmcBuiltinInit:

;soundrec.c,217 :: 		void mmcBuiltinInit(void)
;soundrec.c,221 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,224 :: 		while (MMC_Init() != 0)
L_mmcBuiltinInit32:
	CALL        _Mmc_Init+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_mmcBuiltinInit33
;soundrec.c,226 :: 		}
	GOTO        L_mmcBuiltinInit32
L_mmcBuiltinInit33:
;soundrec.c,230 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	CLRF        FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,231 :: 		}
L_end_mmcBuiltinInit:
	RETURN      0
; end of _mmcBuiltinInit

_interrupt:

;soundrec.c,233 :: 		void interrupt()
;soundrec.c,236 :: 		if (PIR1.TMR1IF == 1)
	BTFSS       PIR1+0, 0 
	GOTO        L_interrupt34
;soundrec.c,239 :: 		PIR1.TMR1IF = 0;
	BCF         PIR1+0, 0 
;soundrec.c,240 :: 		GO_bit = 1;
	BSF         GO_bit+0, BitPos(GO_bit+0) 
;soundrec.c,244 :: 		TMR1H = 0xfe;
	MOVLW       254
	MOVWF       TMR1H+0 
;soundrec.c,245 :: 		TMR1L = 0xc7;
	MOVLW       199
	MOVWF       TMR1L+0 
;soundrec.c,246 :: 		}
L_interrupt34:
;soundrec.c,248 :: 		if (PIR1 & (1 << ADIF))
	BTFSS       PIR1+0, 6 
	GOTO        L_interrupt35
;soundrec.c,250 :: 		PIR1 &= ~(1 << ADIF);
	BCF         PIR1+0, 6 
;soundrec.c,253 :: 		*(ptr + (ptrIndex++)) = ADRESH;
	MOVF        _ptrIndex+0, 0 
	MOVWF       R0 
	MOVF        _ptrIndex+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	ADDWF       _ptr+0, 0 
	MOVWF       FSR1 
	MOVF        R1, 0 
	ADDWFC      _ptr+1, 0 
	MOVWF       FSR1H 
	MOVF        ADRESH+0, 0 
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
	INFSNZ      _ptrIndex+0, 1 
	INCF        _ptrIndex+1, 1 
;soundrec.c,256 :: 		if (ptrIndex == 512)
	MOVF        _ptrIndex+1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt55
	MOVLW       0
	XORWF       _ptrIndex+0, 0 
L__interrupt55:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt36
;soundrec.c,258 :: 		ptrIndex = 0;
	CLRF        _ptrIndex+0 
	CLRF        _ptrIndex+1 
;soundrec.c,259 :: 		bufferFull = 1;
	MOVLW       1
	MOVWF       _bufferFull+0 
;soundrec.c,260 :: 		if (currentBuffer == 0)
	MOVF        _currentBuffer+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt37
;soundrec.c,262 :: 		ptr = &buffer1[0];
	MOVLW       _buffer1+0
	MOVWF       _ptr+0 
	MOVLW       hi_addr(_buffer1+0)
	MOVWF       _ptr+1 
;soundrec.c,263 :: 		currentBuffer = 1;
	MOVLW       1
	MOVWF       _currentBuffer+0 
;soundrec.c,264 :: 		}
	GOTO        L_interrupt38
L_interrupt37:
;soundrec.c,267 :: 		ptr = &buffer0[0];
	MOVLW       _buffer0+0
	MOVWF       _ptr+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       _ptr+1 
;soundrec.c,268 :: 		currentBuffer = 0;
	CLRF        _currentBuffer+0 
;soundrec.c,269 :: 		}
L_interrupt38:
;soundrec.c,270 :: 		}
L_interrupt36:
;soundrec.c,271 :: 		}
L_interrupt35:
;soundrec.c,272 :: 		}
L_end_interrupt:
L__interrupt54:
	RETFIE      1
; end of _interrupt

_timer1Config:

;soundrec.c,274 :: 		void timer1Config(void)
;soundrec.c,278 :: 		PIE1 = (1 << TMR1IE);
	MOVLW       1
	MOVWF       PIE1+0 
;soundrec.c,280 :: 		TMR1H = 0xfe;
	MOVLW       254
	MOVWF       TMR1H+0 
;soundrec.c,281 :: 		TMR1L = 0xc7;
	MOVLW       199
	MOVWF       TMR1L+0 
;soundrec.c,282 :: 		}
L_end_timer1Config:
	RETURN      0
; end of _timer1Config
