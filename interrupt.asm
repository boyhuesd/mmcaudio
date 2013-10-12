
_interrupt:

;interrupt.c,13 :: 		void interrupt(void)
;interrupt.c,15 :: 		if (PIR1 & (1 << ADIF))
	BTFSS       PIR1+0, 6 
	GOTO        L_interrupt0
;interrupt.c,18 :: 		*(ptr + (ptrIndex++)) = ADRESH;
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
;interrupt.c,21 :: 		if (ptrIndex == 512)
	MOVF        _ptrIndex+1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt6
	MOVLW       0
	XORWF       _ptrIndex+0, 0 
L__interrupt6:
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt1
;interrupt.c,23 :: 		bufferFull = 1;
	MOVLW       1
	MOVWF       _bufferFull+0 
;interrupt.c,24 :: 		if (currentBuffer == 0)
	MOVF        _currentBuffer+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt2
;interrupt.c,26 :: 		ptr = buffer1;
	MOVLW       _buffer1+0
	MOVWF       _ptr+0 
	MOVLW       hi_addr(_buffer1+0)
	MOVWF       _ptr+1 
;interrupt.c,27 :: 		currentBuffer = 1;
	MOVLW       1
	MOVWF       _currentBuffer+0 
;interrupt.c,28 :: 		}
	GOTO        L_interrupt3
L_interrupt2:
;interrupt.c,31 :: 		ptr = buffer0;
	MOVLW       _buffer0+0
	MOVWF       _ptr+0 
	MOVLW       hi_addr(_buffer0+0)
	MOVWF       _ptr+1 
;interrupt.c,32 :: 		currentBuffer = 0;
	CLRF        _currentBuffer+0 
;interrupt.c,33 :: 		}
L_interrupt3:
;interrupt.c,34 :: 		}
L_interrupt1:
;interrupt.c,35 :: 		}
L_interrupt0:
;interrupt.c,36 :: 		}
L_end_interrupt:
L__interrupt5:
	RETFIE      1
; end of _interrupt
