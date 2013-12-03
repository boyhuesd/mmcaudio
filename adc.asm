
_adcRead:

;adc.c,12 :: 		uint8_t adcRead(void)
;adc.c,14 :: 		GO_bit = 1; 						// Begin conversion
	BSF         GO_bit+0, BitPos(GO_bit+0) 
;adc.c,15 :: 		while (GO_bit); 					// Wait for conversion completed
L_adcRead0:
	BTFSS       GO_bit+0, BitPos(GO_bit+0) 
	GOTO        L_adcRead1
	GOTO        L_adcRead0
L_adcRead1:
;adc.c,16 :: 		return ADRESH;
	MOVF        ADRESH+0, 0 
	MOVWF       R0 
;adc.c,17 :: 		}
L_end_adcRead:
	RETURN      0
; end of _adcRead

_adcInit:

;adc.c,25 :: 		void adcInit(void)
;adc.c,27 :: 		ADCON1 = 0x0e;
	MOVLW       14
	MOVWF       ADCON1+0 
;adc.c,28 :: 		ADCON2 = 0x2d;
	MOVLW       45
	MOVWF       ADCON2+0 
;adc.c,29 :: 		ADCON0 |= (1 << ADON);
	BSF         ADCON0+0, 0 
;adc.c,30 :: 		}
L_end_adcInit:
	RETURN      0
; end of _adcInit
