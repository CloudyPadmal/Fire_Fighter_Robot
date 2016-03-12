
_init_sonar:

;sonar.h,71 :: 		void init_sonar() {
;sonar.h,74 :: 		Sonar1ECHO_TRIS = INPUT;
	BSF         TRISB+0, 0 
;sonar.h,76 :: 		Sonar2ECHO_TRIS = INPUT;
	BSF         TRISB+0, 2 
;sonar.h,78 :: 		Sonar3ECHO_TRIS = INPUT;
	BSF         TRISB+0, 4 
;sonar.h,81 :: 		Sonar1TRIG_TRIS = OUTPUT;
	BCF         TRISB+0, 1 
;sonar.h,83 :: 		Sonar2TRIG_TRIS = OUTPUT;
	BCF         TRISB+0, 3 
;sonar.h,85 :: 		Sonar3TRIG_TRIS = OUTPUT;
	BCF         TRISB+0, 5 
;sonar.h,86 :: 		}
L_end_init_sonar:
	RETURN      0
; end of _init_sonar

_Trigger_1:

;sonar.h,89 :: 		void Trigger_1() {
;sonar.h,92 :: 		Sonar1TRIG_LAT = HIGH;
	BSF         LATB+0, 1 
;sonar.h,94 :: 		Delay_us(15);
	MOVLW       4
	MOVWF       R13, 0
L_Trigger_10:
	DECFSZ      R13, 1, 1
	BRA         L_Trigger_10
	NOP
	NOP
;sonar.h,96 :: 		Sonar1TRIG_LAT = LOW;
	BCF         LATB+0, 1 
;sonar.h,97 :: 		}
L_end_Trigger_1:
	RETURN      0
; end of _Trigger_1

_Trigger_2:

;sonar.h,100 :: 		void Trigger_2() {
;sonar.h,103 :: 		Sonar2TRIG_LAT = HIGH;
	BSF         LATB+0, 3 
;sonar.h,105 :: 		Delay_us(15);
	MOVLW       4
	MOVWF       R13, 0
L_Trigger_21:
	DECFSZ      R13, 1, 1
	BRA         L_Trigger_21
	NOP
	NOP
;sonar.h,107 :: 		Sonar2TRIG_LAT = LOW;
	BCF         LATB+0, 3 
;sonar.h,108 :: 		}
L_end_Trigger_2:
	RETURN      0
; end of _Trigger_2

_Trigger_3:

;sonar.h,111 :: 		void Trigger_3() {
;sonar.h,114 :: 		Sonar3TRIG_LAT = HIGH;
	BSF         LATB+0, 5 
;sonar.h,116 :: 		Delay_us(15);
	MOVLW       4
	MOVWF       R13, 0
L_Trigger_32:
	DECFSZ      R13, 1, 1
	BRA         L_Trigger_32
	NOP
	NOP
;sonar.h,118 :: 		Sonar3TRIG_LAT = LOW;
	BCF         LATB+0, 5 
;sonar.h,119 :: 		}
L_end_Trigger_3:
	RETURN      0
; end of _Trigger_3

_check_right:

;sonar.h,123 :: 		short check_right() {
;sonar.h,126 :: 		T1CON = 0b00010000;
	MOVLW       16
	MOVWF       T1CON+0 
;sonar.h,127 :: 		right_flag = 0; j = 0;
	CLRF        _right_flag+0 
	CLRF        _j+0 
;sonar.h,129 :: 		while (j < 5) {
L_check_right3:
	MOVLW       128
	XORWF       _j+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       5
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_check_right4
;sonar.h,132 :: 		while (Sonar1ECHO_PORT == 1) {asm nop;}
L_check_right5:
	BTFSS       PORTB+0, 0 
	GOTO        L_check_right6
	NOP
	GOTO        L_check_right5
L_check_right6:
;sonar.h,135 :: 		Trigger_1();
	CALL        _Trigger_1+0, 0
;sonar.h,138 :: 		while (Sonar1ECHO_PORT == 0) {asm nop;}
L_check_right7:
	BTFSC       PORTB+0, 0 
	GOTO        L_check_right8
	NOP
	GOTO        L_check_right7
L_check_right8:
;sonar.h,141 :: 		T1CON.TMR1ON = 0;
	BCF         T1CON+0, 0 
;sonar.h,142 :: 		TMR1H = 0x00; TMR1L = 0x00;
	CLRF        TMR1H+0 
	CLRF        TMR1L+0 
;sonar.h,143 :: 		T1CON.TMR1ON = 1;
	BSF         T1CON+0, 0 
;sonar.h,145 :: 		while ((TMR1H << 8 | TMR1L) < CM40) {
L_check_right9:
	MOVF        TMR1H+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        TMR1L+0, 0 
	IORWF       R0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R3 
	MOVLW       0
	IORWF       R3, 1 
	MOVLW       4
	SUBWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__check_right179
	MOVLW       126
	SUBWF       R2, 0 
L__check_right179:
	BTFSC       STATUS+0, 0 
	GOTO        L_check_right10
;sonar.h,146 :: 		if (Sonar1ECHO_PORT == 1) {continue;}
	BTFSS       PORTB+0, 0 
	GOTO        L_check_right11
	GOTO        L_check_right9
L_check_right11:
;sonar.h,149 :: 		right_flag++;
	INCF        _right_flag+0, 1 
;sonar.h,152 :: 		}
L_check_right10:
;sonar.h,153 :: 		j++;
	INCF        _j+0, 1 
;sonar.h,154 :: 		}
	GOTO        L_check_right3
L_check_right4:
;sonar.h,156 :: 		if (right_flag > 2) {
	MOVLW       128
	XORLW       2
	MOVWF       R0 
	MOVLW       128
	XORWF       _right_flag+0, 0 
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_check_right13
;sonar.h,157 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_check_right
;sonar.h,158 :: 		} else {
L_check_right13:
;sonar.h,159 :: 		return 0;
	CLRF        R0 
;sonar.h,161 :: 		}
L_end_check_right:
	RETURN      0
; end of _check_right

_check_left:

;sonar.h,164 :: 		short check_left() {
;sonar.h,167 :: 		T1CON = 0b00010000;
	MOVLW       16
	MOVWF       T1CON+0 
;sonar.h,168 :: 		left_flag = 0; i = 0;
	CLRF        _left_flag+0 
	CLRF        _i+0 
;sonar.h,170 :: 		while (i < 5) {
L_check_left15:
	MOVLW       128
	XORWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       5
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_check_left16
;sonar.h,173 :: 		while (Sonar2ECHO_PORT == 1) {asm nop;}
L_check_left17:
	BTFSS       PORTB+0, 2 
	GOTO        L_check_left18
	NOP
	GOTO        L_check_left17
L_check_left18:
;sonar.h,176 :: 		Trigger_2();
	CALL        _Trigger_2+0, 0
;sonar.h,179 :: 		while (Sonar2ECHO_PORT == 0) {asm nop;}
L_check_left19:
	BTFSC       PORTB+0, 2 
	GOTO        L_check_left20
	NOP
	GOTO        L_check_left19
L_check_left20:
;sonar.h,182 :: 		T1CON.TMR1ON = 0;
	BCF         T1CON+0, 0 
;sonar.h,183 :: 		TMR1H = 0x00; TMR1L = 0x00;
	CLRF        TMR1H+0 
	CLRF        TMR1L+0 
;sonar.h,184 :: 		T1CON.TMR1ON = 1;
	BSF         T1CON+0, 0 
;sonar.h,186 :: 		while ((TMR1H << 8 | TMR1L) < CM40) {
L_check_left21:
	MOVF        TMR1H+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        TMR1L+0, 0 
	IORWF       R0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R3 
	MOVLW       0
	IORWF       R3, 1 
	MOVLW       4
	SUBWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__check_left181
	MOVLW       126
	SUBWF       R2, 0 
L__check_left181:
	BTFSC       STATUS+0, 0 
	GOTO        L_check_left22
;sonar.h,187 :: 		if (Sonar2ECHO_PORT == 1) {continue;}
	BTFSS       PORTB+0, 2 
	GOTO        L_check_left23
	GOTO        L_check_left21
L_check_left23:
;sonar.h,190 :: 		left_flag++;
	INCF        _left_flag+0, 1 
;sonar.h,193 :: 		}
L_check_left22:
;sonar.h,194 :: 		i++;
	INCF        _i+0, 1 
;sonar.h,195 :: 		}
	GOTO        L_check_left15
L_check_left16:
;sonar.h,197 :: 		if (left_flag > 2) {
	MOVLW       128
	XORLW       2
	MOVWF       R0 
	MOVLW       128
	XORWF       _left_flag+0, 0 
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_check_left25
;sonar.h,198 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_check_left
;sonar.h,199 :: 		} else {
L_check_left25:
;sonar.h,200 :: 		return 0;
	CLRF        R0 
;sonar.h,202 :: 		}
L_end_check_left:
	RETURN      0
; end of _check_left

_check_front:

;sonar.h,205 :: 		short check_front() {
;sonar.h,208 :: 		T1CON = 0b00010000;
	MOVLW       16
	MOVWF       T1CON+0 
;sonar.h,209 :: 		front_flag = 0; k = 0;
	CLRF        _front_flag+0 
	CLRF        _k+0 
;sonar.h,211 :: 		while (k < 5) {
L_check_front27:
	MOVLW       128
	XORWF       _k+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       5
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_check_front28
;sonar.h,214 :: 		while (Sonar3ECHO_PORT == 1) {asm nop;}
L_check_front29:
	BTFSS       PORTB+0, 4 
	GOTO        L_check_front30
	NOP
	GOTO        L_check_front29
L_check_front30:
;sonar.h,217 :: 		Trigger_3();
	CALL        _Trigger_3+0, 0
;sonar.h,220 :: 		while (Sonar3ECHO_PORT == 0) {asm nop;}
L_check_front31:
	BTFSC       PORTB+0, 4 
	GOTO        L_check_front32
	NOP
	GOTO        L_check_front31
L_check_front32:
;sonar.h,223 :: 		T1CON.TMR1ON = 0;
	BCF         T1CON+0, 0 
;sonar.h,224 :: 		TMR1H = 0x00; TMR1L = 0x00;
	CLRF        TMR1H+0 
	CLRF        TMR1L+0 
;sonar.h,225 :: 		T1CON.TMR1ON = 1;
	BSF         T1CON+0, 0 
;sonar.h,227 :: 		while ((TMR1H << 8 | TMR1L) < CM10) {
L_check_front33:
	MOVF        TMR1H+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        TMR1L+0, 0 
	IORWF       R0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R3 
	MOVLW       0
	IORWF       R3, 1 
	MOVLW       0
	SUBWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__check_front183
	MOVLW       250
	SUBWF       R2, 0 
L__check_front183:
	BTFSC       STATUS+0, 0 
	GOTO        L_check_front34
;sonar.h,228 :: 		if (Sonar3ECHO_PORT == 1) {continue;}
	BTFSS       PORTB+0, 4 
	GOTO        L_check_front35
	GOTO        L_check_front33
L_check_front35:
;sonar.h,231 :: 		front_flag++;
	INCF        _front_flag+0, 1 
;sonar.h,234 :: 		}
L_check_front34:
;sonar.h,235 :: 		k++;
	INCF        _k+0, 1 
;sonar.h,236 :: 		}
	GOTO        L_check_front27
L_check_front28:
;sonar.h,238 :: 		if (front_flag > 2) {
	MOVLW       128
	XORLW       2
	MOVWF       R0 
	MOVLW       128
	XORWF       _front_flag+0, 0 
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_check_front37
;sonar.h,239 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_check_front
;sonar.h,240 :: 		} else {
L_check_front37:
;sonar.h,241 :: 		return 0;
	CLRF        R0 
;sonar.h,243 :: 		}
L_end_check_front:
	RETURN      0
; end of _check_front

_init_led:

;led.h,40 :: 		void init_led() {
;led.h,42 :: 		TRISD.B4 = OUTPUT;
	BCF         TRISD+0, 4 
;led.h,43 :: 		TRISD.B5 = OUTPUT;
	BCF         TRISD+0, 5 
;led.h,44 :: 		TRISC.B4 = OUTPUT;
	BCF         TRISC+0, 4 
;led.h,45 :: 		TRISC.B5 = OUTPUT;
	BCF         TRISC+0, 5 
;led.h,46 :: 		TRISC.B6 = OUTPUT;
	BCF         TRISC+0, 6 
;led.h,47 :: 		TRISC.B7 = OUTPUT;
	BCF         TRISC+0, 7 
;led.h,48 :: 		TRISD.B6 = OUTPUT;
	BCF         TRISD+0, 6 
;led.h,49 :: 		TRISD.B7 = OUTPUT;
	BCF         TRISD+0, 7 
;led.h,50 :: 		}
L_end_init_led:
	RETURN      0
; end of _init_led

_test_board:

;led.h,53 :: 		void test_board() {
;led.h,55 :: 		LED1 = ON;
	BSF         LATC+0, 4 
;led.h,56 :: 		LED2 = ON;
	BSF         LATC+0, 5 
;led.h,57 :: 		LED3 = ON;
	BSF         LATC+0, 6 
;led.h,58 :: 		LED4 = ON;
	BSF         LATC+0, 7 
;led.h,59 :: 		LED5 = ON;
	BSF         LATD+0, 4 
;led.h,60 :: 		LED6 = ON;
	BSF         LATD+0, 5 
;led.h,61 :: 		LED7 = ON;
	BSF         LATD+0, 6 
;led.h,62 :: 		LED8 = ON;
	BSF         LATD+0, 7 
;led.h,63 :: 		Delay_ms(1000);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_test_board39:
	DECFSZ      R13, 1, 1
	BRA         L_test_board39
	DECFSZ      R12, 1, 1
	BRA         L_test_board39
	DECFSZ      R11, 1, 1
	BRA         L_test_board39
	NOP
	NOP
;led.h,65 :: 		LED1 = OFF;
	BCF         LATC+0, 4 
;led.h,66 :: 		LED2 = OFF;
	BCF         LATC+0, 5 
;led.h,67 :: 		LED3 = OFF;
	BCF         LATC+0, 6 
;led.h,68 :: 		LED4 = OFF;
	BCF         LATC+0, 7 
;led.h,69 :: 		LED5 = OFF;
	BCF         LATD+0, 4 
;led.h,70 :: 		LED6 = OFF;
	BCF         LATD+0, 5 
;led.h,71 :: 		LED7 = OFF;
	BCF         LATD+0, 6 
;led.h,72 :: 		LED8 = OFF;
	BCF         LATD+0, 7 
;led.h,73 :: 		Delay_ms(1000);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_test_board40:
	DECFSZ      R13, 1, 1
	BRA         L_test_board40
	DECFSZ      R12, 1, 1
	BRA         L_test_board40
	DECFSZ      R11, 1, 1
	BRA         L_test_board40
	NOP
	NOP
;led.h,74 :: 		}
L_end_test_board:
	RETURN      0
; end of _test_board

_init_sensor:

;ir.h,78 :: 		void init_sensor() {
;ir.h,81 :: 		LEDpath = OUTPUT;
	BCF         TRISD+0, 2 
;ir.h,82 :: 		SensorON = ON;
	BSF         LATD+0, 2 
;ir.h,84 :: 		ANSEL0 = 0x00;
	CLRF        ANSEL0+0 
;ir.h,85 :: 		ANSEL1 = 0;
	CLRF        ANSEL1+0 
;ir.h,86 :: 		}
L_end_init_sensor:
	RETURN      0
; end of _init_sensor

_IR_high:

;ir.h,89 :: 		void IR_high() {
;ir.h,92 :: 		SensorTRISA.B0 = OUTPUT;
	BCF         TRISA+0, 0 
;ir.h,93 :: 		SensorTRISA.B1 = OUTPUT;
	BCF         TRISA+0, 1 
;ir.h,94 :: 		SensorTRISA.B2 = OUTPUT;
	BCF         TRISA+0, 2 
;ir.h,95 :: 		SensorTRISA.B3 = OUTPUT;
	BCF         TRISA+0, 3 
;ir.h,96 :: 		SensorTRISA.B4 = OUTPUT;
	BCF         TRISA+0, 4 
;ir.h,97 :: 		SensorTRISA.B5 = OUTPUT;
	BCF         TRISA+0, 5 
;ir.h,98 :: 		SensorTRISE.B0 = OUTPUT;
	BCF         TRISE+0, 0 
;ir.h,99 :: 		SensorTRISE.B1 = OUTPUT;
	BCF         TRISE+0, 1 
;ir.h,101 :: 		SensorLATA.B0 = HIGH;
	BSF         LATA+0, 0 
;ir.h,102 :: 		SensorLATA.B1 = HIGH;
	BSF         LATA+0, 1 
;ir.h,103 :: 		SensorLATA.B2 = HIGH;
	BSF         LATA+0, 2 
;ir.h,104 :: 		SensorLATA.B3 = HIGH;
	BSF         LATA+0, 3 
;ir.h,105 :: 		SensorLATA.B4 = HIGH;
	BSF         LATA+0, 4 
;ir.h,106 :: 		SensorLATA.B5 = HIGH;
	BSF         LATA+0, 5 
;ir.h,107 :: 		SensorLATE.B0 = HIGH;
	BSF         LATE+0, 0 
;ir.h,108 :: 		SensorLATE.B1 = HIGH;
	BSF         LATE+0, 1 
;ir.h,109 :: 		}
L_end_IR_high:
	RETURN      0
; end of _IR_high

_IR_low:

;ir.h,112 :: 		void IR_low() {
;ir.h,115 :: 		SensorTRISA.B0 = INPUT;
	BSF         TRISA+0, 0 
;ir.h,116 :: 		SensorTRISA.B1 = INPUT;
	BSF         TRISA+0, 1 
;ir.h,117 :: 		SensorTRISA.B2 = INPUT;
	BSF         TRISA+0, 2 
;ir.h,118 :: 		SensorTRISA.B3 = INPUT;
	BSF         TRISA+0, 3 
;ir.h,119 :: 		SensorTRISA.B4 = INPUT;
	BSF         TRISA+0, 4 
;ir.h,120 :: 		SensorTRISA.B5 = INPUT;
	BSF         TRISA+0, 5 
;ir.h,121 :: 		SensorTRISE.B0 = INPUT;
	BSF         TRISE+0, 0 
;ir.h,122 :: 		SensorTRISE.B1 = INPUT;
	BSF         TRISE+0, 1 
;ir.h,124 :: 		SensorLATA.B0 = LOW;
	BCF         LATA+0, 0 
;ir.h,125 :: 		SensorLATA.B1 = LOW;
	BCF         LATA+0, 1 
;ir.h,126 :: 		SensorLATA.B2 = LOW;
	BCF         LATA+0, 2 
;ir.h,127 :: 		SensorLATA.B3 = LOW;
	BCF         LATA+0, 3 
;ir.h,128 :: 		SensorLATA.B4 = LOW;
	BCF         LATA+0, 4 
;ir.h,129 :: 		SensorLATA.B5 = LOW;
	BCF         LATA+0, 5 
;ir.h,130 :: 		SensorLATE.B0 = LOW;
	BCF         LATE+0, 0 
;ir.h,131 :: 		SensorLATE.B1 = LOW;
	BCF         LATE+0, 1 
;ir.h,132 :: 		}
L_end_IR_low:
	RETURN      0
; end of _IR_low

_sensor_assign:

;ir.h,135 :: 		void sensor_assign() {
;ir.h,137 :: 		sensor1 = SensorPORTA.B0;
	MOVLW       0
	BTFSC       PORTA+0, 0 
	MOVLW       1
	MOVWF       _sensor1+0 
;ir.h,138 :: 		sensor2 = SensorPORTA.B1;
	MOVLW       0
	BTFSC       PORTA+0, 1 
	MOVLW       1
	MOVWF       _sensor2+0 
;ir.h,139 :: 		sensor3 = SensorPORTA.B2;
	MOVLW       0
	BTFSC       PORTA+0, 2 
	MOVLW       1
	MOVWF       _sensor3+0 
;ir.h,140 :: 		sensor4 = SensorPORTA.B3;
	MOVLW       0
	BTFSC       PORTA+0, 3 
	MOVLW       1
	MOVWF       _sensor4+0 
;ir.h,141 :: 		sensor5 = SensorPORTA.B4;
	MOVLW       0
	BTFSC       PORTA+0, 4 
	MOVLW       1
	MOVWF       _sensor5+0 
;ir.h,142 :: 		sensor6 = SensorPORTA.B5;
	MOVLW       0
	BTFSC       PORTA+0, 5 
	MOVLW       1
	MOVWF       _sensor6+0 
;ir.h,143 :: 		sensor7 = SensorPORTE.B0;
	MOVLW       0
	BTFSC       PORTE+0, 0 
	MOVLW       1
	MOVWF       _sensor7+0 
;ir.h,144 :: 		sensor8 = SensorPORTE.B1;
	MOVLW       0
	BTFSC       PORTE+0, 1 
	MOVLW       1
	MOVWF       _sensor8+0 
;ir.h,145 :: 		}
L_end_sensor_assign:
	RETURN      0
; end of _sensor_assign

_IR_read:

;ir.h,148 :: 		void IR_read() {
;ir.h,151 :: 		IR_high();
	CALL        _IR_high+0, 0
;ir.h,153 :: 		Delay_us(15);
	MOVLW       4
	MOVWF       R13, 0
L_IR_read41:
	DECFSZ      R13, 1, 1
	BRA         L_IR_read41
	NOP
	NOP
;ir.h,156 :: 		IR_low();
	CALL        _IR_low+0, 0
;ir.h,159 :: 		Delay_us(750);
	MOVLW       249
	MOVWF       R13, 0
L_IR_read42:
	DECFSZ      R13, 1, 1
	BRA         L_IR_read42
	NOP
	NOP
;ir.h,162 :: 		sensor_assign();
	CALL        _sensor_assign+0, 0
;ir.h,163 :: 		}
L_end_IR_read:
	RETURN      0
; end of _IR_read

_position:

;ir.h,166 :: 		signed short position() {
;ir.h,189 :: 		IR_read();
	CALL        _IR_read+0, 0
;ir.h,191 :: 		pos = sensor1 * 1 + sensor2 * 3 + sensor3 * 5 + sensor4 * 7 +
	MOVF        _sensor1+0, 0 
	MOVWF       _pos+0 
	MOVLW       3
	MULWF       _sensor2+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
	MOVLW       5
	MULWF       _sensor3+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
	MOVLW       7
	MULWF       _sensor4+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
;ir.h,192 :: 		sensor5 * 11 + sensor6 * 13 + sensor7 * 15 + sensor8 * 17;
	MOVLW       11
	MULWF       _sensor5+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
	MOVLW       13
	MULWF       _sensor6+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
	MOVLW       15
	MULWF       _sensor7+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
	MOVLW       17
	MULWF       _sensor8+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
;ir.h,194 :: 		switch(pos) {
	GOTO        L_position43
;ir.h,196 :: 		case 36 : pos_val = 0; break;
L_position45:
	CLRF        _pos_val+0 
	GOTO        L_position44
;ir.h,197 :: 		case 41 : pos_val = 0; break;
L_position46:
	CLRF        _pos_val+0 
	GOTO        L_position44
;ir.h,198 :: 		case 49 : pos_val = 0; break;
L_position47:
	CLRF        _pos_val+0 
	GOTO        L_position44
;ir.h,199 :: 		case 46 : pos_val = 1; break;
L_position48:
	MOVLW       1
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,200 :: 		case 57 : pos_val = 1; break;
L_position49:
	MOVLW       1
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,201 :: 		case 56 : pos_val = 2; break;
L_position50:
	MOVLW       2
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,202 :: 		case 63 : pos_val = 2; break;
L_position51:
	MOVLW       2
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,203 :: 		case 68 : pos_val = 3; break;
L_position52:
	MOVLW       3
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,204 :: 		case 71 : pos_val = 4; break;
L_position53:
	MOVLW       4
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,205 :: 		case 26 : pos_val = -1; break;
L_position54:
	MOVLW       255
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,206 :: 		case 33 : pos_val = -1; break;
L_position55:
	MOVLW       255
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,207 :: 		case 27 : pos_val = -2; break;
L_position56:
	MOVLW       254
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,208 :: 		case 16 : pos_val = -2; break;
L_position57:
	MOVLW       254
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,209 :: 		case 40 : pos_val = -3; break;
L_position58:
	MOVLW       253
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,210 :: 		case 55 : pos_val = -4; break;
L_position59:
	MOVLW       252
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,211 :: 		default : pos_val = 0;
L_position60:
	CLRF        _pos_val+0 
;ir.h,212 :: 		}
	GOTO        L_position44
L_position43:
	MOVF        _pos+0, 0 
	XORLW       36
	BTFSC       STATUS+0, 2 
	GOTO        L_position45
	MOVF        _pos+0, 0 
	XORLW       41
	BTFSC       STATUS+0, 2 
	GOTO        L_position46
	MOVF        _pos+0, 0 
	XORLW       49
	BTFSC       STATUS+0, 2 
	GOTO        L_position47
	MOVF        _pos+0, 0 
	XORLW       46
	BTFSC       STATUS+0, 2 
	GOTO        L_position48
	MOVF        _pos+0, 0 
	XORLW       57
	BTFSC       STATUS+0, 2 
	GOTO        L_position49
	MOVF        _pos+0, 0 
	XORLW       56
	BTFSC       STATUS+0, 2 
	GOTO        L_position50
	MOVF        _pos+0, 0 
	XORLW       63
	BTFSC       STATUS+0, 2 
	GOTO        L_position51
	MOVF        _pos+0, 0 
	XORLW       68
	BTFSC       STATUS+0, 2 
	GOTO        L_position52
	MOVF        _pos+0, 0 
	XORLW       71
	BTFSC       STATUS+0, 2 
	GOTO        L_position53
	MOVF        _pos+0, 0 
	XORLW       26
	BTFSC       STATUS+0, 2 
	GOTO        L_position54
	MOVF        _pos+0, 0 
	XORLW       33
	BTFSC       STATUS+0, 2 
	GOTO        L_position55
	MOVF        _pos+0, 0 
	XORLW       27
	BTFSC       STATUS+0, 2 
	GOTO        L_position56
	MOVF        _pos+0, 0 
	XORLW       16
	BTFSC       STATUS+0, 2 
	GOTO        L_position57
	MOVF        _pos+0, 0 
	XORLW       40
	BTFSC       STATUS+0, 2 
	GOTO        L_position58
	MOVF        _pos+0, 0 
	XORLW       55
	BTFSC       STATUS+0, 2 
	GOTO        L_position59
	GOTO        L_position60
L_position44:
;ir.h,213 :: 		return pos_val;
	MOVF        _pos_val+0, 0 
	MOVWF       R0 
;ir.h,214 :: 		}
L_end_position:
	RETURN      0
; end of _position

_junction:

;ir.h,217 :: 		short junction() {
;ir.h,229 :: 		IR_read();
	CALL        _IR_read+0, 0
;ir.h,231 :: 		pos = sensor1 * 1 + sensor2 * 3 + sensor3 * 5 + sensor4 * 7 +
	MOVF        _sensor1+0, 0 
	MOVWF       _pos+0 
	MOVLW       3
	MULWF       _sensor2+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
	MOVLW       5
	MULWF       _sensor3+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
	MOVLW       7
	MULWF       _sensor4+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
;ir.h,232 :: 		sensor5 * 11 + sensor6 * 13 + sensor7 * 15 + sensor8 * 17;
	MOVLW       11
	MULWF       _sensor5+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
	MOVLW       13
	MULWF       _sensor6+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
	MOVLW       15
	MULWF       _sensor7+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
	MOVLW       17
	MULWF       _sensor8+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
;ir.h,234 :: 		switch (pos) {
	GOTO        L_junction61
;ir.h,236 :: 		case 0 : junc_val = strip; break;
L_junction63:
	MOVLW       2
	MOVWF       _junc_val+0 
	GOTO        L_junction62
;ir.h,237 :: 		case 4 : junc_val = left; break;
L_junction64:
	CLRF        _junc_val+0 
	GOTO        L_junction62
;ir.h,238 :: 		case 9 : junc_val = left; break;
L_junction65:
	CLRF        _junc_val+0 
	GOTO        L_junction62
;ir.h,239 :: 		case 32 : junc_val = right; break;
L_junction66:
	MOVLW       1
	MOVWF       _junc_val+0 
	GOTO        L_junction62
;ir.h,240 :: 		case 45 : junc_val = right; break;
L_junction67:
	MOVLW       1
	MOVWF       _junc_val+0 
	GOTO        L_junction62
;ir.h,241 :: 		case 72 : junc_val = lost; break;
L_junction68:
	MOVLW       3
	MOVWF       _junc_val+0 
	GOTO        L_junction62
;ir.h,242 :: 		default : junc_val = on_line;
L_junction69:
	MOVLW       4
	MOVWF       _junc_val+0 
;ir.h,243 :: 		}
	GOTO        L_junction62
L_junction61:
	MOVF        _pos+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_junction63
	MOVF        _pos+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_junction64
	MOVF        _pos+0, 0 
	XORLW       9
	BTFSC       STATUS+0, 2 
	GOTO        L_junction65
	MOVF        _pos+0, 0 
	XORLW       32
	BTFSC       STATUS+0, 2 
	GOTO        L_junction66
	MOVF        _pos+0, 0 
	XORLW       45
	BTFSC       STATUS+0, 2 
	GOTO        L_junction67
	MOVF        _pos+0, 0 
	XORLW       72
	BTFSC       STATUS+0, 2 
	GOTO        L_junction68
	GOTO        L_junction69
L_junction62:
;ir.h,244 :: 		return junc_val;
	MOVF        _junc_val+0, 0 
	MOVWF       R0 
;ir.h,245 :: 		}
L_end_junction:
	RETURN      0
; end of _junction

_error:

;ir.h,248 :: 		signed short error() {
;ir.h,271 :: 		IR_read();
	CALL        _IR_read+0, 0
;ir.h,273 :: 		pos = sensor1 * 1 + sensor2 * 3 + sensor3 * 5 + sensor4 * 7 +
	MOVF        _sensor1+0, 0 
	MOVWF       _pos+0 
	MOVLW       3
	MULWF       _sensor2+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
	MOVLW       5
	MULWF       _sensor3+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
	MOVLW       7
	MULWF       _sensor4+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
;ir.h,274 :: 		sensor5 * 11 + sensor6 * 13 + sensor7 * 15 + sensor8 * 17;
	MOVLW       11
	MULWF       _sensor5+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
	MOVLW       13
	MULWF       _sensor6+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
	MOVLW       15
	MULWF       _sensor7+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
	MOVLW       17
	MULWF       _sensor8+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _pos+0, 1 
;ir.h,276 :: 		switch(pos) {
	GOTO        L_error70
;ir.h,278 :: 		case 36 : err = 0; break;
L_error72:
	CLRF        _err+0 
	GOTO        L_error71
;ir.h,279 :: 		case 41 : err = 0; break;
L_error73:
	CLRF        _err+0 
	GOTO        L_error71
;ir.h,280 :: 		case 49 : err = 0; break;
L_error74:
	CLRF        _err+0 
	GOTO        L_error71
;ir.h,281 :: 		case 46 : err = -1; break;
L_error75:
	MOVLW       255
	MOVWF       _err+0 
	GOTO        L_error71
;ir.h,282 :: 		case 57 : err = -1; break;
L_error76:
	MOVLW       255
	MOVWF       _err+0 
	GOTO        L_error71
;ir.h,283 :: 		case 56 : err = -2; break;
L_error77:
	MOVLW       254
	MOVWF       _err+0 
	GOTO        L_error71
;ir.h,284 :: 		case 63 : err = -2; break;
L_error78:
	MOVLW       254
	MOVWF       _err+0 
	GOTO        L_error71
;ir.h,285 :: 		case 68 : err = -3; break;
L_error79:
	MOVLW       253
	MOVWF       _err+0 
	GOTO        L_error71
;ir.h,286 :: 		case 71 : err = -4; break;
L_error80:
	MOVLW       252
	MOVWF       _err+0 
	GOTO        L_error71
;ir.h,287 :: 		case 26 : err = 1; break;
L_error81:
	MOVLW       1
	MOVWF       _err+0 
	GOTO        L_error71
;ir.h,288 :: 		case 33 : err = 1; break;
L_error82:
	MOVLW       1
	MOVWF       _err+0 
	GOTO        L_error71
;ir.h,289 :: 		case 27 : err = 2; break;
L_error83:
	MOVLW       2
	MOVWF       _err+0 
	GOTO        L_error71
;ir.h,290 :: 		case 16 : err = 2; break;
L_error84:
	MOVLW       2
	MOVWF       _err+0 
	GOTO        L_error71
;ir.h,291 :: 		case 40 : err = 3; break;
L_error85:
	MOVLW       3
	MOVWF       _err+0 
	GOTO        L_error71
;ir.h,292 :: 		case 55 : err = 4; break;
L_error86:
	MOVLW       4
	MOVWF       _err+0 
	GOTO        L_error71
;ir.h,293 :: 		case 72 : err = 10; break;
L_error87:
	MOVLW       10
	MOVWF       _err+0 
	GOTO        L_error71
;ir.h,294 :: 		default : err = 0;
L_error88:
	CLRF        _err+0 
;ir.h,295 :: 		}
	GOTO        L_error71
L_error70:
	MOVF        _pos+0, 0 
	XORLW       36
	BTFSC       STATUS+0, 2 
	GOTO        L_error72
	MOVF        _pos+0, 0 
	XORLW       41
	BTFSC       STATUS+0, 2 
	GOTO        L_error73
	MOVF        _pos+0, 0 
	XORLW       49
	BTFSC       STATUS+0, 2 
	GOTO        L_error74
	MOVF        _pos+0, 0 
	XORLW       46
	BTFSC       STATUS+0, 2 
	GOTO        L_error75
	MOVF        _pos+0, 0 
	XORLW       57
	BTFSC       STATUS+0, 2 
	GOTO        L_error76
	MOVF        _pos+0, 0 
	XORLW       56
	BTFSC       STATUS+0, 2 
	GOTO        L_error77
	MOVF        _pos+0, 0 
	XORLW       63
	BTFSC       STATUS+0, 2 
	GOTO        L_error78
	MOVF        _pos+0, 0 
	XORLW       68
	BTFSC       STATUS+0, 2 
	GOTO        L_error79
	MOVF        _pos+0, 0 
	XORLW       71
	BTFSC       STATUS+0, 2 
	GOTO        L_error80
	MOVF        _pos+0, 0 
	XORLW       26
	BTFSC       STATUS+0, 2 
	GOTO        L_error81
	MOVF        _pos+0, 0 
	XORLW       33
	BTFSC       STATUS+0, 2 
	GOTO        L_error82
	MOVF        _pos+0, 0 
	XORLW       27
	BTFSC       STATUS+0, 2 
	GOTO        L_error83
	MOVF        _pos+0, 0 
	XORLW       16
	BTFSC       STATUS+0, 2 
	GOTO        L_error84
	MOVF        _pos+0, 0 
	XORLW       40
	BTFSC       STATUS+0, 2 
	GOTO        L_error85
	MOVF        _pos+0, 0 
	XORLW       55
	BTFSC       STATUS+0, 2 
	GOTO        L_error86
	MOVF        _pos+0, 0 
	XORLW       72
	BTFSC       STATUS+0, 2 
	GOTO        L_error87
	GOTO        L_error88
L_error71:
;ir.h,296 :: 		return err;
	MOVF        _err+0, 0 
	MOVWF       R0 
;ir.h,297 :: 		}
L_end_error:
	RETURN      0
; end of _error

_init_PWM:

;motor.h,94 :: 		void init_PWM() {
;motor.h,97 :: 		PWM1_init(PWM_f); // Left side wheel
	BCF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       199
	MOVWF       PR2+0, 0
	CALL        _PWM1_Init+0, 0
;motor.h,98 :: 		PWM2_init(PWM_f); // Right side wheel
	BCF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       199
	MOVWF       PR2+0, 0
	CALL        _PWM2_Init+0, 0
;motor.h,99 :: 		}
L_end_init_PWM:
	RETURN      0
; end of _init_PWM

_init_motor:

;motor.h,102 :: 		void init_motor() {
;motor.h,105 :: 		Motor1ATRIS = OUTPUT;
	BCF         TRISD+0, 1 
;motor.h,106 :: 		Motor1BTRIS = OUTPUT;
	BCF         TRISD+0, 0 
;motor.h,107 :: 		Motor2ATRIS = OUTPUT;
	BCF         TRISC+0, 3 
;motor.h,108 :: 		Motor2BTRIS = OUTPUT;
	BCF         TRISC+0, 0 
;motor.h,111 :: 		Motor1TRIS = OUTPUT;
	BCF         TRISC+0, 1 
;motor.h,112 :: 		Motor2TRIS = OUTPUT;
	BCF         TRISC+0, 2 
;motor.h,115 :: 		init_PWM();
	CALL        _init_PWM+0, 0
;motor.h,118 :: 		FanRENTRIS = OUTPUT;
	BCF         TRISD+0, 4 
;motor.h,119 :: 		FanLENTRIS = OUTPUT;
	BCF         TRISD+0, 5 
;motor.h,120 :: 		}
L_end_init_motor:
	RETURN      0
; end of _init_motor

_stop_motor:

;motor.h,123 :: 		void stop_motor() {
;motor.h,125 :: 		PWM1_Stop();
	CALL        _PWM1_Stop+0, 0
;motor.h,126 :: 		PWM2_Stop();
	CALL        _PWM2_Stop+0, 0
;motor.h,128 :: 		Motor1A = OFF;
	BCF         LATD+0, 1 
;motor.h,129 :: 		Motor1B = OFF;
	BCF         LATD+0, 0 
;motor.h,130 :: 		Motor2A = OFF;
	BCF         LATC+0, 3 
;motor.h,131 :: 		Motor2B = OFF;
	BCF         LATC+0, 0 
;motor.h,132 :: 		}
L_end_stop_motor:
	RETURN      0
; end of _stop_motor

_move_forth:

;motor.h,135 :: 		void move_forth() {
;motor.h,137 :: 		Motor1A = ON;
	BSF         LATD+0, 1 
;motor.h,138 :: 		Motor1B = OFF;
	BCF         LATD+0, 0 
;motor.h,139 :: 		Motor2A = ON;
	BSF         LATC+0, 3 
;motor.h,140 :: 		Motor2B = OFF;
	BCF         LATC+0, 0 
;motor.h,142 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;motor.h,143 :: 		PWM2_Start();
	CALL        _PWM2_Start+0, 0
;motor.h,145 :: 		PWM1_Set_Duty(Normal_speed);
	MOVLW       100
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;motor.h,146 :: 		PWM2_Set_Duty(Normal_speed);
	MOVLW       100
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;motor.h,147 :: 		}
L_end_move_forth:
	RETURN      0
; end of _move_forth

_turn:

;motor.h,150 :: 		void turn(short side) {
;motor.h,152 :: 		if (side == right) {
	MOVF        FARG_turn_side+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_turn89
;motor.h,154 :: 		Motor1A = OFF;
	BCF         LATD+0, 1 
;motor.h,155 :: 		Motor1B = OFF;
	BCF         LATD+0, 0 
;motor.h,156 :: 		Motor2A = ON;
	BSF         LATC+0, 3 
;motor.h,157 :: 		Motor2B = OFF;
	BCF         LATC+0, 0 
;motor.h,158 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;motor.h,159 :: 		PWM1_Set_Duty(150);
	MOVLW       150
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;motor.h,160 :: 		}
	GOTO        L_turn90
L_turn89:
;motor.h,161 :: 		else if (side == left) {
	MOVF        FARG_turn_side+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_turn91
;motor.h,163 :: 		Motor1A = ON;
	BSF         LATD+0, 1 
;motor.h,164 :: 		Motor1B = OFF;
	BCF         LATD+0, 0 
;motor.h,165 :: 		Motor2A = OFF;
	BCF         LATC+0, 3 
;motor.h,166 :: 		Motor2B = OFF;
	BCF         LATC+0, 0 
;motor.h,167 :: 		PWM2_Start();
	CALL        _PWM2_Start+0, 0
;motor.h,168 :: 		PWM2_Set_Duty(150);
	MOVLW       150
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;motor.h,169 :: 		}
L_turn91:
L_turn90:
;motor.h,170 :: 		}
L_end_turn:
	RETURN      0
; end of _turn

_rotate:

;motor.h,173 :: 		void rotate(short side) {
;motor.h,175 :: 		if (side == right) {
	MOVF        FARG_rotate_side+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_rotate92
;motor.h,176 :: 		Motor1A = OFF;
	BCF         LATD+0, 1 
;motor.h,177 :: 		Motor1B = ON;
	BSF         LATD+0, 0 
;motor.h,178 :: 		Motor2A = ON;
	BSF         LATC+0, 3 
;motor.h,179 :: 		Motor2B = OFF;
	BCF         LATC+0, 0 
;motor.h,180 :: 		}
	GOTO        L_rotate93
L_rotate92:
;motor.h,181 :: 		else if (side == left) {
	MOVF        FARG_rotate_side+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_rotate94
;motor.h,182 :: 		Motor1A = ON;
	BSF         LATD+0, 1 
;motor.h,183 :: 		Motor1B = OFF;
	BCF         LATD+0, 0 
;motor.h,184 :: 		Motor2A = OFF;
	BCF         LATC+0, 3 
;motor.h,185 :: 		Motor2B = ON;
	BSF         LATC+0, 0 
;motor.h,186 :: 		}
L_rotate94:
L_rotate93:
;motor.h,188 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;motor.h,189 :: 		PWM2_Start();
	CALL        _PWM2_Start+0, 0
;motor.h,191 :: 		PWM1_Set_Duty(150);
	MOVLW       150
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;motor.h,192 :: 		PWM2_Set_Duty(150);
	MOVLW       150
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;motor.h,193 :: 		}
L_end_rotate:
	RETURN      0
; end of _rotate

_reverse:

;motor.h,196 :: 		void reverse() {
;motor.h,198 :: 		Motor1A = OFF;
	BCF         LATD+0, 1 
;motor.h,199 :: 		Motor1B = ON;
	BSF         LATD+0, 0 
;motor.h,200 :: 		Motor2A = OFF;
	BCF         LATC+0, 3 
;motor.h,201 :: 		Motor2B = ON;
	BSF         LATC+0, 0 
;motor.h,203 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;motor.h,204 :: 		PWM2_Start();
	CALL        _PWM2_Start+0, 0
;motor.h,206 :: 		PWM1_Set_Duty(Reverse_speed);
	MOVLW       115
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;motor.h,207 :: 		PWM2_Set_Duty(Reverse_speed);
	MOVLW       115
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;motor.h,208 :: 		}
L_end_reverse:
	RETURN      0
; end of _reverse

_fan_job:

;motor.h,211 :: 		void fan_job(short side) {
;motor.h,213 :: 		switch (side) {
	GOTO        L_fan_job95
;motor.h,215 :: 		case 0 :
L_fan_job97:
;motor.h,216 :: 		FanL = ON;
	BSF         LATD+0, 5 
;motor.h,217 :: 		FanR = OFF;
	BCF         LATD+0, 4 
;motor.h,218 :: 		Delay_ms(4000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_fan_job98:
	DECFSZ      R13, 1, 1
	BRA         L_fan_job98
	DECFSZ      R12, 1, 1
	BRA         L_fan_job98
	DECFSZ      R11, 1, 1
	BRA         L_fan_job98
	NOP
;motor.h,219 :: 		FanL = OFF;
	BCF         LATD+0, 5 
;motor.h,220 :: 		break;
	GOTO        L_fan_job96
;motor.h,222 :: 		case 1 :
L_fan_job99:
;motor.h,223 :: 		FanL = OFF;
	BCF         LATD+0, 5 
;motor.h,224 :: 		FanR = ON;
	BSF         LATD+0, 4 
;motor.h,225 :: 		Delay_ms(4000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_fan_job100:
	DECFSZ      R13, 1, 1
	BRA         L_fan_job100
	DECFSZ      R12, 1, 1
	BRA         L_fan_job100
	DECFSZ      R11, 1, 1
	BRA         L_fan_job100
	NOP
;motor.h,226 :: 		FanR = OFF;
	BCF         LATD+0, 4 
;motor.h,227 :: 		break;
	GOTO        L_fan_job96
;motor.h,229 :: 		case 2 :
L_fan_job101:
;motor.h,230 :: 		FanL = ON;
	BSF         LATD+0, 5 
;motor.h,231 :: 		FanR = ON;
	BSF         LATD+0, 4 
;motor.h,232 :: 		Delay_ms(4000);
	MOVLW       21
	MOVWF       R11, 0
	MOVLW       75
	MOVWF       R12, 0
	MOVLW       190
	MOVWF       R13, 0
L_fan_job102:
	DECFSZ      R13, 1, 1
	BRA         L_fan_job102
	DECFSZ      R12, 1, 1
	BRA         L_fan_job102
	DECFSZ      R11, 1, 1
	BRA         L_fan_job102
	NOP
;motor.h,233 :: 		FanR = OFF;
	BCF         LATD+0, 4 
;motor.h,234 :: 		FanL = OFF;
	BCF         LATD+0, 5 
;motor.h,235 :: 		break;
	GOTO        L_fan_job96
;motor.h,237 :: 		default :
L_fan_job103:
;motor.h,238 :: 		FanR = OFF;
	BCF         LATD+0, 4 
;motor.h,239 :: 		FanL = OFF;
	BCF         LATD+0, 5 
;motor.h,240 :: 		break;
	GOTO        L_fan_job96
;motor.h,241 :: 		}
L_fan_job95:
	MOVF        FARG_fan_job_side+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_fan_job97
	MOVF        FARG_fan_job_side+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_fan_job99
	MOVF        FARG_fan_job_side+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_fan_job101
	GOTO        L_fan_job103
L_fan_job96:
;motor.h,242 :: 		}
L_end_fan_job:
	RETURN      0
; end of _fan_job

_accelerate:

;motor.h,245 :: 		void accelerate() {
;motor.h,247 :: 		Motor1A = ON;
	BSF         LATD+0, 1 
;motor.h,248 :: 		Motor1B = OFF;
	BCF         LATD+0, 0 
;motor.h,249 :: 		Motor2A = ON;
	BSF         LATC+0, 3 
;motor.h,250 :: 		Motor2B = OFF;
	BCF         LATC+0, 0 
;motor.h,252 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;motor.h,253 :: 		PWM2_Start();
	CALL        _PWM2_Start+0, 0
;motor.h,255 :: 		PWM1_Set_Duty(170);
	MOVLW       170
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;motor.h,256 :: 		PWM2_Set_Duty(170);
	MOVLW       170
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;motor.h,258 :: 		Delay_ms(10);
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_accelerate104:
	DECFSZ      R13, 1, 1
	BRA         L_accelerate104
	DECFSZ      R12, 1, 1
	BRA         L_accelerate104
	NOP
	NOP
;motor.h,259 :: 		}
L_end_accelerate:
	RETURN      0
; end of _accelerate

_move_pid:

;motor.h,261 :: 		void move_pid (short er) {
;motor.h,263 :: 		short p, d, kp=10, kd=0, correction;
	MOVLW       10
	MOVWF       move_pid_kp_L0+0 
	CLRF        move_pid_kd_L0+0 
;motor.h,264 :: 		p = er * kp;
	MOVF        FARG_move_pid_er+0, 0 
	MULWF       move_pid_kp_L0+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       move_pid_p_L0+0 
;motor.h,266 :: 		correction = p + (er - perr)*kd;
	MOVF        _perr+0, 0 
	SUBWF       FARG_move_pid_er+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MULWF       move_pid_kd_L0+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       move_pid_p_L0+0, 0 
	MOVWF       move_pid_correction_L0+0 
;motor.h,267 :: 		perr = er;
	MOVF        FARG_move_pid_er+0, 0 
	MOVWF       _perr+0 
;motor.h,269 :: 		Motor1A = ON;
	BSF         LATD+0, 1 
;motor.h,270 :: 		Motor1B = OFF;
	BCF         LATD+0, 0 
;motor.h,271 :: 		Motor2A = ON;
	BSF         LATC+0, 3 
;motor.h,272 :: 		Motor2B = OFF;
	BCF         LATC+0, 0 
;motor.h,274 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;motor.h,275 :: 		PWM2_Start();
	CALL        _PWM2_Start+0, 0
;motor.h,277 :: 		PWM1_Set_Duty(108 - correction);
	MOVF        move_pid_correction_L0+0, 0 
	SUBLW       108
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;motor.h,278 :: 		PWM2_Set_Duty(108 + correction);
	MOVF        move_pid_correction_L0+0, 0 
	ADDLW       108
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;motor.h,279 :: 		}
L_end_move_pid:
	RETURN      0
; end of _move_pid

_move:

;mains.h,48 :: 		void move() {
;mains.h,51 :: 		PValve = position();
	CALL        _position+0, 0
	MOVF        R0, 0 
	MOVWF       _PValve+0 
;mains.h,53 :: 		move_forth();
	CALL        _move_forth+0, 0
;mains.h,56 :: 		switch (PValve) {
	GOTO        L_move105
;mains.h,58 :: 		case 4 :
L_move107:
;mains.h,59 :: 		turn(right); Delay_ms(25);
	MOVLW       1
	MOVWF       FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       33
	MOVWF       R12, 0
	MOVLW       118
	MOVWF       R13, 0
L_move108:
	DECFSZ      R13, 1, 1
	BRA         L_move108
	DECFSZ      R12, 1, 1
	BRA         L_move108
	NOP
;mains.h,60 :: 		break;
	GOTO        L_move106
;mains.h,61 :: 		case -4 :
L_move109:
;mains.h,62 :: 		turn(left); Delay_ms(25);
	CLRF        FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       33
	MOVWF       R12, 0
	MOVLW       118
	MOVWF       R13, 0
L_move110:
	DECFSZ      R13, 1, 1
	BRA         L_move110
	DECFSZ      R12, 1, 1
	BRA         L_move110
	NOP
;mains.h,63 :: 		break;
	GOTO        L_move106
;mains.h,64 :: 		case 3 :
L_move111:
;mains.h,65 :: 		turn(right); Delay_ms(25);
	MOVLW       1
	MOVWF       FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       33
	MOVWF       R12, 0
	MOVLW       118
	MOVWF       R13, 0
L_move112:
	DECFSZ      R13, 1, 1
	BRA         L_move112
	DECFSZ      R12, 1, 1
	BRA         L_move112
	NOP
;mains.h,66 :: 		break;
	GOTO        L_move106
;mains.h,67 :: 		case -3 :
L_move113:
;mains.h,68 :: 		turn(left); Delay_ms(25);
	CLRF        FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       33
	MOVWF       R12, 0
	MOVLW       118
	MOVWF       R13, 0
L_move114:
	DECFSZ      R13, 1, 1
	BRA         L_move114
	DECFSZ      R12, 1, 1
	BRA         L_move114
	NOP
;mains.h,69 :: 		break;
	GOTO        L_move106
;mains.h,70 :: 		case 2 :
L_move115:
;mains.h,71 :: 		turn(right); Delay_ms(29);
	MOVLW       1
	MOVWF       FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       168
	MOVWF       R13, 0
L_move116:
	DECFSZ      R13, 1, 1
	BRA         L_move116
	DECFSZ      R12, 1, 1
	BRA         L_move116
	NOP
;mains.h,72 :: 		break;
	GOTO        L_move106
;mains.h,73 :: 		case -2 :
L_move117:
;mains.h,74 :: 		turn(left); Delay_ms(29);
	CLRF        FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       168
	MOVWF       R13, 0
L_move118:
	DECFSZ      R13, 1, 1
	BRA         L_move118
	DECFSZ      R12, 1, 1
	BRA         L_move118
	NOP
;mains.h,75 :: 		break;
	GOTO        L_move106
;mains.h,76 :: 		case 1 :
L_move119:
;mains.h,77 :: 		turn(right); Delay_ms(29);
	MOVLW       1
	MOVWF       FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       168
	MOVWF       R13, 0
L_move120:
	DECFSZ      R13, 1, 1
	BRA         L_move120
	DECFSZ      R12, 1, 1
	BRA         L_move120
	NOP
;mains.h,78 :: 		break;
	GOTO        L_move106
;mains.h,79 :: 		case -1 :
L_move121:
;mains.h,80 :: 		turn(left); Delay_ms(29);
	CLRF        FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       168
	MOVWF       R13, 0
L_move122:
	DECFSZ      R13, 1, 1
	BRA         L_move122
	DECFSZ      R12, 1, 1
	BRA         L_move122
	NOP
;mains.h,81 :: 		break;
	GOTO        L_move106
;mains.h,82 :: 		default :
L_move123:
;mains.h,83 :: 		break;
	GOTO        L_move106
;mains.h,84 :: 		}
L_move105:
	MOVF        _PValve+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_move107
	MOVF        _PValve+0, 0 
	XORLW       252
	BTFSC       STATUS+0, 2 
	GOTO        L_move109
	MOVF        _PValve+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_move111
	MOVF        _PValve+0, 0 
	XORLW       253
	BTFSC       STATUS+0, 2 
	GOTO        L_move113
	MOVF        _PValve+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_move115
	MOVF        _PValve+0, 0 
	XORLW       254
	BTFSC       STATUS+0, 2 
	GOTO        L_move117
	MOVF        _PValve+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_move119
	MOVF        _PValve+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_move121
	GOTO        L_move123
L_move106:
;mains.h,85 :: 		}
L_end_move:
	RETURN      0
; end of _move

_RrandLl:

;mains.h,88 :: 		void RrandLl() {
;mains.h,91 :: 		fan_job(both);
	MOVLW       2
	MOVWF       FARG_fan_job_side+0 
	CALL        _fan_job+0, 0
;mains.h,93 :: 		accelerate();
	CALL        _accelerate+0, 0
;mains.h,94 :: 		}
L_end_RrandLl:
	RETURN      0
; end of _RrandLl

_Rronly:

;mains.h,97 :: 		void Rronly() {
;mains.h,100 :: 		fan_job(right);
	MOVLW       1
	MOVWF       FARG_fan_job_side+0 
	CALL        _fan_job+0, 0
;mains.h,102 :: 		accelerate();
	CALL        _accelerate+0, 0
;mains.h,103 :: 		}
L_end_Rronly:
	RETURN      0
; end of _Rronly

_Llonly:

;mains.h,106 :: 		void Llonly() {
;mains.h,109 :: 		fan_job(left);
	CLRF        FARG_fan_job_side+0 
	CALL        _fan_job+0, 0
;mains.h,111 :: 		accelerate();
	CALL        _accelerate+0, 0
;mains.h,112 :: 		}
L_end_Llonly:
	RETURN      0
; end of _Llonly

_right_junc:

;mains.h,115 :: 		void right_junc() {
;mains.h,118 :: 		stop_motor();
	CALL        _stop_motor+0, 0
;mains.h,120 :: 		Rr = check_right(); Delay_ms(100);
	CALL        _check_right+0, 0
	MOVF        R0, 0 
	MOVWF       _Rr+0 
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_right_junc124:
	DECFSZ      R13, 1, 1
	BRA         L_right_junc124
	DECFSZ      R12, 1, 1
	BRA         L_right_junc124
	NOP
	NOP
;mains.h,122 :: 		Ll = check_left(); Delay_ms(100);
	CALL        _check_left+0, 0
	MOVF        R0, 0 
	MOVWF       _Ll+0 
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_right_junc125:
	DECFSZ      R13, 1, 1
	BRA         L_right_junc125
	DECFSZ      R12, 1, 1
	BRA         L_right_junc125
	NOP
	NOP
;mains.h,124 :: 		if (Rr) {
	MOVF        _Rr+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_right_junc126
;mains.h,126 :: 		fan_job(right);
	MOVLW       1
	MOVWF       FARG_fan_job_side+0 
	CALL        _fan_job+0, 0
;mains.h,127 :: 		}
L_right_junc126:
;mains.h,129 :: 		if (Ll) {
	MOVF        _Ll+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_right_junc127
;mains.h,131 :: 		fan_job(left);
	CLRF        FARG_fan_job_side+0 
	CALL        _fan_job+0, 0
;mains.h,132 :: 		}
L_right_junc127:
;mains.h,134 :: 		if (Rr && Ll) {
	MOVF        _Rr+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_right_junc130
	MOVF        _Ll+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_right_junc130
L__right_junc169:
;mains.h,135 :: 		fan_job(both);
	MOVLW       2
	MOVWF       FARG_fan_job_side+0 
	CALL        _fan_job+0, 0
;mains.h,136 :: 		}
L_right_junc130:
;mains.h,138 :: 		accelerate();
	CALL        _accelerate+0, 0
;mains.h,139 :: 		}
L_end_right_junc:
	RETURN      0
; end of _right_junc

_left_junc:

;mains.h,142 :: 		void left_junc() {
;mains.h,145 :: 		stop_motor();
	CALL        _stop_motor+0, 0
;mains.h,147 :: 		Ll = check_left(); Delay_ms(100);
	CALL        _check_left+0, 0
	MOVF        R0, 0 
	MOVWF       _Ll+0 
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_left_junc131:
	DECFSZ      R13, 1, 1
	BRA         L_left_junc131
	DECFSZ      R12, 1, 1
	BRA         L_left_junc131
	NOP
	NOP
;mains.h,149 :: 		Rr = check_right(); Delay_ms(100);
	CALL        _check_right+0, 0
	MOVF        R0, 0 
	MOVWF       _Rr+0 
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_left_junc132:
	DECFSZ      R13, 1, 1
	BRA         L_left_junc132
	DECFSZ      R12, 1, 1
	BRA         L_left_junc132
	NOP
	NOP
;mains.h,151 :: 		if (Ll) {
	MOVF        _Ll+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_left_junc133
;mains.h,153 :: 		fan_job(left);
	CLRF        FARG_fan_job_side+0 
	CALL        _fan_job+0, 0
;mains.h,154 :: 		}
L_left_junc133:
;mains.h,156 :: 		if (Rr) {
	MOVF        _Rr+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_left_junc134
;mains.h,158 :: 		fan_job(right);
	MOVLW       1
	MOVWF       FARG_fan_job_side+0 
	CALL        _fan_job+0, 0
;mains.h,159 :: 		}
L_left_junc134:
;mains.h,161 :: 		if (Rr && Ll) {
	MOVF        _Rr+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_left_junc137
	MOVF        _Ll+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_left_junc137
L__left_junc170:
;mains.h,162 :: 		fan_job(both);
	MOVLW       2
	MOVWF       FARG_fan_job_side+0 
	CALL        _fan_job+0, 0
;mains.h,163 :: 		}
L_left_junc137:
;mains.h,165 :: 		accelerate();
	CALL        _accelerate+0, 0
;mains.h,166 :: 		}
L_end_left_junc:
	RETURN      0
; end of _left_junc

_init_main:

;FireFighter.c,16 :: 		void init_main() {
;FireFighter.c,18 :: 		init_sensor();
	CALL        _init_sensor+0, 0
;FireFighter.c,19 :: 		init_motor();
	CALL        _init_motor+0, 0
;FireFighter.c,20 :: 		init_sonar();
	CALL        _init_sonar+0, 0
;FireFighter.c,21 :: 		}
L_end_init_main:
	RETURN      0
; end of _init_main

_main:

;FireFighter.c,24 :: 		void main() {
;FireFighter.c,27 :: 		init_main();
	CALL        _init_main+0, 0
;FireFighter.c,28 :: 		first_line = 1;
	MOVLW       1
	MOVWF       _first_line+0 
;FireFighter.c,29 :: 		perr = 0;
	CLRF        _perr+0 
;FireFighter.c,30 :: 		accelerate();
	CALL        _accelerate+0, 0
;FireFighter.c,32 :: 		while (ON) {
L_main138:
;FireFighter.c,35 :: 		while (first_line) {
L_main140:
	MOVF        _first_line+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main141
;FireFighter.c,36 :: 		move();
	CALL        _move+0, 0
;FireFighter.c,37 :: 		junc_value = junction();
	CALL        _junction+0, 0
	MOVF        R0, 0 
	MOVWF       _junc_value+0 
;FireFighter.c,38 :: 		if (junc_value == strip) {
	MOVF        R0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main142
;FireFighter.c,39 :: 		move();
	CALL        _move+0, 0
;FireFighter.c,40 :: 		Delay_ms(300);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       134
	MOVWF       R12, 0
	MOVLW       153
	MOVWF       R13, 0
L_main143:
	DECFSZ      R13, 1, 1
	BRA         L_main143
	DECFSZ      R12, 1, 1
	BRA         L_main143
	DECFSZ      R11, 1, 1
	BRA         L_main143
;FireFighter.c,41 :: 		first_line = 0;
	CLRF        _first_line+0 
;FireFighter.c,42 :: 		}
L_main142:
;FireFighter.c,43 :: 		}
	GOTO        L_main140
L_main141:
;FireFighter.c,45 :: 		err_value = error();
	CALL        _error+0, 0
	MOVF        R0, 0 
	MOVWF       _err_value+0 
;FireFighter.c,46 :: 		if (err_value == 10) {
	MOVF        R0, 0 
	XORLW       10
	BTFSS       STATUS+0, 2 
	GOTO        L_main144
;FireFighter.c,47 :: 		if (perr > 0) {
	MOVLW       128
	XORLW       0
	MOVWF       R0 
	MOVLW       128
	XORWF       _perr+0, 0 
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main145
;FireFighter.c,48 :: 		err_value = 5;
	MOVLW       5
	MOVWF       _err_value+0 
;FireFighter.c,49 :: 		} else {
	GOTO        L_main146
L_main145:
;FireFighter.c,50 :: 		err_value = -5;
	MOVLW       251
	MOVWF       _err_value+0 
;FireFighter.c,51 :: 		}
L_main146:
;FireFighter.c,52 :: 		}
L_main144:
;FireFighter.c,54 :: 		junc_value = junction();
	CALL        _junction+0, 0
	MOVF        R0, 0 
	MOVWF       _junc_value+0 
;FireFighter.c,57 :: 		if (junc_value == on_line) {
	MOVF        R0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_main147
;FireFighter.c,58 :: 		move_pid(err_value);
	MOVF        _err_value+0, 0 
	MOVWF       FARG_move_pid_er+0 
	CALL        _move_pid+0, 0
;FireFighter.c,59 :: 		}
	GOTO        L_main148
L_main147:
;FireFighter.c,62 :: 		else if (junc_value == right) {
	MOVF        _junc_value+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main149
;FireFighter.c,63 :: 		right_junc();
	CALL        _right_junc+0, 0
;FireFighter.c,64 :: 		}
	GOTO        L_main150
L_main149:
;FireFighter.c,67 :: 		else if (junc_value == left) {
	MOVF        _junc_value+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main151
;FireFighter.c,68 :: 		left_junc();
	CALL        _left_junc+0, 0
;FireFighter.c,69 :: 		}
	GOTO        L_main152
L_main151:
;FireFighter.c,72 :: 		else if (junc_value == strip) {
	MOVF        _junc_value+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main153
;FireFighter.c,75 :: 		stop_motor(); Delay_ms(15);
	CALL        _stop_motor+0, 0
	MOVLW       20
	MOVWF       R12, 0
	MOVLW       121
	MOVWF       R13, 0
L_main154:
	DECFSZ      R13, 1, 1
	BRA         L_main154
	DECFSZ      R12, 1, 1
	BRA         L_main154
	NOP
	NOP
;FireFighter.c,77 :: 		Ll = check_left(); Delay_ms(200);
	CALL        _check_left+0, 0
	MOVF        R0, 0 
	MOVWF       _Ll+0 
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main155:
	DECFSZ      R13, 1, 1
	BRA         L_main155
	DECFSZ      R12, 1, 1
	BRA         L_main155
	DECFSZ      R11, 1, 1
	BRA         L_main155
	NOP
;FireFighter.c,79 :: 		Rr = check_right(); Delay_ms(200);
	CALL        _check_right+0, 0
	MOVF        R0, 0 
	MOVWF       _Rr+0 
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main156:
	DECFSZ      R13, 1, 1
	BRA         L_main156
	DECFSZ      R12, 1, 1
	BRA         L_main156
	DECFSZ      R11, 1, 1
	BRA         L_main156
	NOP
;FireFighter.c,82 :: 		if (Rr && Ll) {
	MOVF        _Rr+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main159
	MOVF        _Ll+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main159
L__main173:
;FireFighter.c,83 :: 		RrandLl();
	CALL        _RrandLl+0, 0
;FireFighter.c,84 :: 		}
L_main159:
;FireFighter.c,85 :: 		if (Rr && !Ll) {
	MOVF        _Rr+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main162
	MOVF        _Ll+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main162
L__main172:
;FireFighter.c,86 :: 		Rronly();
	CALL        _Rronly+0, 0
;FireFighter.c,87 :: 		}
L_main162:
;FireFighter.c,88 :: 		if (!Rr && Ll) {
	MOVF        _Rr+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main165
	MOVF        _Ll+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main165
L__main171:
;FireFighter.c,89 :: 		Llonly();
	CALL        _Llonly+0, 0
;FireFighter.c,90 :: 		}
L_main165:
;FireFighter.c,91 :: 		}
	GOTO        L_main166
L_main153:
;FireFighter.c,93 :: 		else if (junc_value == lost) {
	MOVF        _junc_value+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main167
;FireFighter.c,96 :: 		Delay_ms(100);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main168:
	DECFSZ      R13, 1, 1
	BRA         L_main168
	DECFSZ      R12, 1, 1
	BRA         L_main168
	NOP
	NOP
;FireFighter.c,98 :: 		stop_motor();
	CALL        _stop_motor+0, 0
;FireFighter.c,99 :: 		}
L_main167:
L_main166:
L_main152:
L_main150:
L_main148:
;FireFighter.c,101 :: 		}
	GOTO        L_main138
;FireFighter.c,102 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
