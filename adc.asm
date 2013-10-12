
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

_specialEventTriggerSetup:

;adc.c,22 :: 		void specialEventTriggerSetup(void)
;adc.c,25 :: 		CCP2CON = (1 << CCP2M3) | (1 << CCP2M1) | (1 << CCP2M0);
	MOVLW       11
	MOVWF       CCP2CON+0 
;adc.c,29 :: 		T3CON = (1 << T3CCP2) | (1 << T3CKPS1) | (1 << T3CKPS0);
	MOVLW       112
	MOVWF       T3CON+0 
;adc.c,32 :: 		CCPR2H = 0x3d;
	MOVLW       61
	MOVWF       CCPR2H+0 
;adc.c,33 :: 		CCPR2L = 0x09;
	MOVLW       9
	MOVWF       CCPR2L+0 
;adc.c,34 :: 		}
L_end_specialEventTriggerSetup:
	RETURN      0
; end of _specialEventTriggerSetup

_specialEventTriggerStart:

;adc.c,39 :: 		void specialEventTriggerStart(void)
;adc.c,41 :: 		T3CON |= (1 << TMR3ON);
	BSF         T3CON+0, 0 
;adc.c,42 :: 		}
L_end_specialEventTriggerStart:
	RETURN      0
; end of _specialEventTriggerStart

_adcInit:

;adc.c,51 :: 		void adcInit(void)
;adc.c,53 :: 		ADCON1 = 0x0e;
	MOVLW       14
	MOVWF       ADCON1+0 
;adc.c,54 :: 		ADCON2 = 0x2d;
	MOVLW       45
	MOVWF       ADCON2+0 
;adc.c,56 :: 		ADCON0 |= (1 << ADON);
	BSF         ADCON0+0, 0 
;adc.c,60 :: 		}
L_end_adcInit:
	RETURN      0
; end of _adcInit
