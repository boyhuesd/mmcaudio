
_codeToRam:

;soundrec.c,75 :: 		char* codeToRam(const char* ctxt){
;soundrec.c,78 :: 		for(i =0; txt[i] = ctxt[i]; i++);
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
;soundrec.c,80 :: 		return txt;
	MOVLW       codeToRam_txt_L0+0
	MOVWF       R0 
	MOVLW       hi_addr(codeToRam_txt_L0+0)
	MOVWF       R1 
;soundrec.c,81 :: 		}
L_end_codeToRam:
	RETURN      0
; end of _codeToRam

_adcRead:

;soundrec.c,87 :: 		adcRead(void)
;soundrec.c,90 :: 		GO_bit = 1; // Begin conversion
	BSF         GO_bit+0, BitPos(GO_bit+0) 
;soundrec.c,91 :: 		while (!GO); // Wait for conversion completed
L_adcRead4:
;soundrec.c,93 :: 		return ADRESH;
	MOVF        ADRESH+0, 0 
	MOVWF       R0 
;soundrec.c,94 :: 		}
L_end_adcRead:
	RETURN      0
; end of _adcRead

_caidatMMC:

;soundrec.c,97 :: 		void caidatMMC()
;soundrec.c,99 :: 		UWR("Detecting MMC");
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
;soundrec.c,100 :: 		Delay_ms(1000);
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
;soundrec.c,102 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,104 :: 		while (MMC_Init() != 0)
L_caidatMMC6:
	CALL        _Mmc_Init+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_caidatMMC7
;soundrec.c,106 :: 		}
	GOTO        L_caidatMMC6
L_caidatMMC7:
;soundrec.c,109 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	CLRF        FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,110 :: 		UWR("MMC Detected!");
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
;soundrec.c,111 :: 		Delay_ms (1000);
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
;soundrec.c,112 :: 		}
L_end_caidatMMC:
	RETURN      0
; end of _caidatMMC

_command:

;soundrec.c,121 :: 		command(char command, uint32_t fourbyte_arg, char CRCbits)
;soundrec.c,123 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,124 :: 		spiWrite(0b01000000 | command);
	MOVLW       64
	IORWF       FARG_command_command+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,125 :: 		spiWrite((uint8_t) (fourbyte_arg >> 24));
	MOVF        FARG_command_fourbyte_arg+3, 0 
	MOVWF       R0 
	CLRF        R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,126 :: 		spiWrite((uint8_t) (fourbyte_arg >> 16));
	MOVF        FARG_command_fourbyte_arg+2, 0 
	MOVWF       R0 
	MOVF        FARG_command_fourbyte_arg+3, 0 
	MOVWF       R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,127 :: 		spiWrite((uint8_t) (fourbyte_arg >> 8));
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
;soundrec.c,128 :: 		spiWrite((uint8_t) (fourbyte_arg));
	MOVF        FARG_command_fourbyte_arg+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,129 :: 		spiWrite(CRCbits);
	MOVF        FARG_command_CRCbits+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,130 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,131 :: 		}
L_end_command:
	RETURN      0
; end of _command

_mmcInit:

;soundrec.c,134 :: 		mmcInit(void)
;soundrec.c,138 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,139 :: 		Delay_ms(2);
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
;soundrec.c,140 :: 		Mmc_Chip_Select = 1;
	BSF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;soundrec.c,141 :: 		UWR("CS is HIGH!");
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
;soundrec.c,142 :: 		for (u = 0; u < 10; u++)
	CLRF        mmcInit_u_L0+0 
L_mmcInit10:
	MOVLW       10
	SUBWF       mmcInit_u_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_mmcInit11
;soundrec.c,144 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,142 :: 		for (u = 0; u < 10; u++)
	INCF        mmcInit_u_L0+0, 1 
;soundrec.c,145 :: 		}
	GOTO        L_mmcInit10
L_mmcInit11:
;soundrec.c,146 :: 		UWR("Dummy clock sent!");
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
;soundrec.c,147 :: 		Mmc_Chip_Select = 0;
	BCF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;soundrec.c,148 :: 		UWR("CS is LOW!\n");
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
;soundrec.c,149 :: 		Delay_ms(1);
	MOVLW       7
	MOVWF       R12, 0
	MOVLW       125
	MOVWF       R13, 0
L_mmcInit13:
	DECFSZ      R13, 1, 1
	BRA         L_mmcInit13
	DECFSZ      R12, 1, 1
	BRA         L_mmcInit13
;soundrec.c,150 :: 		command(0, 0, 0x95);
	CLRF        FARG_command_command+0 
	CLRF        FARG_command_fourbyte_arg+0 
	CLRF        FARG_command_fourbyte_arg+1 
	CLRF        FARG_command_fourbyte_arg+2 
	CLRF        FARG_command_fourbyte_arg+3 
	MOVLW       149
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;soundrec.c,151 :: 		UWR("CMD0 sent!");
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
;soundrec.c,152 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,153 :: 		while ((spiReadData != 1) && (count < 10))
L_mmcInit14:
	MOVF        _spiReadData+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_mmcInit15
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_mmcInit15
L__mmcInit117:
;soundrec.c,155 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,156 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,157 :: 		}
	GOTO        L_mmcInit14
L_mmcInit15:
;soundrec.c,158 :: 		if (count >= 10)
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_mmcInit18
;soundrec.c,160 :: 		UWR("CARD ERROR - CMD0");
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
;soundrec.c,161 :: 		while (1); // Trap the CPU
L_mmcInit19:
	GOTO        L_mmcInit19
;soundrec.c,162 :: 		}
L_mmcInit18:
;soundrec.c,163 :: 		command(1, 0, 0xff);
	MOVLW       1
	MOVWF       FARG_command_command+0 
	CLRF        FARG_command_fourbyte_arg+0 
	CLRF        FARG_command_fourbyte_arg+1 
	CLRF        FARG_command_fourbyte_arg+2 
	CLRF        FARG_command_fourbyte_arg+3 
	MOVLW       255
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;soundrec.c,164 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,165 :: 		while ((spiReadData != 0) && (count < 1000))
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
	GOTO        L__mmcInit124
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit124:
	BTFSC       STATUS+0, 0 
	GOTO        L_mmcInit22
L__mmcInit116:
;soundrec.c,167 :: 		command(1, 0, 0xff);
	MOVLW       1
	MOVWF       FARG_command_command+0 
	CLRF        FARG_command_fourbyte_arg+0 
	CLRF        FARG_command_fourbyte_arg+1 
	CLRF        FARG_command_fourbyte_arg+2 
	CLRF        FARG_command_fourbyte_arg+3 
	MOVLW       255
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;soundrec.c,168 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,169 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,170 :: 		}
	GOTO        L_mmcInit21
L_mmcInit22:
;soundrec.c,171 :: 		if (count >= 1000)
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mmcInit125
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit125:
	BTFSS       STATUS+0, 0 
	GOTO        L_mmcInit25
;soundrec.c,173 :: 		UWR("Card ERROR - CMD1");
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
;soundrec.c,174 :: 		while (1); // Trap the CPU
L_mmcInit26:
	GOTO        L_mmcInit26
;soundrec.c,175 :: 		}
L_mmcInit25:
;soundrec.c,176 :: 		command(16, 512, 0xff);
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
;soundrec.c,177 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,178 :: 		while ((spiReadData != 0) && (count < 1000))
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
	GOTO        L__mmcInit126
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit126:
	BTFSC       STATUS+0, 0 
	GOTO        L_mmcInit29
L__mmcInit115:
;soundrec.c,180 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,181 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,182 :: 		}
	GOTO        L_mmcInit28
L_mmcInit29:
;soundrec.c,183 :: 		if (count >= 1000)
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mmcInit127
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit127:
	BTFSS       STATUS+0, 0 
	GOTO        L_mmcInit32
;soundrec.c,185 :: 		UWR("Card error - CMD16");
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
;soundrec.c,186 :: 		while (1); // Trap the CPU
L_mmcInit33:
	GOTO        L_mmcInit33
;soundrec.c,187 :: 		}
L_mmcInit32:
;soundrec.c,188 :: 		UWR("MMC Detected!");
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
;soundrec.c,191 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,192 :: 		Delay_ms(20);
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
;soundrec.c,194 :: 		}
L_end_mmcInit:
	RETURN      0
; end of _mmcInit

_writeSingleBlock:

;soundrec.c,197 :: 		writeSingleBlock(void)
;soundrec.c,199 :: 		uint16_t g = 0;
	CLRF        writeSingleBlock_g_L0+0 
	CLRF        writeSingleBlock_g_L0+1 
;soundrec.c,200 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,202 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,203 :: 		while (spiReadData != 0xff)
L_writeSingleBlock36:
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_writeSingleBlock37
;soundrec.c,205 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,206 :: 		UWR("Card busy!");
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
;soundrec.c,207 :: 		}
	GOTO        L_writeSingleBlock36
L_writeSingleBlock37:
;soundrec.c,209 :: 		command(24, arg, 0x95);
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
;soundrec.c,211 :: 		while (spiReadData != 0)
L_writeSingleBlock38:
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_writeSingleBlock39
;soundrec.c,213 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,214 :: 		}
	GOTO        L_writeSingleBlock38
L_writeSingleBlock39:
;soundrec.c,215 :: 		UWR("Command accepted!");
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
;soundrec.c,216 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,217 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,218 :: 		spiWrite(0b11111110); // Data token for CMD 24
	MOVLW       254
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,219 :: 		for (g = 0; g < 512; g++)
	CLRF        writeSingleBlock_g_L0+0 
	CLRF        writeSingleBlock_g_L0+1 
L_writeSingleBlock40:
	MOVLW       2
	SUBWF       writeSingleBlock_g_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__writeSingleBlock129
	MOVLW       0
	SUBWF       writeSingleBlock_g_L0+0, 0 
L__writeSingleBlock129:
	BTFSC       STATUS+0, 0 
	GOTO        L_writeSingleBlock41
;soundrec.c,221 :: 		spiWrite(0x50);
	MOVLW       80
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,219 :: 		for (g = 0; g < 512; g++)
	INFSNZ      writeSingleBlock_g_L0+0, 1 
	INCF        writeSingleBlock_g_L0+1, 1 
;soundrec.c,222 :: 		}
	GOTO        L_writeSingleBlock40
L_writeSingleBlock41:
;soundrec.c,223 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,224 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,225 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,227 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,228 :: 		while (count < 10)
L_writeSingleBlock43:
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_writeSingleBlock44
;soundrec.c,230 :: 		if ((spiReadData & 0b00011111) == 0x05)
	MOVLW       31
	ANDWF       _spiReadData+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_writeSingleBlock45
;soundrec.c,232 :: 		UWR("Data accepted!");
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
;soundrec.c,233 :: 		break;
	GOTO        L_writeSingleBlock44
;soundrec.c,234 :: 		}
L_writeSingleBlock45:
;soundrec.c,235 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,236 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,237 :: 		}
	GOTO        L_writeSingleBlock43
L_writeSingleBlock44:
;soundrec.c,238 :: 		if (count >= 10)
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_writeSingleBlock46
;soundrec.c,240 :: 		UWR("Data rejected!");
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
;soundrec.c,241 :: 		}
L_writeSingleBlock46:
;soundrec.c,242 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,243 :: 		while (spiReadData != 0xff)
L_writeSingleBlock47:
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_writeSingleBlock48
;soundrec.c,245 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,246 :: 		}
	GOTO        L_writeSingleBlock47
L_writeSingleBlock48:
;soundrec.c,247 :: 		UWR("Card is idle");
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
;soundrec.c,248 :: 		}
L_end_writeSingleBlock:
	RETURN      0
; end of _writeSingleBlock

_readSingleBlock:

;soundrec.c,250 :: 		readSingleBlock(void)
;soundrec.c,254 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,255 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,256 :: 		while (spiReadData != 0xff)
L_readSingleBlock49:
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_readSingleBlock50
;soundrec.c,258 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,259 :: 		UWR("Card busy!");
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
;soundrec.c,260 :: 		}
	GOTO        L_readSingleBlock49
L_readSingleBlock50:
;soundrec.c,262 :: 		command(17, arg, 0x95); // read 512 bytes from byte address 0
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
;soundrec.c,264 :: 		while (spiReadData != 0)
L_readSingleBlock51:
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_readSingleBlock52
;soundrec.c,266 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,267 :: 		UWR("Busy!");
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
;soundrec.c,268 :: 		}
	GOTO        L_readSingleBlock51
L_readSingleBlock52:
;soundrec.c,269 :: 		UWR("CMD accepted!");
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
;soundrec.c,271 :: 		while (spiReadData != 0xfe)
L_readSingleBlock53:
	MOVF        _spiReadData+0, 0 
	XORLW       254
	BTFSC       STATUS+0, 2 
	GOTO        L_readSingleBlock54
;soundrec.c,273 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,274 :: 		}
	GOTO        L_readSingleBlock53
L_readSingleBlock54:
;soundrec.c,275 :: 		UWR("Token received!");
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
;soundrec.c,277 :: 		for (numOfBytes = 0; numOfBytes < 512; numOfBytes++)
	CLRF        readSingleBlock_numOfBytes_L0+0 
	CLRF        readSingleBlock_numOfBytes_L0+1 
L_readSingleBlock55:
	MOVLW       2
	SUBWF       readSingleBlock_numOfBytes_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readSingleBlock131
	MOVLW       0
	SUBWF       readSingleBlock_numOfBytes_L0+0, 0 
L__readSingleBlock131:
	BTFSC       STATUS+0, 0 
	GOTO        L_readSingleBlock56
;soundrec.c,279 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,280 :: 		IntToStr(spiReadData, strData);
	MOVF        _spiReadData+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       readSingleBlock_strData_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(readSingleBlock_strData_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,281 :: 		UWR(strData);
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
;soundrec.c,282 :: 		DACOUT = spiReadData;
	MOVF        _spiReadData+0, 0 
	MOVWF       LATB+0 
;soundrec.c,283 :: 		Delay_ms(2);
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_readSingleBlock58:
	DECFSZ      R13, 1, 1
	BRA         L_readSingleBlock58
	DECFSZ      R12, 1, 1
	BRA         L_readSingleBlock58
	NOP
	NOP
;soundrec.c,277 :: 		for (numOfBytes = 0; numOfBytes < 512; numOfBytes++)
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
;soundrec.c,284 :: 		}
	GOTO        L_readSingleBlock55
L_readSingleBlock56:
;soundrec.c,286 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,287 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,288 :: 		UWR("DONE!");
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
;soundrec.c,289 :: 		}
L_end_readSingleBlock:
	RETURN      0
; end of _readSingleBlock

_writeMultipleBlock:

;soundrec.c,292 :: 		writeMultipleBlock(void)
;soundrec.c,295 :: 		volatile uint8_t temp = 0;
	CLRF        writeMultipleBlock_temp_L0+0 
;soundrec.c,298 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,299 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,300 :: 		while (spiReadData != 0xff);
L_writeMultipleBlock59:
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_writeMultipleBlock60
	GOTO        L_writeMultipleBlock59
L_writeMultipleBlock60:
;soundrec.c,302 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,304 :: 		UWR("Card ready!")
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
;soundrec.c,306 :: 		command(25, arg, 0x95);
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
;soundrec.c,308 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,309 :: 		while(count < 8)
L_writeMultipleBlock61:
	MOVLW       8
	SUBWF       _count+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_writeMultipleBlock62
;soundrec.c,311 :: 		if (spiReadData == 0)
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_writeMultipleBlock63
;soundrec.c,313 :: 		break;
	GOTO        L_writeMultipleBlock62
;soundrec.c,314 :: 		}
L_writeMultipleBlock63:
;soundrec.c,315 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,316 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,317 :: 		}
	GOTO        L_writeMultipleBlock61
L_writeMultipleBlock62:
;soundrec.c,318 :: 		if (count >= 8)
	MOVLW       8
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_writeMultipleBlock64
;soundrec.c,320 :: 		UWR("Command rejected!");
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
;soundrec.c,321 :: 		}
L_writeMultipleBlock64:
;soundrec.c,322 :: 		UWR("Command accepted!");
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
;soundrec.c,323 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,324 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,325 :: 		spiWrite(0xff); // Dummy clock
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,326 :: 		while (temp < 5) // repeat until Select button pressed
	MOVLW       5
	SUBWF       writeMultipleBlock_temp_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_writeMultipleBlock66
;soundrec.c,328 :: 		spiWrite(0b11111100); // Data token for CMD 25
	MOVLW       252
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,355 :: 		g = 0;
	CLRF        writeMultipleBlock_g_L0+0 
	CLRF        writeMultipleBlock_g_L0+1 
;soundrec.c,356 :: 		while ((spiReadData & 0b00011111) != 0x05)
L_writeMultipleBlock67:
	MOVLW       31
	ANDWF       _spiReadData+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L_writeMultipleBlock68
;soundrec.c,358 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,359 :: 		g++;
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
;soundrec.c,360 :: 		}
	GOTO        L_writeMultipleBlock67
L_writeMultipleBlock68:
;soundrec.c,361 :: 		IntToStr(g, text);
	MOVF        writeMultipleBlock_g_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        writeMultipleBlock_g_L0+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       writeMultipleBlock_text_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(writeMultipleBlock_text_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,362 :: 		UWR(text);
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
;soundrec.c,363 :: 		while (1); // Trap the CPU
L_writeMultipleBlock69:
	GOTO        L_writeMultipleBlock69
;soundrec.c,370 :: 		}
L_writeMultipleBlock66:
;soundrec.c,373 :: 		spiWrite(0b11111101);
	MOVLW       253
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,374 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,375 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,376 :: 		while (spiReadData != 0xff) // check if the card is busy
L_writeMultipleBlock73:
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_writeMultipleBlock74
;soundrec.c,378 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,379 :: 		}
	GOTO        L_writeMultipleBlock73
L_writeMultipleBlock74:
;soundrec.c,380 :: 		UWR("DONE Writing!")
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
;soundrec.c,381 :: 		}
L_end_writeMultipleBlock:
	RETURN      0
; end of _writeMultipleBlock

_hamghi:

;soundrec.c,385 :: 		void hamghi(void)
;soundrec.c,389 :: 		for(i=0; i<512; i++)
	CLRF        hamghi_i_L0+0 
	CLRF        hamghi_i_L0+1 
L_hamghi75:
	MOVLW       2
	SUBWF       hamghi_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamghi134
	MOVLW       0
	SUBWF       hamghi_i_L0+0, 0 
L__hamghi134:
	BTFSC       STATUS+0, 0 
	GOTO        L_hamghi76
;soundrec.c,391 :: 		TP0 = 1;
	BSF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;soundrec.c,392 :: 		Delay_us(15);
	MOVLW       24
	MOVWF       R13, 0
L_hamghi78:
	DECFSZ      R13, 1, 1
	BRA         L_hamghi78
	NOP
	NOP
;soundrec.c,393 :: 		TP0 = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;soundrec.c,394 :: 		a[i] =  adcRead();
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
;soundrec.c,389 :: 		for(i=0; i<512; i++)
	INFSNZ      hamghi_i_L0+0, 1 
	INCF        hamghi_i_L0+1, 1 
;soundrec.c,397 :: 		}
	GOTO        L_hamghi75
L_hamghi76:
;soundrec.c,399 :: 		error = MMC_Write_Sector(t, a);
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
;soundrec.c,400 :: 		if (error == 1)
	MOVF        _error+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_hamghi79
;soundrec.c,402 :: 		UWR("Command error!");
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
;soundrec.c,403 :: 		}
	GOTO        L_hamghi80
L_hamghi79:
;soundrec.c,404 :: 		else if (error == 2)
	MOVF        _error+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_hamghi81
;soundrec.c,406 :: 		UWR("Write error!");
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
;soundrec.c,407 :: 		}
L_hamghi81:
L_hamghi80:
;soundrec.c,408 :: 		t++;
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
;soundrec.c,409 :: 		}
L_end_hamghi:
	RETURN      0
; end of _hamghi

_hamdoc:

;soundrec.c,412 :: 		void hamdoc()
;soundrec.c,417 :: 		if (Mmc_Read_Sector(t, a))
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
	GOTO        L_hamdoc82
;soundrec.c,419 :: 		UWR("Read error!");
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
;soundrec.c,420 :: 		}
L_hamdoc82:
;soundrec.c,421 :: 		for(i=0; i< 512; i++)
	CLRF        hamdoc_i_L0+0 
	CLRF        hamdoc_i_L0+1 
L_hamdoc83:
	MOVLW       2
	SUBWF       hamdoc_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamdoc136
	MOVLW       0
	SUBWF       hamdoc_i_L0+0, 0 
L__hamdoc136:
	BTFSC       STATUS+0, 0 
	GOTO        L_hamdoc84
;soundrec.c,423 :: 		DACOUT = a[i];
	MOVLW       hamdoc_a_L0+0
	ADDWF       hamdoc_i_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(hamdoc_a_L0+0)
	ADDWFC      hamdoc_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       LATB+0 
;soundrec.c,425 :: 		Delay_us(25);
	MOVLW       41
	MOVWF       R13, 0
L_hamdoc86:
	DECFSZ      R13, 1, 1
	BRA         L_hamdoc86
	NOP
;soundrec.c,421 :: 		for(i=0; i< 512; i++)
	INFSNZ      hamdoc_i_L0+0, 1 
	INCF        hamdoc_i_L0+1, 1 
;soundrec.c,426 :: 		}
	GOTO        L_hamdoc83
L_hamdoc84:
;soundrec.c,427 :: 		t++;
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
;soundrec.c,428 :: 		}
L_end_hamdoc:
	RETURN      0
; end of _hamdoc

_hamcaidat:

;soundrec.c,430 :: 		unsigned int hamcaidat()
;soundrec.c,432 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,433 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,434 :: 		while (1)
L_hamcaidat87:
;soundrec.c,436 :: 		if(SLCT==0)
	BTFSC       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_hamcaidat89
;soundrec.c,438 :: 		Delay_ms(500);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_hamcaidat90:
	DECFSZ      R13, 1, 1
	BRA         L_hamcaidat90
	DECFSZ      R12, 1, 1
	BRA         L_hamcaidat90
	DECFSZ      R11, 1, 1
	BRA         L_hamcaidat90
	NOP
;soundrec.c,439 :: 		mode++;
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
;soundrec.c,440 :: 		if(mode==3)mode=1;
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamcaidat138
	MOVLW       3
	XORWF       _mode+0, 0 
L__hamcaidat138:
	BTFSS       STATUS+0, 2 
	GOTO        L_hamcaidat91
	MOVLW       1
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
L_hamcaidat91:
;soundrec.c,442 :: 		}
L_hamcaidat89:
;soundrec.c,445 :: 		if (mode == 1) UWR("Record");
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamcaidat139
	MOVLW       1
	XORWF       _mode+0, 0 
L__hamcaidat139:
	BTFSS       STATUS+0, 2 
	GOTO        L_hamcaidat92
	MOVLW       ?lstr28_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr28_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
L_hamcaidat92:
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,446 :: 		if (mode == 2) UWR("Play");
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamcaidat140
	MOVLW       2
	XORWF       _mode+0, 0 
L__hamcaidat140:
	BTFSS       STATUS+0, 2 
	GOTO        L_hamcaidat93
	MOVLW       ?lstr29_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr29_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
L_hamcaidat93:
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,447 :: 		if(OK==0)
	BTFSC       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_hamcaidat94
;soundrec.c,450 :: 		return mode;
	MOVF        _mode+0, 0 
	MOVWF       R0 
	MOVF        _mode+1, 0 
	MOVWF       R1 
	GOTO        L_end_hamcaidat
;soundrec.c,452 :: 		}
L_hamcaidat94:
;soundrec.c,453 :: 		}
	GOTO        L_hamcaidat87
;soundrec.c,454 :: 		}
L_end_hamcaidat:
	RETURN      0
; end of _hamcaidat

_main:

;soundrec.c,456 :: 		void main()
;soundrec.c,463 :: 		ADCON1 |= 0x0e; // AIN0 as analog input
	MOVLW       14
	IORWF       ADCON1+0, 1 
;soundrec.c,464 :: 		ADCON2 |= 0x2d; // 12 Tad and FOSC/16
	MOVLW       45
	IORWF       ADCON2+0, 1 
;soundrec.c,465 :: 		ADFM_bit = 0; // Left justified
	BCF         ADFM_bit+0, BitPos(ADFM_bit+0) 
;soundrec.c,466 :: 		ADON_bit = 1; // Enable ADC module
	BSF         ADON_bit+0, BitPos(ADON_bit+0) 
;soundrec.c,467 :: 		Delay_ms(100);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main95:
	DECFSZ      R13, 1, 1
	BRA         L_main95
	DECFSZ      R12, 1, 1
	BRA         L_main95
	DECFSZ      R11, 1, 1
	BRA         L_main95
	NOP
	NOP
;soundrec.c,470 :: 		TRISD=0xf3;
	MOVLW       243
	MOVWF       TRISD+0 
;soundrec.c,471 :: 		TRISA2_bit=1;
	BSF         TRISA2_bit+0, BitPos(TRISA2_bit+0) 
;soundrec.c,472 :: 		TRISD2_bit=1;
	BSF         TRISD2_bit+0, BitPos(TRISD2_bit+0) 
;soundrec.c,473 :: 		TRISD3_bit=1;
	BSF         TRISD3_bit+0, BitPos(TRISD3_bit+0) 
;soundrec.c,474 :: 		TRISB=0;
	CLRF        TRISB+0 
;soundrec.c,475 :: 		TRISC = 0x00;
	CLRF        TRISC+0 
;soundrec.c,478 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	MOVLW       2
	MOVWF       SPBRGH+0 
	MOVLW       8
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;soundrec.c,479 :: 		mmcInit();
	CALL        _mmcInit+0, 0
;soundrec.c,481 :: 		for ( ; ; )        // Repeats forever
L_main96:
;soundrec.c,484 :: 		while (SLCT != 0)        // Wait until SELECT pressed
L_main99:
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main100
;soundrec.c,486 :: 		}
	GOTO        L_main99
L_main100:
;soundrec.c,491 :: 		UWR("Select a Menu");
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
;soundrec.c,492 :: 		while (OK)
L_main101:
	BTFSS       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_main102
;soundrec.c,494 :: 		if (!SLCT)
	BTFSC       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main103
;soundrec.c,496 :: 		Delay_ms(300);
	MOVLW       8
	MOVWF       R11, 0
	MOVLW       157
	MOVWF       R12, 0
	MOVLW       5
	MOVWF       R13, 0
L_main104:
	DECFSZ      R13, 1, 1
	BRA         L_main104
	DECFSZ      R12, 1, 1
	BRA         L_main104
	DECFSZ      R11, 1, 1
	BRA         L_main104
	NOP
	NOP
;soundrec.c,497 :: 		mode++;
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
;soundrec.c,498 :: 		if (mode == 3)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main142
	MOVLW       3
	XORWF       _mode+0, 0 
L__main142:
	BTFSS       STATUS+0, 2 
	GOTO        L_main105
;soundrec.c,500 :: 		mode = 1;
	MOVLW       1
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
;soundrec.c,501 :: 		}
L_main105:
;soundrec.c,502 :: 		}
L_main103:
;soundrec.c,504 :: 		if ((mode == 1) & (lastMode != mode))
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main143
	MOVLW       1
	XORWF       _mode+0, 0 
L__main143:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main144
	MOVF        _mode+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main144:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main106
;soundrec.c,507 :: 		UWR("Record\n");
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
;soundrec.c,508 :: 		}
	GOTO        L_main107
L_main106:
;soundrec.c,509 :: 		else if ((mode == 2) & (lastMode != mode))
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main145
	MOVLW       2
	XORWF       _mode+0, 0 
L__main145:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main146
	MOVF        _mode+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main146:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main108
;soundrec.c,512 :: 		UWR("Play\n");
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
;soundrec.c,513 :: 		}
L_main108:
L_main107:
;soundrec.c,518 :: 		lastMode = mode;
	MOVF        _mode+0, 0 
	MOVWF       main_lastMode_L0+0 
;soundrec.c,519 :: 		}
	GOTO        L_main101
L_main102:
;soundrec.c,523 :: 		if (mode == 1)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main147
	MOVLW       1
	XORWF       _mode+0, 0 
L__main147:
	BTFSS       STATUS+0, 2 
	GOTO        L_main109
;soundrec.c,525 :: 		t = 0;
	CLRF        _t+0 
	CLRF        _t+1 
;soundrec.c,526 :: 		UWR("Writing");
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
;soundrec.c,527 :: 		PORTB = 0x00;
	CLRF        PORTB+0 
;soundrec.c,529 :: 		writeMultipleBlock();
	CALL        _writeMultipleBlock+0, 0
;soundrec.c,530 :: 		}
L_main109:
;soundrec.c,532 :: 		if (mode == 2)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main148
	MOVLW       2
	XORWF       _mode+0, 0 
L__main148:
	BTFSS       STATUS+0, 2 
	GOTO        L_main110
;soundrec.c,536 :: 		UWR("Reading");
	MOVLW       ?lstr34_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr34_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,537 :: 		t = 0;
	CLRF        _t+0 
	CLRF        _t+1 
;soundrec.c,538 :: 		readSingleBlock();
	CALL        _readSingleBlock+0, 0
;soundrec.c,539 :: 		while (SLCT && OK)
L_main111:
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main112
	BTFSS       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_main112
L__main118:
;soundrec.c,541 :: 		}
	GOTO        L_main111
L_main112:
;soundrec.c,542 :: 		}
L_main110:
;soundrec.c,544 :: 		}
	GOTO        L_main96
;soundrec.c,545 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
