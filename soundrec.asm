
_codeToRam:

;soundrec.c,85 :: 		char* codeToRam(const char* ctxt)
;soundrec.c,89 :: 		for(i =0; txt[i] = ctxt[i]; i++);
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
;soundrec.c,91 :: 		return txt;
	MOVLW       codeToRam_txt_L0+0
	MOVWF       R0 
	MOVLW       hi_addr(codeToRam_txt_L0+0)
	MOVWF       R1 
;soundrec.c,92 :: 		}
L_end_codeToRam:
	RETURN      0
; end of _codeToRam

_adcRead:

;soundrec.c,98 :: 		adcRead(void)
;soundrec.c,101 :: 		GO_bit = 1; // Begin conversion
	BSF         GO_bit+0, BitPos(GO_bit+0) 
;soundrec.c,102 :: 		while (GO_bit); // Wait for conversion completed
L_adcRead3:
	BTFSS       GO_bit+0, BitPos(GO_bit+0) 
	GOTO        L_adcRead4
	GOTO        L_adcRead3
L_adcRead4:
;soundrec.c,104 :: 		return ADRESH;
	MOVF        ADRESH+0, 0 
	MOVWF       R0 
;soundrec.c,105 :: 		}
L_end_adcRead:
	RETURN      0
; end of _adcRead

_caidatMMC:

;soundrec.c,108 :: 		void caidatMMC()
;soundrec.c,110 :: 		UWR("Detecting MMC");
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
;soundrec.c,111 :: 		Delay_ms(1000);
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
;soundrec.c,113 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,115 :: 		while (MMC_Init() != 0)
L_caidatMMC6:
	CALL        _Mmc_Init+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_caidatMMC7
;soundrec.c,117 :: 		}
	GOTO        L_caidatMMC6
L_caidatMMC7:
;soundrec.c,120 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	CLRF        FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,121 :: 		UWR("MMC Detected!");
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
;soundrec.c,122 :: 		Delay_ms (1000);
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
;soundrec.c,123 :: 		}
L_end_caidatMMC:
	RETURN      0
; end of _caidatMMC

_command:

;soundrec.c,132 :: 		command(char command, uint32_t fourbyte_arg, char CRCbits)
;soundrec.c,134 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,135 :: 		spiWrite(0b01000000 | command);
	MOVLW       64
	IORWF       FARG_command_command+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,136 :: 		spiWrite((uint8_t) (fourbyte_arg >> 24));
	MOVF        FARG_command_fourbyte_arg+3, 0 
	MOVWF       R0 
	CLRF        R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,137 :: 		spiWrite((uint8_t) (fourbyte_arg >> 16));
	MOVF        FARG_command_fourbyte_arg+2, 0 
	MOVWF       R0 
	MOVF        FARG_command_fourbyte_arg+3, 0 
	MOVWF       R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,138 :: 		spiWrite((uint8_t) (fourbyte_arg >> 8));
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
;soundrec.c,139 :: 		spiWrite((uint8_t) (fourbyte_arg));
	MOVF        FARG_command_fourbyte_arg+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,140 :: 		spiWrite(CRCbits);
	MOVF        FARG_command_CRCbits+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,141 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,142 :: 		}
L_end_command:
	RETURN      0
; end of _command

_mmcInit:

;soundrec.c,145 :: 		mmcInit(void)
;soundrec.c,148 :: 		volatile uint8_t error = 0;
	CLRF        mmcInit_error_L0+0 
;soundrec.c,150 :: 		Delay_ms(2);
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
;soundrec.c,151 :: 		Mmc_Chip_Select = 1;
	BSF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;soundrec.c,152 :: 		for (u = 0; u < 10; u++)
	CLRF        mmcInit_u_L0+0 
L_mmcInit10:
	MOVLW       10
	SUBWF       mmcInit_u_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_mmcInit11
;soundrec.c,154 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,152 :: 		for (u = 0; u < 10; u++)
	INCF        mmcInit_u_L0+0, 1 
;soundrec.c,155 :: 		}
	GOTO        L_mmcInit10
L_mmcInit11:
;soundrec.c,156 :: 		Mmc_Chip_Select = 0;
	BCF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;soundrec.c,157 :: 		Delay_ms(1);
	MOVLW       7
	MOVWF       R12, 0
	MOVLW       125
	MOVWF       R13, 0
L_mmcInit13:
	DECFSZ      R13, 1, 1
	BRA         L_mmcInit13
	DECFSZ      R12, 1, 1
	BRA         L_mmcInit13
;soundrec.c,158 :: 		command(0, 0, 0x95);
	CLRF        FARG_command_command+0 
	CLRF        FARG_command_fourbyte_arg+0 
	CLRF        FARG_command_fourbyte_arg+1 
	CLRF        FARG_command_fourbyte_arg+2 
	CLRF        FARG_command_fourbyte_arg+3 
	MOVLW       149
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;soundrec.c,159 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,160 :: 		while ((spiReadData != 1) && (count < 10))
L_mmcInit14:
	MOVF        _spiReadData+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_mmcInit15
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_mmcInit15
L__mmcInit146:
;soundrec.c,162 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,163 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,164 :: 		}
	GOTO        L_mmcInit14
L_mmcInit15:
;soundrec.c,165 :: 		if (count >= 10)
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_mmcInit18
;soundrec.c,167 :: 		error = initERROR_CMD0;
	MOVLW       1
	MOVWF       mmcInit_error_L0+0 
;soundrec.c,168 :: 		}
L_mmcInit18:
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
;soundrec.c,170 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,171 :: 		while ((spiReadData != 0) && (count < 1000))
L_mmcInit19:
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_mmcInit20
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mmcInit153
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit153:
	BTFSC       STATUS+0, 0 
	GOTO        L_mmcInit20
L__mmcInit145:
;soundrec.c,173 :: 		command(1, 0, 0xff);
	MOVLW       1
	MOVWF       FARG_command_command+0 
	CLRF        FARG_command_fourbyte_arg+0 
	CLRF        FARG_command_fourbyte_arg+1 
	CLRF        FARG_command_fourbyte_arg+2 
	CLRF        FARG_command_fourbyte_arg+3 
	MOVLW       255
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;soundrec.c,174 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,175 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,176 :: 		}
	GOTO        L_mmcInit19
L_mmcInit20:
;soundrec.c,177 :: 		if (count >= 1000)
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mmcInit154
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit154:
	BTFSS       STATUS+0, 0 
	GOTO        L_mmcInit23
;soundrec.c,179 :: 		error = initERROR_CMD1;
	MOVLW       2
	MOVWF       mmcInit_error_L0+0 
;soundrec.c,180 :: 		}
L_mmcInit23:
;soundrec.c,181 :: 		command(16, 512, 0xff);
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
;soundrec.c,182 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,183 :: 		while ((spiReadData != 0) && (count < 1000))
L_mmcInit24:
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_mmcInit25
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mmcInit155
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit155:
	BTFSC       STATUS+0, 0 
	GOTO        L_mmcInit25
L__mmcInit144:
;soundrec.c,185 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,186 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,187 :: 		}
	GOTO        L_mmcInit24
L_mmcInit25:
;soundrec.c,188 :: 		if (count >= 1000)
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mmcInit156
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit156:
	BTFSS       STATUS+0, 0 
	GOTO        L_mmcInit28
;soundrec.c,190 :: 		error = initERROR_CMD16;
	MOVLW       3
	MOVWF       mmcInit_error_L0+0 
;soundrec.c,191 :: 		}
L_mmcInit28:
;soundrec.c,192 :: 		return error;
	MOVF        mmcInit_error_L0+0, 0 
	MOVWF       R0 
;soundrec.c,193 :: 		}
L_end_mmcInit:
	RETURN      0
; end of _mmcInit

_writeSingleBlock:

;soundrec.c,196 :: 		writeSingleBlock(void)
;soundrec.c,198 :: 		uint16_t g = 0;
	CLRF        writeSingleBlock_g_L0+0 
	CLRF        writeSingleBlock_g_L0+1 
;soundrec.c,199 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,201 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,202 :: 		while (spiReadData != 0xff)
L_writeSingleBlock29:
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_writeSingleBlock30
;soundrec.c,204 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,205 :: 		UWR("Card busy!");
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
;soundrec.c,206 :: 		}
	GOTO        L_writeSingleBlock29
L_writeSingleBlock30:
;soundrec.c,208 :: 		command(24, arg, 0x95);
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
;soundrec.c,210 :: 		while (spiReadData != 0)
L_writeSingleBlock31:
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_writeSingleBlock32
;soundrec.c,212 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,213 :: 		}
	GOTO        L_writeSingleBlock31
L_writeSingleBlock32:
;soundrec.c,214 :: 		UWR("Command accepted!");
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
;soundrec.c,215 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,216 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,217 :: 		spiWrite(0b11111110); // Data token for CMD 24
	MOVLW       254
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,218 :: 		for (g = 0; g < 512; g++)
	CLRF        writeSingleBlock_g_L0+0 
	CLRF        writeSingleBlock_g_L0+1 
L_writeSingleBlock33:
	MOVLW       2
	SUBWF       writeSingleBlock_g_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__writeSingleBlock158
	MOVLW       0
	SUBWF       writeSingleBlock_g_L0+0, 0 
L__writeSingleBlock158:
	BTFSC       STATUS+0, 0 
	GOTO        L_writeSingleBlock34
;soundrec.c,220 :: 		spiWrite(0x50);
	MOVLW       80
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,218 :: 		for (g = 0; g < 512; g++)
	INFSNZ      writeSingleBlock_g_L0+0, 1 
	INCF        writeSingleBlock_g_L0+1, 1 
;soundrec.c,221 :: 		}
	GOTO        L_writeSingleBlock33
L_writeSingleBlock34:
;soundrec.c,222 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,223 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,224 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,226 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,227 :: 		while (count < 10)
L_writeSingleBlock36:
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_writeSingleBlock37
;soundrec.c,229 :: 		if ((spiReadData & 0b00011111) == 0x05)
	MOVLW       31
	ANDWF       _spiReadData+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_writeSingleBlock38
;soundrec.c,231 :: 		UWR("Data accepted!");
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
;soundrec.c,232 :: 		break;
	GOTO        L_writeSingleBlock37
;soundrec.c,233 :: 		}
L_writeSingleBlock38:
;soundrec.c,234 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,235 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,236 :: 		}
	GOTO        L_writeSingleBlock36
L_writeSingleBlock37:
;soundrec.c,237 :: 		if (count >= 10)
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_writeSingleBlock39
;soundrec.c,239 :: 		UWR("Data rejected!");
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
;soundrec.c,240 :: 		}
L_writeSingleBlock39:
;soundrec.c,241 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,242 :: 		while (spiReadData != 0xff)
L_writeSingleBlock40:
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_writeSingleBlock41
;soundrec.c,244 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,245 :: 		}
	GOTO        L_writeSingleBlock40
L_writeSingleBlock41:
;soundrec.c,246 :: 		UWR("Card is idle");
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
;soundrec.c,247 :: 		}
L_end_writeSingleBlock:
	RETURN      0
; end of _writeSingleBlock

_readSingleBlock:

;soundrec.c,249 :: 		readSingleBlock(void)
;soundrec.c,253 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,254 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,255 :: 		while (spiReadData != 0xff)
L_readSingleBlock42:
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_readSingleBlock43
;soundrec.c,257 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,258 :: 		UWR("Card busy!");
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
;soundrec.c,259 :: 		}
	GOTO        L_readSingleBlock42
L_readSingleBlock43:
;soundrec.c,261 :: 		command(17, arg, 0x95); // read 512 bytes from byte address 0
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
;soundrec.c,263 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,264 :: 		while (count < 10)
L_readSingleBlock44:
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_readSingleBlock45
;soundrec.c,266 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,267 :: 		if (spiReadData == 0)
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_readSingleBlock46
;soundrec.c,269 :: 		UWR("CMD accepted!");
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
;soundrec.c,270 :: 		break;
	GOTO        L_readSingleBlock45
;soundrec.c,271 :: 		}
L_readSingleBlock46:
;soundrec.c,272 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,273 :: 		}
	GOTO        L_readSingleBlock44
L_readSingleBlock45:
;soundrec.c,274 :: 		if (count >= 10)
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_readSingleBlock47
;soundrec.c,276 :: 		UWR("CMD Rejected!");
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
;soundrec.c,277 :: 		while (1); // Trap the CPU
L_readSingleBlock48:
	GOTO        L_readSingleBlock48
;soundrec.c,278 :: 		}
L_readSingleBlock47:
;soundrec.c,280 :: 		while (spiReadData != 0xfe)
L_readSingleBlock50:
	MOVF        _spiReadData+0, 0 
	XORLW       254
	BTFSC       STATUS+0, 2 
	GOTO        L_readSingleBlock51
;soundrec.c,282 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,283 :: 		}
	GOTO        L_readSingleBlock50
L_readSingleBlock51:
;soundrec.c,284 :: 		UWR("Token received!");
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
;soundrec.c,286 :: 		for (numOfBytes = 0; numOfBytes < 512; numOfBytes++)
	CLRF        readSingleBlock_numOfBytes_L0+0 
	CLRF        readSingleBlock_numOfBytes_L0+1 
L_readSingleBlock52:
	MOVLW       2
	SUBWF       readSingleBlock_numOfBytes_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readSingleBlock160
	MOVLW       0
	SUBWF       readSingleBlock_numOfBytes_L0+0, 0 
L__readSingleBlock160:
	BTFSC       STATUS+0, 0 
	GOTO        L_readSingleBlock53
;soundrec.c,288 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,289 :: 		IntToStr(spiReadData, strData);
	MOVF        _spiReadData+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       readSingleBlock_strData_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(readSingleBlock_strData_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,290 :: 		UWR(strData);
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
;soundrec.c,291 :: 		DACOUT = spiReadData;
	MOVF        _spiReadData+0, 0 
	MOVWF       LATB+0 
;soundrec.c,292 :: 		Delay_ms(2);
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_readSingleBlock55:
	DECFSZ      R13, 1, 1
	BRA         L_readSingleBlock55
	DECFSZ      R12, 1, 1
	BRA         L_readSingleBlock55
	NOP
	NOP
;soundrec.c,286 :: 		for (numOfBytes = 0; numOfBytes < 512; numOfBytes++)
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
;soundrec.c,293 :: 		}
	GOTO        L_readSingleBlock52
L_readSingleBlock53:
;soundrec.c,295 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,296 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,297 :: 		UWR("DONE!");
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
;soundrec.c,298 :: 		}
L_end_readSingleBlock:
	RETURN      0
; end of _readSingleBlock

_sendCMD:

;soundrec.c,302 :: 		sendCMD(uint8_t cmd, uint32_t arg)
;soundrec.c,304 :: 		uint8_t retryTimes = 0;
	CLRF        sendCMD_retryTimes_L0+0 
;soundrec.c,307 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,308 :: 		do
L_sendCMD56:
;soundrec.c,310 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,312 :: 		while (spiReadData != 0xff);
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_sendCMD56
;soundrec.c,316 :: 		spiWrite(0b01000000 | cmd);
	MOVLW       64
	IORWF       FARG_sendCMD_cmd+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,317 :: 		spiWrite((uint8_t) (arg >> 24));
	MOVF        FARG_sendCMD_arg+3, 0 
	MOVWF       R0 
	CLRF        R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,318 :: 		spiWrite((uint8_t) (arg >> 16));
	MOVF        FARG_sendCMD_arg+2, 0 
	MOVWF       R0 
	MOVF        FARG_sendCMD_arg+3, 0 
	MOVWF       R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,319 :: 		spiWrite((uint8_t) (arg >> 8));
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
;soundrec.c,320 :: 		spiWrite((uint8_t) arg);
	MOVF        FARG_sendCMD_arg+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,321 :: 		spiWrite(0x95); // default CRC for SPI protocol
	MOVLW       149
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,322 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,324 :: 		while (retryTimes < 10)
L_sendCMD59:
	MOVLW       10
	SUBWF       sendCMD_retryTimes_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_sendCMD60
;soundrec.c,326 :: 		if (spiReadData == 0)
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_sendCMD61
;soundrec.c,328 :: 		break;
	GOTO        L_sendCMD60
;soundrec.c,329 :: 		}
L_sendCMD61:
;soundrec.c,330 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,331 :: 		retryTimes++;
	INCF        sendCMD_retryTimes_L0+0, 1 
;soundrec.c,332 :: 		}
	GOTO        L_sendCMD59
L_sendCMD60:
;soundrec.c,334 :: 		if (retryTimes >= 10)
	MOVLW       10
	SUBWF       sendCMD_retryTimes_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_sendCMD62
;soundrec.c,336 :: 		return 1; // command rejected
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_sendCMD
;soundrec.c,337 :: 		}
L_sendCMD62:
;soundrec.c,340 :: 		return 0; // command accepted
	CLRF        R0 
;soundrec.c,342 :: 		}
L_end_sendCMD:
	RETURN      0
; end of _sendCMD

_writeMultipleBlock:

;soundrec.c,345 :: 		writeMultipleBlock(void)
;soundrec.c,357 :: 		do
L_writeMultipleBlock64:
;soundrec.c,359 :: 		if (!(sendCMD(25, 0))) // write command accepted
	MOVLW       25
	MOVWF       FARG_sendCMD_cmd+0 
	CLRF        FARG_sendCMD_arg+0 
	CLRF        FARG_sendCMD_arg+1 
	CLRF        FARG_sendCMD_arg+2 
	CLRF        FARG_sendCMD_arg+3 
	CALL        _sendCMD+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_writeMultipleBlock67
;soundrec.c,361 :: 		error = 0;
	CLRF        writeMultipleBlock_error_L0+0 
;soundrec.c,362 :: 		break;
	GOTO        L_writeMultipleBlock65
;soundrec.c,363 :: 		}
L_writeMultipleBlock67:
;soundrec.c,366 :: 		error = 1;
	MOVLW       1
	MOVWF       writeMultipleBlock_error_L0+0 
;soundrec.c,367 :: 		retry++;
	MOVF        writeMultipleBlock_retry_L0+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       writeMultipleBlock_retry_L0+0 
;soundrec.c,370 :: 		while (retry < 50);
	MOVLW       50
	SUBWF       writeMultipleBlock_retry_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_writeMultipleBlock64
L_writeMultipleBlock65:
;soundrec.c,372 :: 		if (!error)
	MOVF        writeMultipleBlock_error_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_writeMultipleBlock69
;soundrec.c,374 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,375 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,376 :: 		spiWrite(0xff); // Dummy clock
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,377 :: 		numberOfSectors = 0; // Initialize the number of sector
	CLRF        _numberOfSectors+0 
	CLRF        _numberOfSectors+1 
;soundrec.c,378 :: 		rejected = 0;
	CLRF        _rejected+0 
	CLRF        _rejected+1 
;soundrec.c,379 :: 		while (SLCT) // repeat until Select button pressed
L_writeMultipleBlock70:
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_writeMultipleBlock71
;soundrec.c,381 :: 		spiWrite(0b11111100); // Data token for CMD 25
	MOVLW       252
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,382 :: 		for (g = 0; g < 512; g++)
	CLRF        writeMultipleBlock_g_L0+0 
	CLRF        writeMultipleBlock_g_L0+1 
L_writeMultipleBlock72:
	MOVLW       2
	SUBWF       writeMultipleBlock_g_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__writeMultipleBlock163
	MOVLW       0
	SUBWF       writeMultipleBlock_g_L0+0, 0 
L__writeMultipleBlock163:
	BTFSC       STATUS+0, 0 
	GOTO        L_writeMultipleBlock73
;soundrec.c,386 :: 		spiWrite(adcRead());
	CALL        _adcRead+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,382 :: 		for (g = 0; g < 512; g++)
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
;soundrec.c,392 :: 		} // write a block of 512 bytes data
	GOTO        L_writeMultipleBlock72
L_writeMultipleBlock73:
;soundrec.c,393 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,394 :: 		spiWrite(0xff); // 2 bytes CRC
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,396 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,397 :: 		while (count < 30)
L_writeMultipleBlock75:
	MOVLW       30
	SUBWF       _count+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_writeMultipleBlock76
;soundrec.c,399 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,400 :: 		if ((spiReadData & 0b00011111) == 0x05)
	MOVLW       31
	ANDWF       _spiReadData+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_writeMultipleBlock77
;soundrec.c,404 :: 		numberOfSectors++;
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
;soundrec.c,405 :: 		break;
	GOTO        L_writeMultipleBlock76
;soundrec.c,406 :: 		}
L_writeMultipleBlock77:
;soundrec.c,407 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,408 :: 		}
	GOTO        L_writeMultipleBlock75
L_writeMultipleBlock76:
;soundrec.c,409 :: 		if (count >= 30)
	MOVLW       30
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_writeMultipleBlock78
;soundrec.c,411 :: 		UWR("Data rejected!");
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
;soundrec.c,412 :: 		rejected++;
	MOVLW       1
	ADDWF       _rejected+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _rejected+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _rejected+0 
	MOVF        R1, 0 
	MOVWF       _rejected+1 
;soundrec.c,413 :: 		}
L_writeMultipleBlock78:
;soundrec.c,414 :: 		do // check if the card is busy
L_writeMultipleBlock79:
;soundrec.c,416 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,418 :: 		while (spiReadData != 0xff);
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_writeMultipleBlock79
;soundrec.c,419 :: 		}
	GOTO        L_writeMultipleBlock70
L_writeMultipleBlock71:
;soundrec.c,422 :: 		spiWrite(0b11111101);
	MOVLW       253
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,423 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;soundrec.c,424 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,425 :: 		while (spiReadData != 0xff) // check if the card is busy
L_writeMultipleBlock82:
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_writeMultipleBlock83
;soundrec.c,427 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,428 :: 		}
	GOTO        L_writeMultipleBlock82
L_writeMultipleBlock83:
;soundrec.c,429 :: 		}
L_writeMultipleBlock69:
;soundrec.c,430 :: 		return error;
	MOVF        writeMultipleBlock_error_L0+0, 0 
	MOVWF       R0 
;soundrec.c,431 :: 		}
L_end_writeMultipleBlock:
	RETURN      0
; end of _writeMultipleBlock

_readMultipleBlock:

;soundrec.c,435 :: 		readMultipleBlock(void)
;soundrec.c,439 :: 		volatile uint16_t sectorIndex = 0;
	CLRF        readMultipleBlock_sectorIndex_L0+0 
	CLRF        readMultipleBlock_sectorIndex_L0+1 
;soundrec.c,441 :: 		do
L_readMultipleBlock84:
;soundrec.c,443 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,445 :: 		while (spiReadData != 0xff);
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock84
;soundrec.c,447 :: 		command(18, arg, 0x95);
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
;soundrec.c,448 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,449 :: 		do // verify R1 respond
L_readMultipleBlock87:
;soundrec.c,451 :: 		if (spiReadData == 0)
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock90
;soundrec.c,453 :: 		UWR("Command accepted!");
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
;soundrec.c,454 :: 		break;
	GOTO        L_readMultipleBlock88
;soundrec.c,455 :: 		}
L_readMultipleBlock90:
;soundrec.c,456 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,457 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,459 :: 		while (count < 10);
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_readMultipleBlock87
L_readMultipleBlock88:
;soundrec.c,460 :: 		if (count >= 10)
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_readMultipleBlock91
;soundrec.c,462 :: 		UWR("Command Rejected!");
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
;soundrec.c,463 :: 		while (1); // Trap the CPU
L_readMultipleBlock92:
	GOTO        L_readMultipleBlock92
;soundrec.c,464 :: 		}
L_readMultipleBlock91:
;soundrec.c,465 :: 		while (SLCT)
L_readMultipleBlock94:
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_readMultipleBlock95
;soundrec.c,468 :: 		do
L_readMultipleBlock96:
;soundrec.c,470 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,472 :: 		while (spiReadData != 0xfe);
	MOVF        _spiReadData+0, 0 
	XORLW       254
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock96
;soundrec.c,474 :: 		for (g = 0; g < 512; g++)
	CLRF        readMultipleBlock_g_L0+0 
	CLRF        readMultipleBlock_g_L0+1 
L_readMultipleBlock99:
	MOVLW       2
	SUBWF       readMultipleBlock_g_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readMultipleBlock165
	MOVLW       0
	SUBWF       readMultipleBlock_g_L0+0, 0 
L__readMultipleBlock165:
	BTFSC       STATUS+0, 0 
	GOTO        L_readMultipleBlock100
;soundrec.c,480 :: 		DACOUT = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       LATB+0 
;soundrec.c,481 :: 		Delay_us(18);
	MOVLW       29
	MOVWF       R13, 0
L_readMultipleBlock102:
	DECFSZ      R13, 1, 1
	BRA         L_readMultipleBlock102
	NOP
	NOP
;soundrec.c,474 :: 		for (g = 0; g < 512; g++)
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
;soundrec.c,482 :: 		}
	GOTO        L_readMultipleBlock99
L_readMultipleBlock100:
;soundrec.c,484 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,485 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,486 :: 		sectorIndex++;
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
;soundrec.c,487 :: 		}
	GOTO        L_readMultipleBlock94
L_readMultipleBlock95:
;soundrec.c,490 :: 		command(12, 0, 0x95);
	MOVLW       12
	MOVWF       FARG_command_command+0 
	CLRF        FARG_command_fourbyte_arg+0 
	CLRF        FARG_command_fourbyte_arg+1 
	CLRF        FARG_command_fourbyte_arg+2 
	CLRF        FARG_command_fourbyte_arg+3 
	MOVLW       149
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;soundrec.c,491 :: 		count = 0;
	CLRF        _count+0 
;soundrec.c,492 :: 		do
L_readMultipleBlock103:
;soundrec.c,494 :: 		if (spiReadData == 0)
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock106
;soundrec.c,496 :: 		UWR("Stopped Transfer!");
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
;soundrec.c,497 :: 		break;
	GOTO        L_readMultipleBlock104
;soundrec.c,498 :: 		}
L_readMultipleBlock106:
;soundrec.c,499 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,500 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;soundrec.c,502 :: 		while (count < 10);
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_readMultipleBlock103
L_readMultipleBlock104:
;soundrec.c,504 :: 		do
L_readMultipleBlock107:
;soundrec.c,506 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;soundrec.c,508 :: 		while (spiReadData != 0xff);
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock107
;soundrec.c,509 :: 		UWR("Card free!");
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
;soundrec.c,510 :: 		}
L_end_readMultipleBlock:
	RETURN      0
; end of _readMultipleBlock

_main:

;soundrec.c,512 :: 		void main()
;soundrec.c,516 :: 		volatile uint8_t initRetry = 0;
	CLRF        main_initRetry_L0+0 
;soundrec.c,520 :: 		ADCON1 |= 0x0e; // AIN0 as analog input
	MOVLW       14
	IORWF       ADCON1+0, 1 
;soundrec.c,521 :: 		ADCON2 |= 0x2d; // 12 Tad and FOSC/16
	MOVLW       45
	IORWF       ADCON2+0, 1 
;soundrec.c,522 :: 		ADFM_bit = 0; // Left justified
	BCF         ADFM_bit+0, BitPos(ADFM_bit+0) 
;soundrec.c,523 :: 		ADON_bit = 1; // Enable ADC module
	BSF         ADON_bit+0, BitPos(ADON_bit+0) 
;soundrec.c,524 :: 		Delay_ms(100);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main110:
	DECFSZ      R13, 1, 1
	BRA         L_main110
	DECFSZ      R12, 1, 1
	BRA         L_main110
	DECFSZ      R11, 1, 1
	BRA         L_main110
	NOP
	NOP
;soundrec.c,527 :: 		TRISD=0xf3;
	MOVLW       243
	MOVWF       TRISD+0 
;soundrec.c,528 :: 		TRISA2_bit=1;
	BSF         TRISA2_bit+0, BitPos(TRISA2_bit+0) 
;soundrec.c,529 :: 		TRISD2_bit=1;
	BSF         TRISD2_bit+0, BitPos(TRISD2_bit+0) 
;soundrec.c,530 :: 		TRISD3_bit=1;
	BSF         TRISD3_bit+0, BitPos(TRISD3_bit+0) 
;soundrec.c,531 :: 		TRISB=0;
	CLRF        TRISB+0 
;soundrec.c,532 :: 		TRISC = 0x00;
	CLRF        TRISC+0 
;soundrec.c,535 :: 		UART1_Init(9600);
	BSF         BAUDCON+0, 3, 0
	MOVLW       2
	MOVWF       SPBRGH+0 
	MOVLW       8
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;soundrec.c,538 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,540 :: 		while (1)
L_main111:
;soundrec.c,542 :: 		if (mmcInit() == 0)
	CALL        _mmcInit+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main113
;soundrec.c,544 :: 		UWR("Card detected!");
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
;soundrec.c,545 :: 		break;
	GOTO        L_main112
;soundrec.c,546 :: 		}
L_main113:
;soundrec.c,547 :: 		initRetry++;
	MOVF        main_initRetry_L0+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       main_initRetry_L0+0 
;soundrec.c,548 :: 		if (initRetry == 50)
	MOVF        main_initRetry_L0+0, 0 
	XORLW       50
	BTFSS       STATUS+0, 2 
	GOTO        L_main114
;soundrec.c,550 :: 		UWR("Card error, CPU trapped!");
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
;soundrec.c,551 :: 		while (1); // Trap the CPU
L_main115:
	GOTO        L_main115
;soundrec.c,552 :: 		}
L_main114:
;soundrec.c,553 :: 		}
	GOTO        L_main111
L_main112:
;soundrec.c,555 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	CLRF        FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,557 :: 		for ( ; ; )        // Repeats forever
L_main117:
;soundrec.c,560 :: 		while (SLCT != 0)        // Wait until SELECT pressed
L_main120:
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main121
;soundrec.c,562 :: 		}
	GOTO        L_main120
L_main121:
;soundrec.c,567 :: 		UWR("Select a Menu");
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
;soundrec.c,568 :: 		while (OK)
L_main122:
	BTFSS       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_main123
;soundrec.c,570 :: 		if (!SLCT)
	BTFSC       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main124
;soundrec.c,572 :: 		Delay_ms(300);
	MOVLW       8
	MOVWF       R11, 0
	MOVLW       157
	MOVWF       R12, 0
	MOVLW       5
	MOVWF       R13, 0
L_main125:
	DECFSZ      R13, 1, 1
	BRA         L_main125
	DECFSZ      R12, 1, 1
	BRA         L_main125
	DECFSZ      R11, 1, 1
	BRA         L_main125
	NOP
	NOP
;soundrec.c,573 :: 		mode++;
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
;soundrec.c,574 :: 		if (mode == 3)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main167
	MOVLW       3
	XORWF       _mode+0, 0 
L__main167:
	BTFSS       STATUS+0, 2 
	GOTO        L_main126
;soundrec.c,576 :: 		mode = 1;
	MOVLW       1
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
;soundrec.c,577 :: 		}
L_main126:
;soundrec.c,578 :: 		}
L_main124:
;soundrec.c,580 :: 		if ((mode == 1) & (lastMode != mode))
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main168
	MOVLW       1
	XORWF       _mode+0, 0 
L__main168:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main169
	MOVF        _mode+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main169:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main127
;soundrec.c,583 :: 		UWR("Record\n");
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
;soundrec.c,584 :: 		}
	GOTO        L_main128
L_main127:
;soundrec.c,585 :: 		else if ((mode == 2) & (lastMode != mode))
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main170
	MOVLW       2
	XORWF       _mode+0, 0 
L__main170:
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main171
	MOVF        _mode+0, 0 
	XORWF       main_lastMode_L0+0, 0 
L__main171:
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R1, 0 
	ANDWF       R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main129
;soundrec.c,588 :: 		UWR("Play\n");
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
;soundrec.c,589 :: 		}
L_main129:
L_main128:
;soundrec.c,594 :: 		lastMode = mode;
	MOVF        _mode+0, 0 
	MOVWF       main_lastMode_L0+0 
;soundrec.c,595 :: 		}
	GOTO        L_main122
L_main123:
;soundrec.c,599 :: 		if (mode == 1)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main172
	MOVLW       1
	XORWF       _mode+0, 0 
L__main172:
	BTFSS       STATUS+0, 2 
	GOTO        L_main130
;soundrec.c,601 :: 		t = 0;
	CLRF        _t+0 
	CLRF        _t+1 
;soundrec.c,602 :: 		UWR("Writing");
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
;soundrec.c,603 :: 		PORTB = 0x00;
	CLRF        PORTB+0 
;soundrec.c,607 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,609 :: 		while (1)
L_main131:
;soundrec.c,611 :: 		if (mmcInit() == 0)
	CALL        _mmcInit+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main133
;soundrec.c,613 :: 		UWR("Card detected!");
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
;soundrec.c,614 :: 		break;
	GOTO        L_main132
;soundrec.c,615 :: 		}
L_main133:
;soundrec.c,616 :: 		initRetry++;
	MOVF        main_initRetry_L0+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       main_initRetry_L0+0 
;soundrec.c,617 :: 		if (initRetry == 50)
	MOVF        main_initRetry_L0+0, 0 
	XORLW       50
	BTFSS       STATUS+0, 2 
	GOTO        L_main134
;soundrec.c,619 :: 		UWR("Card error, CPU trapped!");
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
;soundrec.c,620 :: 		while (1); // Trap the CPU
L_main135:
	GOTO        L_main135
;soundrec.c,621 :: 		}
L_main134:
;soundrec.c,622 :: 		}
	GOTO        L_main131
L_main132:
;soundrec.c,624 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	CLRF        FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;soundrec.c,626 :: 		if (writeMultipleBlock())
	CALL        _writeMultipleBlock+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main137
;soundrec.c,628 :: 		UWR("Write error!");
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
;soundrec.c,629 :: 		}
	GOTO        L_main138
L_main137:
;soundrec.c,632 :: 		UWR("STOPPED!")
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
;soundrec.c,633 :: 		IntToStr(numberOfSectors, text);
	MOVF        _numberOfSectors+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _numberOfSectors+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_text_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_text_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,634 :: 		UWR("Written:")
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
;soundrec.c,635 :: 		UWR(text);
	MOVLW       main_text_L0+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(main_text_L0+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,636 :: 		IntToStr(rejected, text);
	MOVF        _rejected+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _rejected+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       main_text_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(main_text_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;soundrec.c,637 :: 		UWR("Lost: ");
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
;soundrec.c,638 :: 		UWR(text); // Print out number of recjected sector
	MOVLW       main_text_L0+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(main_text_L0+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;soundrec.c,639 :: 		}
L_main138:
;soundrec.c,640 :: 		}
L_main130:
;soundrec.c,642 :: 		if (mode == 2)
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main173
	MOVLW       2
	XORWF       _mode+0, 0 
L__main173:
	BTFSS       STATUS+0, 2 
	GOTO        L_main139
;soundrec.c,646 :: 		UWR("Reading");
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
;soundrec.c,647 :: 		t = 0;
	CLRF        _t+0 
	CLRF        _t+1 
;soundrec.c,648 :: 		readMultipleBlock();
	CALL        _readMultipleBlock+0, 0
;soundrec.c,649 :: 		while (SLCT && OK)
L_main140:
	BTFSS       RD2_bit+0, BitPos(RD2_bit+0) 
	GOTO        L_main141
	BTFSS       RD3_bit+0, BitPos(RD3_bit+0) 
	GOTO        L_main141
L__main147:
;soundrec.c,651 :: 		}
	GOTO        L_main140
L_main141:
;soundrec.c,652 :: 		}
L_main139:
;soundrec.c,654 :: 		}
	GOTO        L_main117
;soundrec.c,655 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
