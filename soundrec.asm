
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
;soundrec.c,93 :: 		while (GO); // Wait for conversion completed
L_adcRead3:
	GOTO        L_adcRead3
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
L__mmcInit161:
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
	GOTO        L__mmcInit168
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit168:
	BTFSC       STATUS+0, 0 
	GOTO        L_mmcInit22
L__mmcInit160:
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
	GOTO        L__mmcInit169
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit169:
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
	GOTO        L__mmcInit170
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit170:
	BTFSC       STATUS+0, 0 
	GOTO        L_mmcInit29
L__mmcInit159:
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
	GOTO        L__mmcInit171
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit171:
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
;soundrec.c,193 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
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
	GOTO        L__writeSingleBlock173
	MOVLW       0
	SUBWF       writeSingleBlock_g_L0+0, 0 
L__writeSingleBlock173:
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
	GOTO        L__readSingleBlock175
	MOVLW       0
	SUBWF       readSingleBlock_numOfBytes_L0+0, 0 
L__readSingleBlock175:
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

_sendCMD:

;soundrec.c,305 :: 		sendCMD(uint8_t cmd, uint32_t arg)
;soundrec.c,307 :: 		uint8_t retryTimes = 0;
	CLRF        sendCMD_retryTimes_L0+0 
;soundrec.c,310 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,311 :: 		do
L_sendCMD63:
;soundrec.c,313 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,315 :: 		while (spiReadData != 0xff);
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_sendCMD63
;soundrec.c,316 :: 		UWR("Card free!");
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
;soundrec.c,319 :: 		spiWrite(0b01000000 | cmd);
	MOVLW       64
	IORWF       FARG_sendCMD_cmd+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,320 :: 		spiWrite((uint8_t) (arg >> 24));
	MOVF        FARG_sendCMD_arg+3, 0 
	MOVWF       R0 
	CLRF        R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,321 :: 		spiWrite((uint8_t) (arg >> 16));
	MOVF        FARG_sendCMD_arg+2, 0 
	MOVWF       R0 
	MOVF        FARG_sendCMD_arg+3, 0 
	MOVWF       R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,322 :: 		spiWrite((uint8_t) (arg >> 8));
	MOVF        FARG_sendCMD_arg+1, 0 
	MOVWF       R0 
	MOVF        FARG_sendCMD_arg+2, 0 
	MOVWF       R1 
	MOVF        FARG_sendCMD_arg+3, 0 
	MOVWF       R2 
	CLRF        R3 
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,323 :: 		spiWrite((uint8_t) arg);
	MOVF        FARG_sendCMD_arg+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,324 :: 		spiWrite(0x95); // default CRC for SPI protocol
	MOVLW       149
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,325 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,327 :: 		while (retryTimes < 10)
L_sendCMD66:
	MOVLW       10
	SUBWF       sendCMD_retryTimes_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_sendCMD67
;soundrec.c,329 :: 		if (spiReadData == 0)
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_sendCMD68
;soundrec.c,331 :: 		break;
	GOTO        L_sendCMD67
;soundrec.c,332 :: 		}
L_sendCMD68:
;soundrec.c,333 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,334 :: 		retryTimes++;
	INCF        sendCMD_retryTimes_L0+0, 1 
;soundrec.c,335 :: 		}
	GOTO        L_sendCMD66
L_sendCMD67:
;soundrec.c,337 :: 		if (retryTimes >= 10)
	MOVLW       10
	SUBWF       sendCMD_retryTimes_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_sendCMD69
;soundrec.c,339 :: 		return 1; // command rejected
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_sendCMD
;soundrec.c,340 :: 		}
L_sendCMD69:
;soundrec.c,343 :: 		return 0; // command accepted
	CLRF        R0 
;soundrec.c,345 :: 		}
L_end_sendCMD:
	RETURN      0
; end of _sendCMD

_writeMultipleBlock:

;soundrec.c,348 :: 		writeMultipleBlock(void)
;soundrec.c,352 :: 		volatile uint16_t rejected = 0;
	CLRF        writeMultipleBlock_rejected_L0+0 
	CLRF        writeMultipleBlock_rejected_L0+1 
;soundrec.c,354 :: 		while (1)
L_writeMultipleBlock71:
;soundrec.c,356 :: 		if (sendCMD(25, 0))
	MOVLW       25
	MOVWF       FARG_sendCMD_cmd+0 
	CLRF        FARG_sendCMD_arg+0 
	CLRF        FARG_sendCMD_arg+1 
	CLRF        FARG_sendCMD_arg+2 
	CLRF        FARG_sendCMD_arg+3 
	CALL        _sendCMD+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_writeMultipleBlock73
;soundrec.c,358 :: 		UWR("Command rejected!");
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
;soundrec.c,359 :: 		Delay_ms(10);
	MOVLW       65
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_writeMultipleBlock74:
	DECFSZ      R13, 1, 1
	BRA         L_writeMultipleBlock74
	DECFSZ      R12, 1, 1
	BRA         L_writeMultipleBlock74
	NOP
;soundrec.c,360 :: 		}
	GOTO        L_writeMultipleBlock75
L_writeMultipleBlock73:
;soundrec.c,363 :: 		break;
	GOTO        L_writeMultipleBlock72
;soundrec.c,364 :: 		}
L_writeMultipleBlock75:
;soundrec.c,365 :: 		}
	GOTO        L_writeMultipleBlock71
L_writeMultipleBlock72:
;soundrec.c,366 :: 		UWR("Command accepted!");
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
;soundrec.c,367 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,368 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,369 :: 		spiWrite(0xff); // Dummy clock
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,370 :: 		numberOfSectors = 0; // Initialize the number of sector will be recorded
	CLRF        _numberOfSectors+0 
	CLRF        _numberOfSectors+1 
;soundrec.c,371 :: 		while (SLCT) // repeat until Select button pressed
L_writeMultipleBlock76:
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_writeMultipleBlock77
;soundrec.c,373 :: 		spiWrite(0b11111100); // Data token for CMD 25
	MOVLW       252
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,374 :: 		for (g = 0; g < 512; g++)
	CLRF        writeMultipleBlock_g_L0+0 
	CLRF        writeMultipleBlock_g_L0+1 
L_writeMultipleBlock78:
	MOVLW       2
	SUBWF       writeMultipleBlock_g_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__writeMultipleBlock178
	MOVLW       0
	SUBWF       writeMultipleBlock_g_L0+0, 0 
L__writeMultipleBlock178:
	BTFSC       STATUS+0, 0 
	GOTO        L_writeMultipleBlock79
;soundrec.c,376 :: 		spiWrite((uint8_t) g);
	MOVF        writeMultipleBlock_g_L0+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,377 :: 		IntToStr(g, text);
	MOVF        writeMultipleBlock_g_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        writeMultipleBlock_g_L0+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       writeMultipleBlock_text_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(writeMultipleBlock_text_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,378 :: 		UWR(text);
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
;soundrec.c,379 :: 		Delay_ms(2);
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_writeMultipleBlock81:
	DECFSZ      R13, 1, 1
	BRA         L_writeMultipleBlock81
	DECFSZ      R12, 1, 1
	BRA         L_writeMultipleBlock81
	NOP
	NOP
;soundrec.c,374 :: 		for (g = 0; g < 512; g++)
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
;soundrec.c,380 :: 		} // write a block of 512 bytes data
	GOTO        L_writeMultipleBlock78
L_writeMultipleBlock79:
;soundrec.c,381 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,382 :: 		spiWrite(0xff); // 2 bytes CRC
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,384 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,385 :: 		while (count < 8)
L_writeMultipleBlock82:
	MOVLW       8
	SUBWF       _count+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_writeMultipleBlock83
;soundrec.c,387 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,388 :: 		if ((spiReadData & 0b00011111) == 0x05)
	MOVLW       31
	ANDWF       _spiReadData+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_writeMultipleBlock84
;soundrec.c,391 :: 		numberOfSectors++;
	MOVLW       1
	ADDWF       _numberOfSectors+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _numberOfSectors+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _numberOfSectors+0 
	MOVF        R1, 0 
	MOVWF       _numberOfSectors+1 
;soundrec.c,392 :: 		break;
	GOTO        L_writeMultipleBlock83
;soundrec.c,393 :: 		}
L_writeMultipleBlock84:
;soundrec.c,394 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,395 :: 		}
	GOTO        L_writeMultipleBlock82
L_writeMultipleBlock83:
;soundrec.c,396 :: 		if (count >= 8)
	MOVLW       8
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_writeMultipleBlock85
;soundrec.c,399 :: 		rejected++;
	MOVLW       1
	ADDWF       writeMultipleBlock_rejected_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      writeMultipleBlock_rejected_L0+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       writeMultipleBlock_rejected_L0+0 
	MOVF        R1, 0 
	MOVWF       writeMultipleBlock_rejected_L0+1 
;soundrec.c,400 :: 		}
L_writeMultipleBlock85:
;soundrec.c,402 :: 		do // check if the card is busy
L_writeMultipleBlock86:
;soundrec.c,404 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,406 :: 		while (spiReadData != 0xff);
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_writeMultipleBlock86
;soundrec.c,407 :: 		}
	GOTO        L_writeMultipleBlock76
L_writeMultipleBlock77:
;soundrec.c,410 :: 		spiWrite(0b11111101);
	MOVLW       253
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,411 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,412 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,413 :: 		while (spiReadData != 0xff) // check if the card is busy
L_writeMultipleBlock89:
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_writeMultipleBlock90
;soundrec.c,415 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,416 :: 		}
	GOTO        L_writeMultipleBlock89
L_writeMultipleBlock90:
;soundrec.c,417 :: 		UWR("STOPPED!")
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
;soundrec.c,418 :: 		IntToStr(numberOfSectors, text);
	MOVF        _numberOfSectors+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _numberOfSectors+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       writeMultipleBlock_text_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(writeMultipleBlock_text_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,419 :: 		UWR("Written:")
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
;soundrec.c,420 :: 		UWR(text);
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
;soundrec.c,421 :: 		IntToStr(rejected, text);
	MOVF        writeMultipleBlock_rejected_L0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        writeMultipleBlock_rejected_L0+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       writeMultipleBlock_text_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(writeMultipleBlock_text_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,422 :: 		UWR("Lost: ");
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
;soundrec.c,423 :: 		UWR(text); // Print out number of recjected sector
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
;soundrec.c,424 :: 		}
L_end_writeMultipleBlock:
	RETURN      0
; end of _writeMultipleBlock

_readMultipleBlock:

;soundrec.c,428 :: 		readMultipleBlock(void)
;soundrec.c,432 :: 		volatile uint16_t sectorIndex = 0;
	CLRF        readMultipleBlock_sectorIndex_L0+0 
	CLRF        readMultipleBlock_sectorIndex_L0+1 
;soundrec.c,434 :: 		do
L_readMultipleBlock91:
;soundrec.c,436 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,438 :: 		while (spiReadData != 0xff);
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock91
;soundrec.c,440 :: 		command(18, arg, 0x95);
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
;soundrec.c,441 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,442 :: 		do // verify R1 respond
L_readMultipleBlock94:
;soundrec.c,444 :: 		if (spiReadData == 0)
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock97
;soundrec.c,446 :: 		UWR("Command accepted!");
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
;soundrec.c,447 :: 		break;
	GOTO        L_readMultipleBlock95
;soundrec.c,448 :: 		}
L_readMultipleBlock97:
;soundrec.c,449 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,450 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,452 :: 		while (count < 10);
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_readMultipleBlock94
L_readMultipleBlock95:
;soundrec.c,453 :: 		if (count >= 10)
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_readMultipleBlock98
;soundrec.c,455 :: 		UWR("Command Rejected!");
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
;soundrec.c,456 :: 		while (1); // Trap the CPU
L_readMultipleBlock99:
	GOTO        L_readMultipleBlock99
;soundrec.c,457 :: 		}
L_readMultipleBlock98:
;soundrec.c,458 :: 		while (sectorIndex < numberOfSectors)
L_readMultipleBlock101:
	MOVF        _numberOfSectors+1, 0 
	SUBWF       readMultipleBlock_sectorIndex_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readMultipleBlock180
	MOVF        _numberOfSectors+0, 0 
	SUBWF       readMultipleBlock_sectorIndex_L0+0, 0 
L__readMultipleBlock180:
	BTFSC       STATUS+0, 0 
	GOTO        L_readMultipleBlock102
;soundrec.c,461 :: 		do
L_readMultipleBlock103:
;soundrec.c,463 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,465 :: 		while (spiReadData != 0xfe);
	MOVF        _spiReadData+0, 0 
	XORLW       254
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock103
;soundrec.c,467 :: 		for (g = 0; g < 512; g++)
	CLRF        readMultipleBlock_g_L0+0 
	CLRF        readMultipleBlock_g_L0+1 
L_readMultipleBlock106:
	MOVLW       2
	SUBWF       readMultipleBlock_g_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readMultipleBlock181
	MOVLW       0
	SUBWF       readMultipleBlock_g_L0+0, 0 
L__readMultipleBlock181:
	BTFSC       STATUS+0, 0 
	GOTO        L_readMultipleBlock107
;soundrec.c,469 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,470 :: 		IntToStr(spiReadData, text);
	MOVF        _spiReadData+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       readMultipleBlock_text_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(readMultipleBlock_text_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,471 :: 		UWR(text);
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
;soundrec.c,472 :: 		Delay_ms(2);
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_readMultipleBlock109:
	DECFSZ      R13, 1, 1
	BRA         L_readMultipleBlock109
	DECFSZ      R12, 1, 1
	BRA         L_readMultipleBlock109
	NOP
	NOP
;soundrec.c,467 :: 		for (g = 0; g < 512; g++)
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
;soundrec.c,473 :: 		}
	GOTO        L_readMultipleBlock106
L_readMultipleBlock107:
;soundrec.c,475 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,476 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,477 :: 		sectorIndex++;
	MOVLW       1
	ADDWF       readMultipleBlock_sectorIndex_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      readMultipleBlock_sectorIndex_L0+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       readMultipleBlock_sectorIndex_L0+0 
	MOVF        R1, 0 
	MOVWF       readMultipleBlock_sectorIndex_L0+1 
;soundrec.c,478 :: 		}
	GOTO        L_readMultipleBlock101
L_readMultipleBlock102:
;soundrec.c,481 :: 		command(12, 0, 0x95);
	MOVLW       12
	MOVWF       FARG_command_command+0 
	CLRF        FARG_command_fourbyte_arg+0 
	CLRF        FARG_command_fourbyte_arg+1 
	CLRF        FARG_command_fourbyte_arg+2 
	CLRF        FARG_command_fourbyte_arg+3 
	MOVLW       149
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;soundrec.c,482 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,483 :: 		do
L_readMultipleBlock110:
;soundrec.c,485 :: 		if (spiReadData == 0)
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock113
;soundrec.c,487 :: 		UWR("Stopped Transfer!");
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
;soundrec.c,488 :: 		break;
	GOTO        L_readMultipleBlock111
;soundrec.c,489 :: 		}
L_readMultipleBlock113:
;soundrec.c,490 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,491 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,493 :: 		while (count < 10);
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_readMultipleBlock110
L_readMultipleBlock111:
;soundrec.c,495 :: 		do
L_readMultipleBlock114:
;soundrec.c,497 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,499 :: 		while (spiReadData != 0xff);
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock114
;soundrec.c,500 :: 		UWR("Card free!");
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
;soundrec.c,501 :: 		while (1); // Trap the CPU
L_readMultipleBlock117:
	GOTO        L_readMultipleBlock117
;soundrec.c,502 :: 		}
L_end_readMultipleBlock:
	RETURN      0
; end of _readMultipleBlock

_hamghi:

;soundrec.c,506 :: 		void hamghi(void)
;soundrec.c,510 :: 		for(i=0; i<512; i++)
	CLRF        hamghi_i_L0+0 
	CLRF        hamghi_i_L0+1 
L_hamghi119:
	MOVLW       2
	SUBWF       hamghi_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamghi183
	MOVLW       0
	SUBWF       hamghi_i_L0+0, 0 
L__hamghi183:
	BTFSC       STATUS+0, 0 
	GOTO        L_hamghi120
;soundrec.c,512 :: 		TP0 = 1;
	BSF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;soundrec.c,513 :: 		Delay_us(15);
	MOVLW       24
	MOVWF       R13, 0
L_hamghi122:
	DECFSZ      R13, 1, 1
	BRA         L_hamghi122
	NOP
	NOP
;soundrec.c,514 :: 		TP0 = 0;
	BCF         LATC0_bit+0, BitPos(LATC0_bit+0) 
;soundrec.c,515 :: 		a[i] =  adcRead();
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
;soundrec.c,510 :: 		for(i=0; i<512; i++)
	INFSNZ      hamghi_i_L0+0, 1 
	INCF        hamghi_i_L0+1, 1 
;soundrec.c,518 :: 		}
	GOTO        L_hamghi119
L_hamghi120:
;soundrec.c,520 :: 		error = MMC_Write_Sector(t, a);
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
;soundrec.c,521 :: 		if (error == 1)
	MOVF        _error+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_hamghi123
;soundrec.c,523 :: 		UWR("Command error!");
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
;soundrec.c,524 :: 		}
	GOTO        L_hamghi124
L_hamghi123:
;soundrec.c,525 :: 		else if (error == 2)
	MOVF        _error+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_hamghi125
;soundrec.c,527 :: 		UWR("Write error!");
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
;soundrec.c,528 :: 		}
L_hamghi125:
L_hamghi124:
;soundrec.c,529 :: 		t++;
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
;soundrec.c,530 :: 		}
L_end_hamghi:
	RETURN      0
; end of _hamghi

_hamdoc:

;soundrec.c,533 :: 		void hamdoc()
;soundrec.c,538 :: 		if (Mmc_Read_Sector(t, a))
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
	GOTO        L_hamdoc126
;soundrec.c,540 :: 		UWR("Read error!");
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
;soundrec.c,541 :: 		}
L_hamdoc126:
;soundrec.c,542 :: 		for(i=0; i< 512; i++)
	CLRF        hamdoc_i_L0+0 
	CLRF        hamdoc_i_L0+1 
L_hamdoc127:
	MOVLW       2
	SUBWF       hamdoc_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamdoc185
	MOVLW       0
	SUBWF       hamdoc_i_L0+0, 0 
L__hamdoc185:
	BTFSC       STATUS+0, 0 
	GOTO        L_hamdoc128
;soundrec.c,544 :: 		DACOUT = a[i];
	MOVLW       hamdoc_a_L0+0
	ADDWF       hamdoc_i_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(hamdoc_a_L0+0)
	ADDWFC      hamdoc_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       LATB+0 
;soundrec.c,546 :: 		Delay_us(25);
	MOVLW       41
	MOVWF       R13, 0
L_hamdoc130:
	DECFSZ      R13, 1, 1
	BRA         L_hamdoc130
	NOP
;soundrec.c,542 :: 		for(i=0; i< 512; i++)
	INFSNZ      hamdoc_i_L0+0, 1 
	INCF        hamdoc_i_L0+1, 1 
;soundrec.c,547 :: 		}
	GOTO        L_hamdoc127
L_hamdoc128:
;soundrec.c,548 :: 		t++;
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
;soundrec.c,549 :: 		}
L_end_hamdoc:
	RETURN      0
; end of _hamdoc

_hamcaidat:

;soundrec.c,551 :: 		unsigned int hamcaidat()
;soundrec.c,553 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,554 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;soundrec.c,555 :: 		while (1)
L_hamcaidat131:
;soundrec.c,557 :: 		if(SLCT==0)
	BTFSC       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_hamcaidat133
;soundrec.c,559 :: 		Delay_ms(500);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_hamcaidat134:
	DECFSZ      R13, 1, 1
	BRA         L_hamcaidat134
	DECFSZ      R12, 1, 1
	BRA         L_hamcaidat134
	DECFSZ      R11, 1, 1
	BRA         L_hamcaidat134
	NOP
;soundrec.c,560 :: 		mode++;
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
;soundrec.c,561 :: 		if(mode==3)mode=1;
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamcaidat187
	MOVLW       3
	XORWF       _mode+0, 0 
L__hamcaidat187:
	BTFSS       STATUS+0, 2 
	GOTO        L_hamcaidat135
	MOVLW       1
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
L_hamcaidat135:
;soundrec.c,563 :: 		}
L_hamcaidat133:
;soundrec.c,566 :: 		if (mode == 1) UWR("Record");
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamcaidat188
	MOVLW       1
	XORWF       _mode+0, 0 
L__hamcaidat188:
	BTFSS       STATUS+0, 2 
	GOTO        L_hamcaidat136
	MOVLW       ?lstr34_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr34_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
L_hamcaidat136:
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,567 :: 		if (mode == 2) UWR("Play");
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__hamcaidat189
	MOVLW       2
	XORWF       _mode+0, 0 
L__hamcaidat189:
	BTFSS       STATUS+0, 2 
	GOTO        L_hamcaidat137
	MOVLW       ?lstr35_soundrec+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr35_soundrec+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
L_hamcaidat137:
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,568 :: 		if(OK==0)
	BTFSC       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_hamcaidat138
;soundrec.c,571 :: 		return mode;
	MOVF        _mode+0, 0 
	MOVWF       R0 
	MOVF        _mode+1, 0 
	MOVWF       R1 
	GOTO        L_end_hamcaidat
;soundrec.c,573 :: 		}
L_hamcaidat138:
;soundrec.c,574 :: 		}
	GOTO        L_hamcaidat131
;soundrec.c,575 :: 		}
L_end_hamcaidat:
	RETURN      0
; end of _hamcaidat

_main:

;soundrec.c,577 :: 		void main()
;soundrec.c,584 :: 		ADCON1 |= 0x0e; // AIN0 as analog input
	MOVLW       14
	IORWF       ADCON1+0, 1 
;soundrec.c,585 :: 		ADCON2 |= 0x2d; // 12 Tad and FOSC/16
	MOVLW       45
	IORWF       ADCON2+0, 1 
;soundrec.c,586 :: 		ADFM_bit = 0; // Left justified
	BCF         ADFM_bit+0, BitPos(ADFM_bit+0) 
;soundrec.c,587 :: 		ADON_bit = 1; // Enable ADC module
	BSF         ADON_bit+0, BitPos(ADON_bit+0) 
;soundrec.c,588 :: 		Delay_ms(100);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main139:
	DECFSZ      R13, 1, 1
	BRA         L_main139
	DECFSZ      R12, 1, 1
	BRA         L_main139
	DECFSZ      R11, 1, 1
	BRA         L_main139
	NOP
	NOP
;soundrec.c,591 :: 		TRISD=0xf3;
	MOVLW       243
	MOVWF       TRISD+0 
;soundrec.c,592 :: 		TRISA2_bit=1;
	BSF         TRISA2_bit+0, BitPos(TRISA2_bit+0) 
;soundrec.c,593 :: 		TRISD2_bit=1;
	BSF         TRISD2_bit+0, BitPos(TRISD2_bit+0) 
;soundrec.c,594 :: 		TRISD3_bit=1;
	BSF         TRISD3_bit+0, BitPos(TRISD3_bit+0) 
;soundrec.c,595 :: 		TRISB=0;
	CLRF        TRISB+0 
;soundrec.c,596 :: 		TRISC = 0x00;
	CLRF        TRISC+0 
;soundrec.c,599 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	MOVLW       2
	MOVWF       SPBRGH+0 
	MOVLW       8
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;soundrec.c,600 :: 		mmcInit();
	CALL        _mmcInit+0, 0
;soundrec.c,602 :: 		for ( ; ; )        // Repeats forever
L_main140:
;soundrec.c,605 :: 		while (SLCT != 0)        // Wait until SELECT pressed
L_main143:
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main144
;soundrec.c,607 :: 		}
	GOTO        L_main143
L_main144:
;soundrec.c,612 :: 		UWR("Select a Menu");
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
;soundrec.c,613 :: 		while (OK)
L_main145:
	BTFSS       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_main146
;soundrec.c,615 :: 		if (!SLCT)
	BTFSC       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main147
;soundrec.c,617 :: 		Delay_ms(300);
	MOVLW       8
	MOVWF       R11, 0
	MOVLW       157
	MOVWF       R12, 0
	MOVLW       5
	MOVWF       R13, 0
L_main148:
	DECFSZ      R13, 1, 1
	BRA         L_main148
	DECFSZ      R12, 1, 1
	BRA         L_main148
	DECFSZ      R11, 1, 1
	BRA         L_main148
	NOP
	NOP
;soundrec.c,618 :: 		mode++;
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
;soundrec.c,619 :: 		if (mode == 3)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main191
	MOVLW       3
	XORWF       _mode+0, 0 
L__main191:
	BTFSS       STATUS+0, 2 
	GOTO        L_main149
;soundrec.c,621 :: 		mode = 1;
	MOVLW       1
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
;soundrec.c,622 :: 		}
L_main149:
;soundrec.c,623 :: 		}
L_main147:
;soundrec.c,625 :: 		if ((mode == 1) & (lastMode != mode))
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main192
	MOVLW       1
	XORWF       _mode+0, 0 
L__main192:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main193
	MOVF        _mode+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main193:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main150
;soundrec.c,628 :: 		UWR("Record\n");
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
;soundrec.c,629 :: 		}
	GOTO        L_main151
L_main150:
;soundrec.c,630 :: 		else if ((mode == 2) & (lastMode != mode))
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main194
	MOVLW       2
	XORWF       _mode+0, 0 
L__main194:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main195
	MOVF        _mode+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main195:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main152
;soundrec.c,633 :: 		UWR("Play\n");
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
;soundrec.c,634 :: 		}
L_main152:
L_main151:
;soundrec.c,639 :: 		lastMode = mode;
	MOVF        _mode+0, 0 
	MOVWF       main_lastMode_L0+0 
;soundrec.c,640 :: 		}
	GOTO        L_main145
L_main146:
;soundrec.c,644 :: 		if (mode == 1)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main196
	MOVLW       1
	XORWF       _mode+0, 0 
L__main196:
	BTFSS       STATUS+0, 2 
	GOTO        L_main153
;soundrec.c,646 :: 		t = 0;
	CLRF        _t+0 
	CLRF        _t+1 
;soundrec.c,647 :: 		UWR("Writing");
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
;soundrec.c,648 :: 		PORTB = 0x00;
	CLRF        PORTB+0 
;soundrec.c,650 :: 		writeMultipleBlock();
	CALL        _writeMultipleBlock+0, 0
;soundrec.c,651 :: 		}
L_main153:
;soundrec.c,653 :: 		if (mode == 2)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main197
	MOVLW       2
	XORWF       _mode+0, 0 
L__main197:
	BTFSS       STATUS+0, 2 
	GOTO        L_main154
;soundrec.c,657 :: 		UWR("Reading");
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
;soundrec.c,658 :: 		t = 0;
	CLRF        _t+0 
	CLRF        _t+1 
;soundrec.c,660 :: 		readMultipleBlock();
	CALL        _readMultipleBlock+0, 0
;soundrec.c,661 :: 		while (SLCT && OK)
L_main155:
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main156
	BTFSS       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_main156
L__main162:
;soundrec.c,663 :: 		}
	GOTO        L_main155
L_main156:
;soundrec.c,664 :: 		}
L_main154:
;soundrec.c,666 :: 		}
	GOTO        L_main140
;soundrec.c,667 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
