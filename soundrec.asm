
_codeToRam:

;soundrec.c,76 :: 		char* codeToRam(const char* ctxt)
;soundrec.c,80 :: 		for(i =0; txt[i] = ctxt[i]; i++);
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
;soundrec.c,82 :: 		return txt;
	MOVLW       codeToRam_txt_L0+0
	MOVWF       R0 
	MOVLW       hi_addr(codeToRam_txt_L0+0)
	MOVWF       R1 
;soundrec.c,83 :: 		}
L_end_codeToRam:
	RETURN      0
; end of _codeToRam

_adcRead:

;soundrec.c,89 :: 		adcRead(void)
;soundrec.c,92 :: 		GO_bit = 1; // Begin conversion
	BSF         GO_bit+0, BitPos(GO_bit+0) 
;soundrec.c,93 :: 		while (!GO); // Wait for conversion completed
L_adcRead4:
;soundrec.c,95 :: 		return ADRESH;
	MOVF        ADRESH+0, 0 
	MOVWF       R0 
;soundrec.c,96 :: 		}
L_end_adcRead:
	RETURN      0
; end of _adcRead

_caidatMMC:

;soundrec.c,99 :: 		void caidatMMC()
;soundrec.c,101 :: 		UWR("Detecting MMC");
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
;soundrec.c,102 :: 		Delay_ms(1000);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_caidatMMC5:
	DECFSZ      R13, 1, 1
	BRA         L_caidatMMC5
	DECFSZ      R12, 1, 1
	BRA         L_caidatMMC5
	DECFSZ      R11, 1, 1
	BRA         L_caidatMMC5
	NOP
;soundrec.c,104 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,106 :: 		while (MMC_Init() != 0)
L_caidatMMC6:
	CALL        _Mmc_Init+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_caidatMMC7
;soundrec.c,108 :: 		}
	GOTO        L_caidatMMC6
L_caidatMMC7:
;soundrec.c,111 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	CLRF        FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,112 :: 		UWR("MMC Detected!");
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
;soundrec.c,113 :: 		Delay_ms (1000);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_caidatMMC8:
	DECFSZ      R13, 1, 1
	BRA         L_caidatMMC8
	DECFSZ      R12, 1, 1
	BRA         L_caidatMMC8
	DECFSZ      R11, 1, 1
	BRA         L_caidatMMC8
	NOP
;soundrec.c,114 :: 		}
L_end_caidatMMC:
	RETURN      0
; end of _caidatMMC

_command:

;soundrec.c,123 :: 		command(char command, uint32_t fourbyte_arg, char CRCbits)
;soundrec.c,125 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,126 :: 		spiWrite(0b01000000 | command);
	MOVLW       64
	IORWF       FARG_command_command+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,127 :: 		spiWrite((uint8_t) (fourbyte_arg >> 24));
	MOVF        FARG_command_fourbyte_arg+3, 0 
	MOVWF       R0 
	CLRF        R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,128 :: 		spiWrite((uint8_t) (fourbyte_arg >> 16));
	MOVF        FARG_command_fourbyte_arg+2, 0 
	MOVWF       R0 
	MOVF        FARG_command_fourbyte_arg+3, 0 
	MOVWF       R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,129 :: 		spiWrite((uint8_t) (fourbyte_arg >> 8));
	MOVF        FARG_command_fourbyte_arg+1, 0 
	MOVWF       R0 
	MOVF        FARG_command_fourbyte_arg+2, 0 
	MOVWF       R1 
	MOVF        FARG_command_fourbyte_arg+3, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,130 :: 		spiWrite((uint8_t) (fourbyte_arg));
	MOVF        FARG_command_fourbyte_arg+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,131 :: 		spiWrite(CRCbits);
	MOVF        FARG_command_CRCbits+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,132 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,133 :: 		}
L_end_command:
	RETURN      0
; end of _command

_mmcInit:

;soundrec.c,136 :: 		mmcInit(void)
;soundrec.c,140 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,141 :: 		Delay_ms(2);
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_mmcInit9:
	DECFSZ      R13, 1, 1
	BRA         L_mmcInit9
	DECFSZ      R12, 1, 1
	BRA         L_mmcInit9
	NOP
	NOP
;soundrec.c,142 :: 		Mmc_Chip_Select = 1;
	BSF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;soundrec.c,143 :: 		UWR("CS is HIGH!");
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
;soundrec.c,144 :: 		for (u = 0; u < 10; u++)
	CLRF        mmcInit_u_L0+0 
L_mmcInit10:
	MOVLW       10
	SUBWF       mmcInit_u_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_mmcInit11
;soundrec.c,146 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,144 :: 		for (u = 0; u < 10; u++)
	INCF        mmcInit_u_L0+0, 1 
;soundrec.c,147 :: 		}
	GOTO        L_mmcInit10
L_mmcInit11:
;soundrec.c,148 :: 		UWR("Dummy clock sent!");
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
;soundrec.c,149 :: 		Mmc_Chip_Select = 0;
	BCF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;soundrec.c,150 :: 		UWR("CS is LOW!\n");
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
;soundrec.c,151 :: 		Delay_ms(1);
	MOVLW       7
	MOVWF       R12, 0
	MOVLW       125
	MOVWF       R13, 0
L_mmcInit13:
	DECFSZ      R13, 1, 1
	BRA         L_mmcInit13
	DECFSZ      R12, 1, 1
	BRA         L_mmcInit13
;soundrec.c,152 :: 		command(0, 0, 0x95);
	CLRF        FARG_command_command+0 
	CLRF        FARG_command_fourbyte_arg+0 
	CLRF        FARG_command_fourbyte_arg+1 
	CLRF        FARG_command_fourbyte_arg+2 
	CLRF        FARG_command_fourbyte_arg+3 
	MOVLW       149
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;soundrec.c,153 :: 		UWR("CMD0 sent!");
	MOVLW       ?lstr6_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr6_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,154 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,155 :: 		while ((spiReadData != 1) && (count < 10))
L_mmcInit14:
	MOVF        _spiReadData+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_mmcInit15
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_mmcInit15
L__mmcInit155:
;soundrec.c,157 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,158 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,159 :: 		}
	GOTO        L_mmcInit14
L_mmcInit15:
;soundrec.c,160 :: 		if (count >= 10)
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_mmcInit18
;soundrec.c,162 :: 		UWR("CARD ERROR - CMD0");
	MOVLW       ?lstr7_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr7_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,163 :: 		while (1); // Trap the CPU
L_mmcInit19:
	GOTO        L_mmcInit19
;soundrec.c,164 :: 		}
L_mmcInit18:
;soundrec.c,165 :: 		command(1, 0, 0xff);
	MOVLW       1
	MOVWF       FARG_command_command+0 
	CLRF        FARG_command_fourbyte_arg+0 
	CLRF        FARG_command_fourbyte_arg+1 
	CLRF        FARG_command_fourbyte_arg+2 
	CLRF        FARG_command_fourbyte_arg+3 
	MOVLW       255
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;soundrec.c,166 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,167 :: 		while ((spiReadData != 0) && (count < 1000))
L_mmcInit21:
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_mmcInit22
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mmcInit162
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit162:
	BTFSC       STATUS+0, 0 
	GOTO        L_mmcInit22
L__mmcInit154:
;soundrec.c,169 :: 		command(1, 0, 0xff);
	MOVLW       1
	MOVWF       FARG_command_command+0 
	CLRF        FARG_command_fourbyte_arg+0 
	CLRF        FARG_command_fourbyte_arg+1 
	CLRF        FARG_command_fourbyte_arg+2 
	CLRF        FARG_command_fourbyte_arg+3 
	MOVLW       255
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;soundrec.c,170 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,171 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,172 :: 		}
	GOTO        L_mmcInit21
L_mmcInit22:
;soundrec.c,173 :: 		if (count >= 1000)
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mmcInit163
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit163:
	BTFSS       STATUS+0, 0 
	GOTO        L_mmcInit25
;soundrec.c,175 :: 		UWR("Card ERROR - CMD1");
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
;soundrec.c,176 :: 		while (1); // Trap the CPU
L_mmcInit26:
	GOTO        L_mmcInit26
;soundrec.c,177 :: 		}
L_mmcInit25:
;soundrec.c,178 :: 		command(16, 512, 0xff);
	MOVLW       16
	MOVWF       FARG_command_command+0 
	MOVLW       0
	MOVWF       FARG_command_fourbyte_arg+0 
	MOVLW       2
	MOVWF       FARG_command_fourbyte_arg+1 
	MOVLW       0
	MOVWF       FARG_command_fourbyte_arg+2 
	MOVWF       FARG_command_fourbyte_arg+3 
	MOVLW       255
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;soundrec.c,179 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,180 :: 		while ((spiReadData != 0) && (count < 1000))
L_mmcInit28:
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_mmcInit29
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mmcInit164
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit164:
	BTFSC       STATUS+0, 0 
	GOTO        L_mmcInit29
L__mmcInit153:
;soundrec.c,182 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,183 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,184 :: 		}
	GOTO        L_mmcInit28
L_mmcInit29:
;soundrec.c,185 :: 		if (count >= 1000)
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mmcInit165
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit165:
	BTFSS       STATUS+0, 0 
	GOTO        L_mmcInit32
;soundrec.c,187 :: 		UWR("Card error - CMD16");
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
;soundrec.c,188 :: 		while (1); // Trap the CPU
L_mmcInit33:
	GOTO        L_mmcInit33
;soundrec.c,189 :: 		}
L_mmcInit32:
;soundrec.c,190 :: 		UWR("MMC Detected!");
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
;soundrec.c,194 :: 		Delay_ms(20);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_mmcInit35:
	DECFSZ      R13, 1, 1
	BRA         L_mmcInit35
	DECFSZ      R12, 1, 1
	BRA         L_mmcInit35
	NOP
	NOP
;soundrec.c,196 :: 		}
L_end_mmcInit:
	RETURN      0
; end of _mmcInit

_writeSingleBlock:

;soundrec.c,199 :: 		writeSingleBlock(void)
;soundrec.c,201 :: 		uint16_t g = 0;
	CLRF        writeSingleBlock_g_L0+0 
	CLRF        writeSingleBlock_g_L0+1 
;soundrec.c,202 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,204 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,205 :: 		while (spiReadData != 0xff)
L_writeSingleBlock36:
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_writeSingleBlock37
;soundrec.c,207 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,208 :: 		UWR("Card busy!");
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
;soundrec.c,209 :: 		}
	GOTO        L_writeSingleBlock36
L_writeSingleBlock37:
;soundrec.c,211 :: 		command(24, arg, 0x95);
	MOVLW       24
	MOVWF       FARG_command_command+0 
	MOVF        _arg+0, 0 
	MOVWF       FARG_command_fourbyte_arg+0 
	MOVF        _arg+1, 0 
	MOVWF       FARG_command_fourbyte_arg+1 
	MOVF        _arg+2, 0 
	MOVWF       FARG_command_fourbyte_arg+2 
	MOVF        _arg+3, 0 
	MOVWF       FARG_command_fourbyte_arg+3 
	MOVLW       149
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;soundrec.c,213 :: 		while (spiReadData != 0)
L_writeSingleBlock38:
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_writeSingleBlock39
;soundrec.c,215 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,216 :: 		}
	GOTO        L_writeSingleBlock38
L_writeSingleBlock39:
;soundrec.c,217 :: 		UWR("Command accepted!");
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
;soundrec.c,218 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,219 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,220 :: 		spiWrite(0b11111110); // Data token for CMD 24
	MOVLW       254
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,221 :: 		for (g = 0; g < 512; g++)
	CLRF        writeSingleBlock_g_L0+0 
	CLRF        writeSingleBlock_g_L0+1 
L_writeSingleBlock40:
	MOVLW       2
	SUBWF       writeSingleBlock_g_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__writeSingleBlock167
	MOVLW       0
	SUBWF       writeSingleBlock_g_L0+0, 0 
L__writeSingleBlock167:
	BTFSC       STATUS+0, 0 
	GOTO        L_writeSingleBlock41
;soundrec.c,223 :: 		spiWrite(0x50);
	MOVLW       80
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,221 :: 		for (g = 0; g < 512; g++)
	INFSNZ      writeSingleBlock_g_L0+0, 1 
	INCF        writeSingleBlock_g_L0+1, 1 
;soundrec.c,224 :: 		}
	GOTO        L_writeSingleBlock40
L_writeSingleBlock41:
;soundrec.c,225 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,226 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,227 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,229 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,230 :: 		while (count < 10)
L_writeSingleBlock43:
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_writeSingleBlock44
;soundrec.c,232 :: 		if ((spiReadData & 0b00011111) == 0x05)
	MOVLW       31
	ANDWF       _spiReadData+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_writeSingleBlock45
;soundrec.c,234 :: 		UWR("Data accepted!");
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
;soundrec.c,235 :: 		break;
	GOTO        L_writeSingleBlock44
;soundrec.c,236 :: 		}
L_writeSingleBlock45:
;soundrec.c,237 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,238 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,239 :: 		}
	GOTO        L_writeSingleBlock43
L_writeSingleBlock44:
;soundrec.c,240 :: 		if (count >= 10)
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_writeSingleBlock46
;soundrec.c,242 :: 		UWR("Data rejected!");
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
;soundrec.c,243 :: 		}
L_writeSingleBlock46:
;soundrec.c,244 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,245 :: 		while (spiReadData != 0xff)
L_writeSingleBlock47:
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_writeSingleBlock48
;soundrec.c,247 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,248 :: 		}
	GOTO        L_writeSingleBlock47
L_writeSingleBlock48:
;soundrec.c,249 :: 		UWR("Card is idle");
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
;soundrec.c,250 :: 		}
L_end_writeSingleBlock:
	RETURN      0
; end of _writeSingleBlock

_readSingleBlock:

;soundrec.c,252 :: 		readSingleBlock(void)
;soundrec.c,256 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,257 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,258 :: 		while (spiReadData != 0xff)
L_readSingleBlock49:
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_readSingleBlock50
;soundrec.c,260 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,261 :: 		UWR("Card busy!");
	MOVLW       ?lstr16_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr16_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,262 :: 		}
	GOTO        L_readSingleBlock49
L_readSingleBlock50:
;soundrec.c,264 :: 		command(17, arg, 0x95); // read 512 bytes from byte address 0
	MOVLW       17
	MOVWF       FARG_command_command+0 
	MOVF        _arg+0, 0 
	MOVWF       FARG_command_fourbyte_arg+0 
	MOVF        _arg+1, 0 
	MOVWF       FARG_command_fourbyte_arg+1 
	MOVF        _arg+2, 0 
	MOVWF       FARG_command_fourbyte_arg+2 
	MOVF        _arg+3, 0 
	MOVWF       FARG_command_fourbyte_arg+3 
	MOVLW       149
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;soundrec.c,266 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,267 :: 		while (count < 10)
L_readSingleBlock51:
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_readSingleBlock52
;soundrec.c,269 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,270 :: 		if (spiReadData == 0)
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_readSingleBlock53
;soundrec.c,272 :: 		UWR("CMD accepted!");
	MOVLW       ?lstr17_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr17_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,273 :: 		break;
	GOTO        L_readSingleBlock52
;soundrec.c,274 :: 		}
L_readSingleBlock53:
;soundrec.c,275 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,276 :: 		}
	GOTO        L_readSingleBlock51
L_readSingleBlock52:
;soundrec.c,277 :: 		if (count >= 10)
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_readSingleBlock54
;soundrec.c,279 :: 		UWR("CMD Rejected!");
	MOVLW       ?lstr18_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr18_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,280 :: 		while (1); // Trap the CPU
L_readSingleBlock55:
	GOTO        L_readSingleBlock55
;soundrec.c,281 :: 		}
L_readSingleBlock54:
;soundrec.c,283 :: 		while (spiReadData != 0xfe)
L_readSingleBlock57:
	MOVF        _spiReadData+0, 0 
	XORLW       254
	BTFSC       STATUS+0, 2 
	GOTO        L_readSingleBlock58
;soundrec.c,285 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,286 :: 		}
	GOTO        L_readSingleBlock57
L_readSingleBlock58:
;soundrec.c,287 :: 		UWR("Token received!");
	MOVLW       ?lstr19_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr19_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,289 :: 		for (numOfBytes = 0; numOfBytes < 512; numOfBytes++)
	CLRF        readSingleBlock_numOfBytes_L0+0 
	CLRF        readSingleBlock_numOfBytes_L0+1 
L_readSingleBlock59:
	MOVLW       2
	SUBWF       readSingleBlock_numOfBytes_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readSingleBlock169
	MOVLW       0
	SUBWF       readSingleBlock_numOfBytes_L0+0, 0 
L__readSingleBlock169:
	BTFSC       STATUS+0, 0 
	GOTO        L_readSingleBlock60
;soundrec.c,291 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,292 :: 		IntToStr(spiReadData, strData);
	MOVF        _spiReadData+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       readSingleBlock_strData_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(readSingleBlock_strData_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,293 :: 		UWR(strData);
	MOVLW       readSingleBlock_strData_L0+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(readSingleBlock_strData_L0+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,294 :: 		DACOUT = spiReadData;
	MOVF        _spiReadData+0, 0 
	MOVWF       LATB+0 
;soundrec.c,295 :: 		Delay_ms(2);
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_readSingleBlock62:
	DECFSZ      R13, 1, 1
	BRA         L_readSingleBlock62
	DECFSZ      R12, 1, 1
	BRA         L_readSingleBlock62
	NOP
	NOP
;soundrec.c,289 :: 		for (numOfBytes = 0; numOfBytes < 512; numOfBytes++)
	MOVLW       1
	ADDWF       readSingleBlock_numOfBytes_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      readSingleBlock_numOfBytes_L0+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       readSingleBlock_numOfBytes_L0+0 
	MOVF        R1, 0 
	MOVWF       readSingleBlock_numOfBytes_L0+1 
;soundrec.c,296 :: 		}
	GOTO        L_readSingleBlock59
L_readSingleBlock60:
;soundrec.c,298 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,299 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,300 :: 		UWR("DONE!");
	MOVLW       ?lstr20_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr20_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,301 :: 		}
L_end_readSingleBlock:
	RETURN      0
; end of _readSingleBlock

_writeMultipleBlock:

;soundrec.c,304 :: 		writeMultipleBlock(void)
;soundrec.c,307 :: 		volatile uint8_t temp = 0;
	CLRF        writeMultipleBlock_temp_L0+0 
;soundrec.c,310 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,311 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,312 :: 		while (spiReadData != 0xff);
L_writeMultipleBlock63:
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_writeMultipleBlock64
	GOTO        L_writeMultipleBlock63
L_writeMultipleBlock64:
;soundrec.c,314 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,316 :: 		UWR("Card ready!")
	MOVLW       ?lstr21_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr21_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,318 :: 		command(25, arg, 0x95);
	MOVLW       25
	MOVWF       FARG_command_command+0 
	MOVF        _arg+0, 0 
	MOVWF       FARG_command_fourbyte_arg+0 
	MOVF        _arg+1, 0 
	MOVWF       FARG_command_fourbyte_arg+1 
	MOVF        _arg+2, 0 
	MOVWF       FARG_command_fourbyte_arg+2 
	MOVF        _arg+3, 0 
	MOVWF       FARG_command_fourbyte_arg+3 
	MOVLW       149
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;soundrec.c,320 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,321 :: 		while(count < 10)
L_writeMultipleBlock65:
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_writeMultipleBlock66
;soundrec.c,323 :: 		if (spiReadData == 0)
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_writeMultipleBlock67
;soundrec.c,325 :: 		break;
	GOTO        L_writeMultipleBlock66
;soundrec.c,326 :: 		}
L_writeMultipleBlock67:
;soundrec.c,327 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,328 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,329 :: 		}
	GOTO        L_writeMultipleBlock65
L_writeMultipleBlock66:
;soundrec.c,330 :: 		if (count >= 10)
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_writeMultipleBlock68
;soundrec.c,332 :: 		UWR("Command rejected!");
	MOVLW       ?lstr22_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr22_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,333 :: 		}
L_writeMultipleBlock68:
;soundrec.c,334 :: 		UWR("Command accepted!");
	MOVLW       ?lstr23_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr23_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,335 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,336 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,337 :: 		spiWrite(0xff); // Dummy clock
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,338 :: 		while (temp < 5) // repeat until Select button pressed
L_writeMultipleBlock69:
	MOVLW       5
	SUBWF       writeMultipleBlock_temp_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_writeMultipleBlock70
;soundrec.c,340 :: 		spiWrite(0b11111100); // Data token for CMD 25
	MOVLW       252
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,341 :: 		for (g = 0; g < 512; g++)
	CLRF        writeMultipleBlock_g_L0+0 
	CLRF        writeMultipleBlock_g_L0+1 
L_writeMultipleBlock71:
	MOVLW       2
	SUBWF       writeMultipleBlock_g_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__writeMultipleBlock171
	MOVLW       0
	SUBWF       writeMultipleBlock_g_L0+0, 0 
L__writeMultipleBlock171:
	BTFSC       STATUS+0, 0 
	GOTO        L_writeMultipleBlock72
;soundrec.c,343 :: 		spiWrite((uint8_t) g);
	MOVF        writeMultipleBlock_g_L0+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,344 :: 		IntToStr(g, text);
	MOVF        writeMultipleBlock_g_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        writeMultipleBlock_g_L0+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       writeMultipleBlock_text_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(writeMultipleBlock_text_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,345 :: 		UWR(text);
	MOVLW       writeMultipleBlock_text_L0+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(writeMultipleBlock_text_L0+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,346 :: 		Delay_ms(2);
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_writeMultipleBlock74:
	DECFSZ      R13, 1, 1
	BRA         L_writeMultipleBlock74
	DECFSZ      R12, 1, 1
	BRA         L_writeMultipleBlock74
	NOP
	NOP
;soundrec.c,341 :: 		for (g = 0; g < 512; g++)
	MOVLW       1
	ADDWF       writeMultipleBlock_g_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      writeMultipleBlock_g_L0+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       writeMultipleBlock_g_L0+0 
	MOVF        R1, 0 
	MOVWF       writeMultipleBlock_g_L0+1 
;soundrec.c,347 :: 		} // write a block of 512 bytes data
	GOTO        L_writeMultipleBlock71
L_writeMultipleBlock72:
;soundrec.c,348 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,349 :: 		spiWrite(0xff); // 2 bytes CRC
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,351 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,352 :: 		while (count < 8)
L_writeMultipleBlock75:
	MOVLW       8
	SUBWF       _count+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_writeMultipleBlock76
;soundrec.c,354 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,355 :: 		if ((spiReadData & 0b00011111) == 0x05)
	MOVLW       31
	ANDWF       _spiReadData+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_writeMultipleBlock77
;soundrec.c,357 :: 		UWR("Data accepted!");
	MOVLW       ?lstr24_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr24_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,358 :: 		break;
	GOTO        L_writeMultipleBlock76
;soundrec.c,359 :: 		}
L_writeMultipleBlock77:
;soundrec.c,360 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,361 :: 		}
	GOTO        L_writeMultipleBlock75
L_writeMultipleBlock76:
;soundrec.c,362 :: 		if (count >= 8)
	MOVLW       8
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_writeMultipleBlock78
;soundrec.c,364 :: 		UWR("Data rejected!");
	MOVLW       ?lstr25_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr25_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,365 :: 		while (1); // Trap the CPU
L_writeMultipleBlock79:
	GOTO        L_writeMultipleBlock79
;soundrec.c,366 :: 		}
L_writeMultipleBlock78:
;soundrec.c,367 :: 		spiReadData = spiRead(); // check if the card is busy
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,368 :: 		while (spiReadData != 0xff)
L_writeMultipleBlock81:
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_writeMultipleBlock82
;soundrec.c,370 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,371 :: 		}
	GOTO        L_writeMultipleBlock81
L_writeMultipleBlock82:
;soundrec.c,372 :: 		temp++;
	MOVF        writeMultipleBlock_temp_L0+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       writeMultipleBlock_temp_L0+0 
;soundrec.c,373 :: 		}
	GOTO        L_writeMultipleBlock69
L_writeMultipleBlock70:
;soundrec.c,376 :: 		spiWrite(0b11111101);
	MOVLW       253
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,377 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,378 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,379 :: 		while (spiReadData != 0xff) // check if the card is busy
L_writeMultipleBlock83:
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_writeMultipleBlock84
;soundrec.c,381 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,382 :: 		}
	GOTO        L_writeMultipleBlock83
L_writeMultipleBlock84:
;soundrec.c,383 :: 		UWR("DONE Writing!")
	MOVLW       ?lstr26_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr26_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,384 :: 		}
L_end_writeMultipleBlock:
	RETURN      0
; end of _writeMultipleBlock

_readMultipleBlock:

;soundrec.c,388 :: 		readMultipleBlock(void)
;soundrec.c,393 :: 		do
L_readMultipleBlock85:
;soundrec.c,395 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,397 :: 		while (spiReadData != 0xff);
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock85
;soundrec.c,399 :: 		command(18, arg, 0x95);
	MOVLW       18
	MOVWF       FARG_command_command+0 
	MOVF        _arg+0, 0 
	MOVWF       FARG_command_fourbyte_arg+0 
	MOVF        _arg+1, 0 
	MOVWF       FARG_command_fourbyte_arg+1 
	MOVF        _arg+2, 0 
	MOVWF       FARG_command_fourbyte_arg+2 
	MOVF        _arg+3, 0 
	MOVWF       FARG_command_fourbyte_arg+3 
	MOVLW       149
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;soundrec.c,400 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,401 :: 		do // verify R1 respond
L_readMultipleBlock88:
;soundrec.c,403 :: 		if (spiReadData == 0)
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock91
;soundrec.c,405 :: 		UWR("Command accepted!");
	MOVLW       ?lstr27_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr27_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,406 :: 		break;
	GOTO        L_readMultipleBlock89
;soundrec.c,407 :: 		}
L_readMultipleBlock91:
;soundrec.c,408 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,409 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,411 :: 		while (count < 10);
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_readMultipleBlock88
L_readMultipleBlock89:
;soundrec.c,412 :: 		if (count >= 10)
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_readMultipleBlock92
;soundrec.c,414 :: 		UWR("Command Rejected!");
	MOVLW       ?lstr28_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr28_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,415 :: 		while (1); // Trap the CPU
L_readMultipleBlock93:
	GOTO        L_readMultipleBlock93
;soundrec.c,416 :: 		}
L_readMultipleBlock92:
;soundrec.c,417 :: 		while (SLCT) // play until SLCT button pressed
L_readMultipleBlock95:
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_readMultipleBlock96
;soundrec.c,420 :: 		do
L_readMultipleBlock97:
;soundrec.c,422 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,424 :: 		while (spiReadData != 0xfe);
	MOVF        _spiReadData+0, 0 
	XORLW       254
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock97
;soundrec.c,426 :: 		for (g = 0; g < 512; g++)
	CLRF        readMultipleBlock_g_L0+0 
	CLRF        readMultipleBlock_g_L0+1 
L_readMultipleBlock100:
	MOVLW       2
	SUBWF       readMultipleBlock_g_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readMultipleBlock173
	MOVLW       0
	SUBWF       readMultipleBlock_g_L0+0, 0 
L__readMultipleBlock173:
	BTFSC       STATUS+0, 0 
	GOTO        L_readMultipleBlock101
;soundrec.c,428 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,429 :: 		IntToStr(spiReadData, text);
	MOVF        _spiReadData+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       readMultipleBlock_text_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(readMultipleBlock_text_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,430 :: 		UWR(text);
	MOVLW       readMultipleBlock_text_L0+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(readMultipleBlock_text_L0+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,431 :: 		Delay_ms(2);
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_readMultipleBlock103:
	DECFSZ      R13, 1, 1
	BRA         L_readMultipleBlock103
	DECFSZ      R12, 1, 1
	BRA         L_readMultipleBlock103
	NOP
	NOP
;soundrec.c,426 :: 		for (g = 0; g < 512; g++)
	MOVLW       1
	ADDWF       readMultipleBlock_g_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      readMultipleBlock_g_L0+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       readMultipleBlock_g_L0+0 
	MOVF        R1, 0 
	MOVWF       readMultipleBlock_g_L0+1 
;soundrec.c,432 :: 		}
	GOTO        L_readMultipleBlock100
L_readMultipleBlock101:
;soundrec.c,434 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,435 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,436 :: 		}
	GOTO        L_readMultipleBlock95
L_readMultipleBlock96:
;soundrec.c,439 :: 		command(12, 0, 0x95);
	MOVLW       12
	MOVWF       FARG_command_command+0 
	CLRF        FARG_command_fourbyte_arg+0 
	CLRF        FARG_command_fourbyte_arg+1 
	CLRF        FARG_command_fourbyte_arg+2 
	CLRF        FARG_command_fourbyte_arg+3 
	MOVLW       149
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;soundrec.c,440 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,441 :: 		do
L_readMultipleBlock104:
;soundrec.c,443 :: 		if (spiReadData == 0)
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock107
;soundrec.c,445 :: 		UWR("Stopped Transfer!");
	MOVLW       ?lstr29_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr29_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,446 :: 		break;
	GOTO        L_readMultipleBlock105
;soundrec.c,447 :: 		}
L_readMultipleBlock107:
;soundrec.c,448 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,449 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,451 :: 		while (count < 10);
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_readMultipleBlock104
L_readMultipleBlock105:
;soundrec.c,453 :: 		do
L_readMultipleBlock108:
;soundrec.c,455 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,457 :: 		while (spiReadData != 0xff);
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock108
;soundrec.c,458 :: 		UWR("Card free!");
	MOVLW       ?lstr30_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr30_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,459 :: 		while (1); // Trap the CPU
L_readMultipleBlock111:
	GOTO        L_readMultipleBlock111
;soundrec.c,460 :: 		}
L_end_readMultipleBlock:
	RETURN      0
; end of _readMultipleBlock

_hamghi:

;soundrec.c,464 :: 		void hamghi(void)
;soundrec.c,468 :: 		for(i=0; i<512; i++)
	CLRF        hamghi_i_L0+0 
	CLRF        hamghi_i_L0+1 
L_hamghi113:
	MOVLW       2
	SUBWF       hamghi_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamghi175
	MOVLW       0
	SUBWF       hamghi_i_L0+0, 0 
L__hamghi175:
	BTFSC       STATUS+0, 0 
	GOTO        L_hamghi114
;soundrec.c,470 :: 		TP0 = 1;
	BSF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;soundrec.c,471 :: 		Delay_us(15);
	MOVLW       24
	MOVWF       R13, 0
L_hamghi116:
	DECFSZ      R13, 1, 1
	BRA         L_hamghi116
	NOP
	NOP
;soundrec.c,472 :: 		TP0 = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;soundrec.c,473 :: 		a[i] =  adcRead();
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
;soundrec.c,468 :: 		for(i=0; i<512; i++)
	INFSNZ      hamghi_i_L0+0, 1 
	INCF        hamghi_i_L0+1, 1 
;soundrec.c,476 :: 		}
	GOTO        L_hamghi113
L_hamghi114:
;soundrec.c,478 :: 		error = MMC_Write_Sector(t, a);
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
;soundrec.c,479 :: 		if (error == 1)
	MOVF        _error+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_hamghi117
;soundrec.c,481 :: 		UWR("Command error!");
	MOVLW       ?lstr31_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr31_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,482 :: 		}
	GOTO        L_hamghi118
L_hamghi117:
;soundrec.c,483 :: 		else if (error == 2)
	MOVF        _error+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_hamghi119
;soundrec.c,485 :: 		UWR("Write error!");
	MOVLW       ?lstr32_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr32_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,486 :: 		}
L_hamghi119:
L_hamghi118:
;soundrec.c,487 :: 		t++;
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
;soundrec.c,488 :: 		}
L_end_hamghi:
	RETURN      0
; end of _hamghi

_hamdoc:

;soundrec.c,491 :: 		void hamdoc()
;soundrec.c,496 :: 		if (Mmc_Read_Sector(t, a))
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
	GOTO        L_hamdoc120
;soundrec.c,498 :: 		UWR("Read error!");
	MOVLW       ?lstr33_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr33_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,499 :: 		}
L_hamdoc120:
;soundrec.c,500 :: 		for(i=0; i< 512; i++)
	CLRF        hamdoc_i_L0+0 
	CLRF        hamdoc_i_L0+1 
L_hamdoc121:
	MOVLW       2
	SUBWF       hamdoc_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamdoc177
	MOVLW       0
	SUBWF       hamdoc_i_L0+0, 0 
L__hamdoc177:
	BTFSC       STATUS+0, 0 
	GOTO        L_hamdoc122
;soundrec.c,502 :: 		DACOUT = a[i];
	MOVLW       hamdoc_a_L0+0
	ADDWF       hamdoc_i_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(hamdoc_a_L0+0)
	ADDWFC      hamdoc_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       LATB+0 
;soundrec.c,504 :: 		Delay_us(25);
	MOVLW       41
	MOVWF       R13, 0
L_hamdoc124:
	DECFSZ      R13, 1, 1
	BRA         L_hamdoc124
	NOP
;soundrec.c,500 :: 		for(i=0; i< 512; i++)
	INFSNZ      hamdoc_i_L0+0, 1 
	INCF        hamdoc_i_L0+1, 1 
;soundrec.c,505 :: 		}
	GOTO        L_hamdoc121
L_hamdoc122:
;soundrec.c,506 :: 		t++;
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
;soundrec.c,507 :: 		}
L_end_hamdoc:
	RETURN      0
; end of _hamdoc

_hamcaidat:

;soundrec.c,509 :: 		unsigned int hamcaidat()
;soundrec.c,511 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,512 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,513 :: 		while (1)
L_hamcaidat125:
;soundrec.c,515 :: 		if(SLCT==0)
	BTFSC       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_hamcaidat127
;soundrec.c,517 :: 		Delay_ms(500);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_hamcaidat128:
	DECFSZ      R13, 1, 1
	BRA         L_hamcaidat128
	DECFSZ      R12, 1, 1
	BRA         L_hamcaidat128
	DECFSZ      R11, 1, 1
	BRA         L_hamcaidat128
	NOP
;soundrec.c,518 :: 		mode++;
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
;soundrec.c,519 :: 		if(mode==3)mode=1;
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamcaidat179
	MOVLW       3
	XORWF       _mode+0, 0 
L__hamcaidat179:
	BTFSS       STATUS+0, 2 
	GOTO        L_hamcaidat129
	MOVLW       1
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
L_hamcaidat129:
;soundrec.c,521 :: 		}
L_hamcaidat127:
;soundrec.c,524 :: 		if (mode == 1) UWR("Record");
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamcaidat180
	MOVLW       1
	XORWF       _mode+0, 0 
L__hamcaidat180:
	BTFSS       STATUS+0, 2 
	GOTO        L_hamcaidat130
	MOVLW       ?lstr34_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr34_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
L_hamcaidat130:
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,525 :: 		if (mode == 2) UWR("Play");
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamcaidat181
	MOVLW       2
	XORWF       _mode+0, 0 
L__hamcaidat181:
	BTFSS       STATUS+0, 2 
	GOTO        L_hamcaidat131
	MOVLW       ?lstr35_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr35_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
L_hamcaidat131:
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,526 :: 		if(OK==0)
	BTFSC       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_hamcaidat132
;soundrec.c,529 :: 		return mode;
	MOVF        _mode+0, 0 
	MOVWF       R0 
	MOVF        _mode+1, 0 
	MOVWF       R1 
	GOTO        L_end_hamcaidat
;soundrec.c,531 :: 		}
L_hamcaidat132:
;soundrec.c,532 :: 		}
	GOTO        L_hamcaidat125
;soundrec.c,533 :: 		}
L_end_hamcaidat:
	RETURN      0
; end of _hamcaidat

_main:

;soundrec.c,535 :: 		void main()
;soundrec.c,542 :: 		ADCON1 |= 0x0e; // AIN0 as analog input
	MOVLW       14
	IORWF       ADCON1+0, 1 
;soundrec.c,543 :: 		ADCON2 |= 0x2d; // 12 Tad and FOSC/16
	MOVLW       45
	IORWF       ADCON2+0, 1 
;soundrec.c,544 :: 		ADFM_bit = 0; // Left justified
	BCF         ADFM_bit+0, BitPos(ADFM_bit+0) 
;soundrec.c,545 :: 		ADON_bit = 1; // Enable ADC module
	BSF         ADON_bit+0, BitPos(ADON_bit+0) 
;soundrec.c,546 :: 		Delay_ms(100);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main133:
	DECFSZ      R13, 1, 1
	BRA         L_main133
	DECFSZ      R12, 1, 1
	BRA         L_main133
	DECFSZ      R11, 1, 1
	BRA         L_main133
	NOP
	NOP
;soundrec.c,549 :: 		TRISD=0xf3;
	MOVLW       243
	MOVWF       TRISD+0 
;soundrec.c,550 :: 		TRISA2_bit=1;
	BSF         TRISA2_bit+0, BitPos(TRISA2_bit+0) 
;soundrec.c,551 :: 		TRISD2_bit=1;
	BSF         TRISD2_bit+0, BitPos(TRISD2_bit+0) 
;soundrec.c,552 :: 		TRISD3_bit=1;
	BSF         TRISD3_bit+0, BitPos(TRISD3_bit+0) 
;soundrec.c,553 :: 		TRISB=0;
	CLRF        TRISB+0 
;soundrec.c,554 :: 		TRISC = 0x00;
	CLRF        TRISC+0 
;soundrec.c,557 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	MOVLW       2
	MOVWF       SPBRGH+0 
	MOVLW       8
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;soundrec.c,558 :: 		mmcInit();
	CALL        _mmcInit+0, 0
;soundrec.c,560 :: 		for ( ; ; )        // Repeats forever
L_main134:
;soundrec.c,563 :: 		while (SLCT != 0)        // Wait until SELECT pressed
L_main137:
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main138
;soundrec.c,565 :: 		}
	GOTO        L_main137
L_main138:
;soundrec.c,570 :: 		UWR("Select a Menu");
	MOVLW       ?lstr36_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr36_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,571 :: 		while (OK)
L_main139:
	BTFSS       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_main140
;soundrec.c,573 :: 		if (!SLCT)
	BTFSC       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main141
;soundrec.c,575 :: 		Delay_ms(300);
	MOVLW       8
	MOVWF       R11, 0
	MOVLW       157
	MOVWF       R12, 0
	MOVLW       5
	MOVWF       R13, 0
L_main142:
	DECFSZ      R13, 1, 1
	BRA         L_main142
	DECFSZ      R12, 1, 1
	BRA         L_main142
	DECFSZ      R11, 1, 1
	BRA         L_main142
	NOP
	NOP
;soundrec.c,576 :: 		mode++;
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
;soundrec.c,577 :: 		if (mode == 3)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main183
	MOVLW       3
	XORWF       _mode+0, 0 
L__main183:
	BTFSS       STATUS+0, 2 
	GOTO        L_main143
;soundrec.c,579 :: 		mode = 1;
	MOVLW       1
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
;soundrec.c,580 :: 		}
L_main143:
;soundrec.c,581 :: 		}
L_main141:
;soundrec.c,583 :: 		if ((mode == 1) & (lastMode != mode))
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main184
	MOVLW       1
	XORWF       _mode+0, 0 
L__main184:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main185
	MOVF        _mode+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main185:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main144
;soundrec.c,586 :: 		UWR("Record\n");
	MOVLW       ?lstr37_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr37_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,587 :: 		}
	GOTO        L_main145
L_main144:
;soundrec.c,588 :: 		else if ((mode == 2) & (lastMode != mode))
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main186
	MOVLW       2
	XORWF       _mode+0, 0 
L__main186:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main187
	MOVF        _mode+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main187:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main146
;soundrec.c,591 :: 		UWR("Play\n");
	MOVLW       ?lstr38_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr38_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,592 :: 		}
L_main146:
L_main145:
;soundrec.c,597 :: 		lastMode = mode;
	MOVF        _mode+0, 0 
	MOVWF       main_lastMode_L0+0 
;soundrec.c,598 :: 		}
	GOTO        L_main139
L_main140:
;soundrec.c,602 :: 		if (mode == 1)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main188
	MOVLW       1
	XORWF       _mode+0, 0 
L__main188:
	BTFSS       STATUS+0, 2 
	GOTO        L_main147
;soundrec.c,604 :: 		t = 0;
	CLRF        _t+0 
	CLRF        _t+1 
;soundrec.c,605 :: 		UWR("Writing");
	MOVLW       ?lstr39_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr39_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,606 :: 		PORTB = 0x00;
	CLRF        PORTB+0 
;soundrec.c,608 :: 		writeMultipleBlock();
	CALL        _writeMultipleBlock+0, 0
;soundrec.c,609 :: 		}
L_main147:
;soundrec.c,611 :: 		if (mode == 2)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main189
	MOVLW       2
	XORWF       _mode+0, 0 
L__main189:
	BTFSS       STATUS+0, 2 
	GOTO        L_main148
;soundrec.c,615 :: 		UWR("Reading");
	MOVLW       ?lstr40_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr40_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,616 :: 		t = 0;
	CLRF        _t+0 
	CLRF        _t+1 
;soundrec.c,618 :: 		readMultipleBlock();
	CALL        _readMultipleBlock+0, 0
;soundrec.c,619 :: 		while (SLCT && OK)
L_main149:
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main150
	BTFSS       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_main150
L__main156:
;soundrec.c,621 :: 		}
	GOTO        L_main149
L_main150:
;soundrec.c,622 :: 		}
L_main148:
;soundrec.c,624 :: 		}
	GOTO        L_main134
;soundrec.c,625 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
