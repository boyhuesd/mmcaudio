
_mmcInit:

;mmc.c,10 :: 		uint8_t mmcInit(void)
;mmc.c,13 :: 		volatile uint8_t error = 0;
	CLRF        mmcInit_error_L0+0 
;mmc.c,15 :: 		CS = 1;
	BSF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;mmc.c,16 :: 		Delay_ms(2);
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_mmcInit0:
	DECFSZ      R13, 1, 1
	BRA         L_mmcInit0
	DECFSZ      R12, 1, 1
	BRA         L_mmcInit0
	NOP
	NOP
;mmc.c,17 :: 		for (u = 0; u < 10; u++)
	CLRF        mmcInit_u_L0+0 
L_mmcInit1:
	MOVLW       10
	SUBWF       mmcInit_u_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_mmcInit2
;mmc.c,19 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,17 :: 		for (u = 0; u < 10; u++)
	INCF        mmcInit_u_L0+0, 1 
;mmc.c,20 :: 		}
	GOTO        L_mmcInit1
L_mmcInit2:
;mmc.c,21 :: 		CS = 0;
	BCF         LATC2_bit+0, BitPos(LATC2_bit+0) 
;mmc.c,23 :: 		Delay_ms(1);
	MOVLW       7
	MOVWF       R12, 0
	MOVLW       125
	MOVWF       R13, 0
L_mmcInit4:
	DECFSZ      R13, 1, 1
	BRA         L_mmcInit4
	DECFSZ      R12, 1, 1
	BRA         L_mmcInit4
;mmc.c,24 :: 		command(0, 0, 0x95);
	CLRF        FARG_command_command+0 
	CLRF        FARG_command_fourbyte_arg+0 
	CLRF        FARG_command_fourbyte_arg+1 
	CLRF        FARG_command_fourbyte_arg+2 
	CLRF        FARG_command_fourbyte_arg+3 
	MOVLW       149
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;mmc.c,25 :: 		count = 0;
	CLRF        _count+0 
;mmc.c,26 :: 		while ((spiReadData != 1) && (count < 10))
L_mmcInit5:
	MOVF        _spiReadData+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_mmcInit6
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_mmcInit6
L__mmcInit114:
;mmc.c,28 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,29 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;mmc.c,30 :: 		}
	GOTO        L_mmcInit5
L_mmcInit6:
;mmc.c,31 :: 		if (count >= 10)
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_mmcInit9
;mmc.c,33 :: 		error = initERROR_CMD0;
	MOVLW       1
	MOVWF       mmcInit_error_L0+0 
;mmc.c,34 :: 		}
L_mmcInit9:
;mmc.c,35 :: 		command(1, 0, 0xff);
	MOVLW       1
	MOVWF       FARG_command_command+0 
	CLRF        FARG_command_fourbyte_arg+0 
	CLRF        FARG_command_fourbyte_arg+1 
	CLRF        FARG_command_fourbyte_arg+2 
	CLRF        FARG_command_fourbyte_arg+3 
	MOVLW       255
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;mmc.c,36 :: 		count = 0;
	CLRF        _count+0 
;mmc.c,37 :: 		while ((spiReadData != 0) && (count < 1000))
L_mmcInit10:
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_mmcInit11
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mmcInit116
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit116:
	BTFSC       STATUS+0, 0 
	GOTO        L_mmcInit11
L__mmcInit113:
;mmc.c,39 :: 		command(1, 0, 0xff);
	MOVLW       1
	MOVWF       FARG_command_command+0 
	CLRF        FARG_command_fourbyte_arg+0 
	CLRF        FARG_command_fourbyte_arg+1 
	CLRF        FARG_command_fourbyte_arg+2 
	CLRF        FARG_command_fourbyte_arg+3 
	MOVLW       255
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;mmc.c,40 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,41 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;mmc.c,42 :: 		}
	GOTO        L_mmcInit10
L_mmcInit11:
;mmc.c,43 :: 		if (count >= 1000)
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mmcInit117
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit117:
	BTFSS       STATUS+0, 0 
	GOTO        L_mmcInit14
;mmc.c,45 :: 		error = initERROR_CMD1;
	MOVLW       2
	MOVWF       mmcInit_error_L0+0 
;mmc.c,46 :: 		}
L_mmcInit14:
;mmc.c,47 :: 		command(16, 512, 0xff);
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
;mmc.c,48 :: 		count = 0;
	CLRF        _count+0 
;mmc.c,49 :: 		while ((spiReadData != 0) && (count < 1000))
L_mmcInit15:
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_mmcInit16
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mmcInit118
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit118:
	BTFSC       STATUS+0, 0 
	GOTO        L_mmcInit16
L__mmcInit112:
;mmc.c,51 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,52 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;mmc.c,53 :: 		}
	GOTO        L_mmcInit15
L_mmcInit16:
;mmc.c,54 :: 		if (count >= 1000)
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mmcInit119
	MOVLW       232
	SUBWF       _count+0, 0 
L__mmcInit119:
	BTFSS       STATUS+0, 0 
	GOTO        L_mmcInit19
;mmc.c,56 :: 		error = initERROR_CMD16;
	MOVLW       3
	MOVWF       mmcInit_error_L0+0 
;mmc.c,57 :: 		}
L_mmcInit19:
;mmc.c,59 :: 		return error;
	MOVF        mmcInit_error_L0+0, 0 
	MOVWF       R0 
;mmc.c,60 :: 		}
L_end_mmcInit:
	RETURN      0
; end of _mmcInit

_cardInit:

;mmc.c,62 :: 		void cardInit(uint8_t echo)
;mmc.c,64 :: 		uint8_t initRetry = 0;
	CLRF        cardInit_initRetry_L0+0 
;mmc.c,68 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;mmc.c,71 :: 		while (1)
L_cardInit20:
;mmc.c,73 :: 		if (mmcInit() == 0)
	CALL        _mmcInit+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_cardInit22
;mmc.c,75 :: 		if (echo == ECHO_ON)
	MOVF        FARG_cardInit_echo+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_cardInit23
;mmc.c,77 :: 		UWR("Card detected!");
	MOVLW       ?lstr1_mmc+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr1_mmc+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;mmc.c,78 :: 		}
L_cardInit23:
;mmc.c,79 :: 		break;
	GOTO        L_cardInit21
;mmc.c,80 :: 		}
L_cardInit22:
;mmc.c,81 :: 		initRetry++;
	INCF        cardInit_initRetry_L0+0, 1 
;mmc.c,82 :: 		if (initRetry == 50)
	MOVF        cardInit_initRetry_L0+0, 0 
	XORLW       50
	BTFSS       STATUS+0, 2 
	GOTO        L_cardInit24
;mmc.c,84 :: 		UWR("Card error, CPU trapped!");
	MOVLW       ?lstr2_mmc+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_mmc+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;mmc.c,85 :: 		while (1); // Trap the CPU
L_cardInit25:
	GOTO        L_cardInit25
;mmc.c,86 :: 		}
L_cardInit24:
;mmc.c,87 :: 		}
	GOTO        L_cardInit20
L_cardInit21:
;mmc.c,91 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	CLRF        FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;mmc.c,92 :: 		}
L_end_cardInit:
	RETURN      0
; end of _cardInit

_command:

;mmc.c,99 :: 		void command(char command, uint32_t fourbyte_arg, char CRCbits)
;mmc.c,101 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,102 :: 		spiWrite(0b01000000 | command);
	MOVLW       64
	IORWF       FARG_command_command+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,103 :: 		spiWrite((uint8_t) (fourbyte_arg >> 24));
	MOVF        FARG_command_fourbyte_arg+3, 0 
	MOVWF       R0 
	CLRF        R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,104 :: 		spiWrite((uint8_t) (fourbyte_arg >> 16));
	MOVF        FARG_command_fourbyte_arg+2, 0 
	MOVWF       R0 
	MOVF        FARG_command_fourbyte_arg+3, 0 
	MOVWF       R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,105 :: 		spiWrite((uint8_t) (fourbyte_arg >> 8));
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
;mmc.c,106 :: 		spiWrite((uint8_t) (fourbyte_arg));
	MOVF        FARG_command_fourbyte_arg+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,107 :: 		spiWrite(CRCbits);
	MOVF        FARG_command_CRCbits+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,108 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,109 :: 		}
L_end_command:
	RETURN      0
; end of _command

_writeSingleBlock:

;mmc.c,111 :: 		void writeSingleBlock(void)
;mmc.c,113 :: 		uint16_t g = 0;
	CLRF        writeSingleBlock_g_L0+0 
	CLRF        writeSingleBlock_g_L0+1 
;mmc.c,114 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,116 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,117 :: 		while (spiReadData != 0xff)
L_writeSingleBlock27:
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_writeSingleBlock28
;mmc.c,119 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,120 :: 		UWR("Card busy!");
	MOVLW       ?lstr3_mmc+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_mmc+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;mmc.c,121 :: 		}
	GOTO        L_writeSingleBlock27
L_writeSingleBlock28:
;mmc.c,123 :: 		command(24, arg, 0x95);
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
;mmc.c,125 :: 		while (spiReadData != 0)
L_writeSingleBlock29:
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_writeSingleBlock30
;mmc.c,127 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,128 :: 		}
	GOTO        L_writeSingleBlock29
L_writeSingleBlock30:
;mmc.c,129 :: 		UWR("Command accepted!");
	MOVLW       ?lstr4_mmc+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr4_mmc+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;mmc.c,130 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,131 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,132 :: 		spiWrite(0b11111110); // Data token for CMD 24
	MOVLW       254
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,133 :: 		for (g = 0; g < 512; g++)
	CLRF        writeSingleBlock_g_L0+0 
	CLRF        writeSingleBlock_g_L0+1 
L_writeSingleBlock31:
	MOVLW       2
	SUBWF       writeSingleBlock_g_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__writeSingleBlock123
	MOVLW       0
	SUBWF       writeSingleBlock_g_L0+0, 0 
L__writeSingleBlock123:
	BTFSC       STATUS+0, 0 
	GOTO        L_writeSingleBlock32
;mmc.c,135 :: 		spiWrite(0x50);
	MOVLW       80
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,133 :: 		for (g = 0; g < 512; g++)
	INFSNZ      writeSingleBlock_g_L0+0, 1 
	INCF        writeSingleBlock_g_L0+1, 1 
;mmc.c,136 :: 		}
	GOTO        L_writeSingleBlock31
L_writeSingleBlock32:
;mmc.c,137 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,138 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,139 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,141 :: 		count = 0;
	CLRF        _count+0 
;mmc.c,142 :: 		while (count < 10)
L_writeSingleBlock34:
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_writeSingleBlock35
;mmc.c,144 :: 		if ((spiReadData & 0b00011111) == 0x05)
	MOVLW       31
	ANDWF       _spiReadData+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_writeSingleBlock36
;mmc.c,146 :: 		UWR("Data accepted!");
	MOVLW       ?lstr5_mmc+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr5_mmc+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;mmc.c,147 :: 		break;
	GOTO        L_writeSingleBlock35
;mmc.c,148 :: 		}
L_writeSingleBlock36:
;mmc.c,149 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,150 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;mmc.c,151 :: 		}
	GOTO        L_writeSingleBlock34
L_writeSingleBlock35:
;mmc.c,152 :: 		if (count >= 10)
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_writeSingleBlock37
;mmc.c,154 :: 		UWR("Data rejected!");
	MOVLW       ?lstr6_mmc+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr6_mmc+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;mmc.c,155 :: 		}
L_writeSingleBlock37:
;mmc.c,156 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,157 :: 		while (spiReadData != 0xff)
L_writeSingleBlock38:
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_writeSingleBlock39
;mmc.c,159 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,160 :: 		}
	GOTO        L_writeSingleBlock38
L_writeSingleBlock39:
;mmc.c,161 :: 		UWR("Card is idle");
	MOVLW       ?lstr7_mmc+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr7_mmc+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;mmc.c,162 :: 		}
L_end_writeSingleBlock:
	RETURN      0
; end of _writeSingleBlock

_readSingleBlock:

;mmc.c,164 :: 		void readSingleBlock(void)
;mmc.c,168 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,169 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,170 :: 		while (spiReadData != 0xff)
L_readSingleBlock40:
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_readSingleBlock41
;mmc.c,172 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,173 :: 		UWR("Card busy!");
	MOVLW       ?lstr8_mmc+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr8_mmc+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;mmc.c,174 :: 		}
	GOTO        L_readSingleBlock40
L_readSingleBlock41:
;mmc.c,176 :: 		command(17, arg, 0x95); // read 512 bytes from byte address 0
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
;mmc.c,178 :: 		count = 0;
	CLRF        _count+0 
;mmc.c,179 :: 		while (count < 10)
L_readSingleBlock42:
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_readSingleBlock43
;mmc.c,181 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,182 :: 		if (spiReadData == 0)
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_readSingleBlock44
;mmc.c,184 :: 		UWR("CMD accepted!");
	MOVLW       ?lstr9_mmc+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr9_mmc+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;mmc.c,185 :: 		break;
	GOTO        L_readSingleBlock43
;mmc.c,186 :: 		}
L_readSingleBlock44:
;mmc.c,187 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;mmc.c,188 :: 		}
	GOTO        L_readSingleBlock42
L_readSingleBlock43:
;mmc.c,189 :: 		if (count >= 10)
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_readSingleBlock45
;mmc.c,191 :: 		UWR("CMD Rejected!");
	MOVLW       ?lstr10_mmc+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr10_mmc+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;mmc.c,192 :: 		while (1); // Trap the CPU
L_readSingleBlock46:
	GOTO        L_readSingleBlock46
;mmc.c,193 :: 		}
L_readSingleBlock45:
;mmc.c,195 :: 		while (spiReadData != 0xfe)
L_readSingleBlock48:
	MOVF        _spiReadData+0, 0 
	XORLW       254
	BTFSC       STATUS+0, 2 
	GOTO        L_readSingleBlock49
;mmc.c,197 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,198 :: 		}
	GOTO        L_readSingleBlock48
L_readSingleBlock49:
;mmc.c,199 :: 		UWR("Token received!");
	MOVLW       ?lstr11_mmc+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr11_mmc+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;mmc.c,201 :: 		for (numOfBytes = 0; numOfBytes < 512; numOfBytes++)
	CLRF        readSingleBlock_numOfBytes_L0+0 
	CLRF        readSingleBlock_numOfBytes_L0+1 
L_readSingleBlock50:
	MOVLW       2
	SUBWF       readSingleBlock_numOfBytes_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readSingleBlock125
	MOVLW       0
	SUBWF       readSingleBlock_numOfBytes_L0+0, 0 
L__readSingleBlock125:
	BTFSC       STATUS+0, 0 
	GOTO        L_readSingleBlock51
;mmc.c,203 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,204 :: 		IntToStr(spiReadData, strData);
	MOVF        _spiReadData+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVLW       0
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       readSingleBlock_strData_L0+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(readSingleBlock_strData_L0+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;mmc.c,205 :: 		UWR(strData);
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
;mmc.c,206 :: 		DACOUT = spiReadData;
	MOVF        _spiReadData+0, 0 
	MOVWF       LATB+0 
;mmc.c,207 :: 		Delay_ms(2);
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_readSingleBlock53:
	DECFSZ      R13, 1, 1
	BRA         L_readSingleBlock53
	DECFSZ      R12, 1, 1
	BRA         L_readSingleBlock53
	NOP
	NOP
;mmc.c,201 :: 		for (numOfBytes = 0; numOfBytes < 512; numOfBytes++)
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
;mmc.c,208 :: 		}
	GOTO        L_readSingleBlock50
L_readSingleBlock51:
;mmc.c,210 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,211 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,212 :: 		UWR("DONE!");
	MOVLW       ?lstr12_mmc+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr12_mmc+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;mmc.c,213 :: 		}
L_end_readSingleBlock:
	RETURN      0
; end of _readSingleBlock

_sendCMD:

;mmc.c,223 :: 		uint8_t sendCMD(uint8_t cmd, uint32_t arg)
;mmc.c,225 :: 		uint8_t retryTimes = 0;
	CLRF        sendCMD_retryTimes_L0+0 
;mmc.c,228 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,229 :: 		do
L_sendCMD54:
;mmc.c,231 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,233 :: 		while (spiReadData != 0xff);
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_sendCMD54
;mmc.c,237 :: 		spiWrite(0b01000000 | cmd);
	MOVLW       64
	IORWF       FARG_sendCMD_cmd+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,238 :: 		spiWrite((uint8_t) (arg >> 24));
	MOVF        FARG_sendCMD_arg+3, 0 
	MOVWF       R0 
	CLRF        R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,239 :: 		spiWrite((uint8_t) (arg >> 16));
	MOVF        FARG_sendCMD_arg+2, 0 
	MOVWF       R0 
	MOVF        FARG_sendCMD_arg+3, 0 
	MOVWF       R1 
	CLRF        R2 
	CLRF        R3 
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,240 :: 		spiWrite((uint8_t) (arg >> 8));
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
;mmc.c,241 :: 		spiWrite((uint8_t) arg);
	MOVF        FARG_sendCMD_arg+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,242 :: 		spiWrite(0x95); // default CRC for SPI protocol
	MOVLW       149
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,243 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,245 :: 		while (retryTimes < 10)
L_sendCMD57:
	MOVLW       10
	SUBWF       sendCMD_retryTimes_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_sendCMD58
;mmc.c,247 :: 		if (spiReadData == 0)
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_sendCMD59
;mmc.c,249 :: 		break;
	GOTO        L_sendCMD58
;mmc.c,250 :: 		}
L_sendCMD59:
;mmc.c,251 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,252 :: 		retryTimes++;
	INCF        sendCMD_retryTimes_L0+0, 1 
;mmc.c,253 :: 		}
	GOTO        L_sendCMD57
L_sendCMD58:
;mmc.c,255 :: 		if (retryTimes >= 10)
	MOVLW       10
	SUBWF       sendCMD_retryTimes_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_sendCMD60
;mmc.c,257 :: 		return 1; // command rejected
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_sendCMD
;mmc.c,258 :: 		}
L_sendCMD60:
;mmc.c,261 :: 		return 0; // command accepted
	CLRF        R0 
;mmc.c,263 :: 		}
L_end_sendCMD:
	RETURN      0
; end of _sendCMD

_readMultipleBlock:

;mmc.c,275 :: 		uint8_t readMultipleBlock(uint8_t samplingRate, uint32_t address, uint32_t length)
;mmc.c,278 :: 		volatile uint16_t sectorIndex = 0;
	CLRF        readMultipleBlock_sectorIndex_L0+0 
	CLRF        readMultipleBlock_sectorIndex_L0+1 
	CLRF        readMultipleBlock_retry_L0+0 
;mmc.c,282 :: 		do
L_readMultipleBlock62:
;mmc.c,284 :: 		if (!(sendCMD(18, address))) // read multiple block command accepted
	MOVLW       18
	MOVWF       FARG_sendCMD_cmd+0 
	MOVF        FARG_readMultipleBlock_address+0, 0 
	MOVWF       FARG_sendCMD_arg+0 
	MOVF        FARG_readMultipleBlock_address+1, 0 
	MOVWF       FARG_sendCMD_arg+1 
	MOVF        FARG_readMultipleBlock_address+2, 0 
	MOVWF       FARG_sendCMD_arg+2 
	MOVF        FARG_readMultipleBlock_address+3, 0 
	MOVWF       FARG_sendCMD_arg+3 
	CALL        _sendCMD+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock65
;mmc.c,286 :: 		error = 0;
	CLRF        readMultipleBlock_error_L0+0 
;mmc.c,287 :: 		break;
	GOTO        L_readMultipleBlock63
;mmc.c,288 :: 		}
L_readMultipleBlock65:
;mmc.c,291 :: 		error = 1;
	MOVLW       1
	MOVWF       readMultipleBlock_error_L0+0 
;mmc.c,292 :: 		retry++;
	MOVF        readMultipleBlock_retry_L0+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       readMultipleBlock_retry_L0+0 
;mmc.c,295 :: 		while (retry < 50);
	MOVLW       50
	SUBWF       readMultipleBlock_retry_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_readMultipleBlock62
L_readMultipleBlock63:
;mmc.c,297 :: 		if (!error)
	MOVF        readMultipleBlock_error_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock67
;mmc.c,299 :: 		while (sectorIndex <= length)
L_readMultipleBlock68:
	MOVLW       0
	SUBWF       FARG_readMultipleBlock_length+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readMultipleBlock128
	MOVLW       0
	SUBWF       FARG_readMultipleBlock_length+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readMultipleBlock128
	MOVF        readMultipleBlock_sectorIndex_L0+1, 0 
	SUBWF       FARG_readMultipleBlock_length+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readMultipleBlock128
	MOVF        readMultipleBlock_sectorIndex_L0+0, 0 
	SUBWF       FARG_readMultipleBlock_length+0, 0 
L__readMultipleBlock128:
	BTFSS       STATUS+0, 0 
	GOTO        L_readMultipleBlock69
;mmc.c,301 :: 		sectorIndex++;
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
;mmc.c,303 :: 		do
L_readMultipleBlock70:
;mmc.c,305 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,307 :: 		while (spiReadData != 0xfe);
	MOVF        _spiReadData+0, 0 
	XORLW       254
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock70
;mmc.c,309 :: 		for (g = 0; g < 512; g++)
	CLRF        readMultipleBlock_g_L0+0 
	CLRF        readMultipleBlock_g_L0+1 
L_readMultipleBlock73:
	MOVLW       2
	SUBWF       readMultipleBlock_g_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__readMultipleBlock129
	MOVLW       0
	SUBWF       readMultipleBlock_g_L0+0, 0 
L__readMultipleBlock129:
	BTFSC       STATUS+0, 0 
	GOTO        L_readMultipleBlock74
;mmc.c,317 :: 		TP0 = 1; /* Testpoint goes HIGH */
	BSF         LATD7_bit+0, BitPos(LATD7_bit+0) 
;mmc.c,320 :: 		DACOUT = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       LATB+0 
;mmc.c,323 :: 		switch (samplingRate)
	GOTO        L_readMultipleBlock76
;mmc.c,325 :: 		case ENC_MAXIMUM_RATE:
L_readMultipleBlock78:
;mmc.c,327 :: 		Delay_us(MMC_READ_DELAY);
	MOVLW       33
	MOVWF       R13, 0
L_readMultipleBlock79:
	DECFSZ      R13, 1, 1
	BRA         L_readMultipleBlock79
;mmc.c,328 :: 		break;
	GOTO        L_readMultipleBlock77
;mmc.c,330 :: 		case ENC_22_KSPS:
L_readMultipleBlock80:
;mmc.c,332 :: 		Delay_us(MMC_READ_DELAY + _22_KSPS);
	MOVLW       56
	MOVWF       R13, 0
L_readMultipleBlock81:
	DECFSZ      R13, 1, 1
	BRA         L_readMultipleBlock81
	NOP
;mmc.c,333 :: 		break;
	GOTO        L_readMultipleBlock77
;mmc.c,335 :: 		case ENC_16_KSPS:
L_readMultipleBlock82:
;mmc.c,337 :: 		Delay_us(MMC_READ_DELAY + _16_KSPS);
	MOVLW       84
	MOVWF       R13, 0
L_readMultipleBlock83:
	DECFSZ      R13, 1, 1
	BRA         L_readMultipleBlock83
	NOP
	NOP
;mmc.c,338 :: 		break;
	GOTO        L_readMultipleBlock77
;mmc.c,340 :: 		}
L_readMultipleBlock76:
	MOVF        FARG_readMultipleBlock_samplingRate+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_readMultipleBlock78
	MOVF        FARG_readMultipleBlock_samplingRate+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_readMultipleBlock80
	MOVF        FARG_readMultipleBlock_samplingRate+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_readMultipleBlock82
L_readMultipleBlock77:
;mmc.c,342 :: 		TP0 = 0; /* Test point goes LOW */
	BCF         LATD7_bit+0, BitPos(LATD7_bit+0) 
;mmc.c,309 :: 		for (g = 0; g < 512; g++)
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
;mmc.c,344 :: 		}
	GOTO        L_readMultipleBlock73
L_readMultipleBlock74:
;mmc.c,346 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,347 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,348 :: 		}
	GOTO        L_readMultipleBlock68
L_readMultipleBlock69:
;mmc.c,351 :: 		command(12, 0, 0x95);
	MOVLW       12
	MOVWF       FARG_command_command+0 
	CLRF        FARG_command_fourbyte_arg+0 
	CLRF        FARG_command_fourbyte_arg+1 
	CLRF        FARG_command_fourbyte_arg+2 
	CLRF        FARG_command_fourbyte_arg+3 
	MOVLW       149
	MOVWF       FARG_command_CRCbits+0 
	CALL        _command+0, 0
;mmc.c,352 :: 		count = 0;
	CLRF        _count+0 
;mmc.c,353 :: 		do
L_readMultipleBlock84:
;mmc.c,355 :: 		if (spiReadData == 0)
	MOVF        _spiReadData+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock87
;mmc.c,357 :: 		UWR("Stopped Transfer!");
	MOVLW       ?lstr13_mmc+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr13_mmc+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;mmc.c,358 :: 		break;
	GOTO        L_readMultipleBlock85
;mmc.c,359 :: 		}
L_readMultipleBlock87:
;mmc.c,360 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,361 :: 		count++;
	MOVF        _count+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _count+0 
;mmc.c,363 :: 		while (count < 10);
	MOVLW       10
	SUBWF       _count+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_readMultipleBlock84
L_readMultipleBlock85:
;mmc.c,365 :: 		do
L_readMultipleBlock88:
;mmc.c,367 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,369 :: 		while (spiReadData != 0xff);
	MOVF        _spiReadData+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_readMultipleBlock88
;mmc.c,370 :: 		UWR("Card free!");
	MOVLW       ?lstr14_mmc+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr14_mmc+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
	MOVLW       13
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
	MOVLW       10
	MOVWF       FARG_UART_Write__data+0 
	CALL        _UART_Write+0, 0
;mmc.c,371 :: 		}
L_readMultipleBlock67:
;mmc.c,372 :: 		return error;
	MOVF        readMultipleBlock_error_L0+0, 0 
	MOVWF       R0 
;mmc.c,373 :: 		}
L_end_readMultipleBlock:
	RETURN      0
; end of _readMultipleBlock

_writeInit:

;mmc.c,380 :: 		uint8_t writeInit(uint8_t writeMode, uint32_t address)
;mmc.c,384 :: 		if (writeMode == _MULTIPLE_BLOCK)
	MOVF        FARG_writeInit_writeMode+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_writeInit91
;mmc.c,386 :: 		while (retry < 50)
L_writeInit92:
	MOVLW       50
	SUBWF       writeInit_retry_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_writeInit93
;mmc.c,388 :: 		if (!(sendCMD(25, address)))
	MOVLW       25
	MOVWF       FARG_sendCMD_cmd+0 
	MOVF        FARG_writeInit_address+0, 0 
	MOVWF       FARG_sendCMD_arg+0 
	MOVF        FARG_writeInit_address+1, 0 
	MOVWF       FARG_sendCMD_arg+1 
	MOVF        FARG_writeInit_address+2, 0 
	MOVWF       FARG_sendCMD_arg+2 
	MOVF        FARG_writeInit_address+3, 0 
	MOVWF       FARG_sendCMD_arg+3 
	CALL        _sendCMD+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_writeInit94
;mmc.c,390 :: 		error = 0;
	CLRF        _error+0 
;mmc.c,391 :: 		break;
	GOTO        L_writeInit93
;mmc.c,392 :: 		}
L_writeInit94:
;mmc.c,395 :: 		error = 1;
	MOVLW       1
	MOVWF       _error+0 
;mmc.c,396 :: 		retry++;
	INCF        writeInit_retry_L0+0, 1 
;mmc.c,398 :: 		}
	GOTO        L_writeInit92
L_writeInit93:
;mmc.c,399 :: 		}
	GOTO        L_writeInit96
L_writeInit91:
;mmc.c,403 :: 		}
L_writeInit96:
;mmc.c,405 :: 		if (!error)
	MOVF        _error+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_writeInit97
;mmc.c,407 :: 		spiWrite(0xff);						/* Dummy clock */
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,408 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,409 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,410 :: 		return 0;
	CLRF        R0 
	GOTO        L_end_writeInit
;mmc.c,411 :: 		}
L_writeInit97:
;mmc.c,414 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
;mmc.c,416 :: 		}
L_end_writeInit:
	RETURN      0
; end of _writeInit

_write:

;mmc.c,421 :: 		uint8_t write(uint8_t writeMode, uint16_t *buffer)
;mmc.c,425 :: 		uint8_t error = 0;
	CLRF        write_error_L0+0 
;mmc.c,427 :: 		if (writeMode == _MULTIPLE_BLOCK)
	MOVF        FARG_write_writeMode+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_write99
;mmc.c,429 :: 		spiWrite(0b11111100);				/* Data token for CMD 25 */
	MOVLW       252
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,431 :: 		for (i = 0; i < 512; i++)
	CLRF        write_i_L0+0 
	CLRF        write_i_L0+1 
L_write100:
	MOVLW       2
	SUBWF       write_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__write132
	MOVLW       0
	SUBWF       write_i_L0+0, 0 
L__write132:
	BTFSC       STATUS+0, 0 
	GOTO        L_write101
;mmc.c,433 :: 		spiWrite(*(buffer + i));
	MOVF        write_i_L0+0, 0 
	MOVWF       R0 
	MOVF        write_i_L0+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	ADDWF       FARG_write_buffer+0, 0 
	MOVWF       FSR0 
	MOVF        R1, 0 
	ADDWFC      FARG_write_buffer+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,431 :: 		for (i = 0; i < 512; i++)
	INFSNZ      write_i_L0+0, 1 
	INCF        write_i_L0+1, 1 
;mmc.c,434 :: 		}
	GOTO        L_write100
L_write101:
;mmc.c,436 :: 		spiWrite(0xff);						/* 2-bytes CRC */
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,437 :: 		spiWrite(0xff);
	MOVLW       255
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,440 :: 		count = 0;
	CLRF        write_count_L0+0 
;mmc.c,441 :: 		while (count++ < 12)
L_write103:
	MOVF        write_count_L0+0, 0 
	MOVWF       R1 
	INCF        write_count_L0+0, 1 
	MOVLW       12
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_write104
;mmc.c,443 :: 		spiReadData = spiRead();
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _spiReadData+0 
;mmc.c,444 :: 		if ((spiReadData & 0x1f) == 0x05)
	MOVLW       31
	ANDWF       _spiReadData+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_write105
;mmc.c,446 :: 		error = 0;
	CLRF        write_error_L0+0 
;mmc.c,447 :: 		break;
	GOTO        L_write104
;mmc.c,448 :: 		}
L_write105:
;mmc.c,451 :: 		error = 1;
	MOVLW       1
	MOVWF       write_error_L0+0 
;mmc.c,453 :: 		}
	GOTO        L_write103
L_write104:
;mmc.c,455 :: 		while (spiRead() != 0xff);			/* Check if the card is busy */
L_write107:
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_write108
	GOTO        L_write107
L_write108:
;mmc.c,456 :: 		}
	GOTO        L_write109
L_write99:
;mmc.c,459 :: 		}
L_write109:
;mmc.c,461 :: 		return error;
	MOVF        write_error_L0+0, 0 
	MOVWF       R0 
;mmc.c,462 :: 		}
L_end_write:
	RETURN      0
; end of _write

_writeStop:

;mmc.c,467 :: 		void writeStop(void)
;mmc.c,469 :: 		spiWrite(0b11111101);
	MOVLW       253
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;mmc.c,470 :: 		while (spiRead() != 0xff); 				// Check if the card is busy
L_writeStop110:
	MOVLW       255
	MOVWF       FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_writeStop111
	GOTO        L_writeStop110
L_writeStop111:
;mmc.c,471 :: 		}
L_end_writeStop:
	RETURN      0
; end of _writeStop
