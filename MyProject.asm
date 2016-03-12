
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
	GOTO        L__check_right149
	MOVLW       126
	SUBWF       R2, 0 
L__check_right149:
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
	GOTO        L__check_left151
	MOVLW       126
	SUBWF       R2, 0 
L__check_left151:
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
	GOTO        L__check_front153
	MOVLW       250
	SUBWF       R2, 0 
L__check_front153:
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

;ir.h,77 :: 		void init_sensor() {
;ir.h,80 :: 		LEDpath = OUTPUT;
	BCF         TRISD+0, 2 
;ir.h,81 :: 		SensorON = ON;
	BSF         LATD+0, 2 
;ir.h,83 :: 		ANSEL0 = 0x00;
	CLRF        ANSEL0+0 
;ir.h,84 :: 		ANSEL1 = 0;
	CLRF        ANSEL1+0 
;ir.h,85 :: 		}
L_end_init_sensor:
	RETURN      0
; end of _init_sensor

_IR_high:

;ir.h,88 :: 		void IR_high() {
;ir.h,91 :: 		SensorTRISA.B0 = OUTPUT;
	BCF         TRISA+0, 0 
;ir.h,92 :: 		SensorTRISA.B1 = OUTPUT;
	BCF         TRISA+0, 1 
;ir.h,93 :: 		SensorTRISA.B2 = OUTPUT;
	BCF         TRISA+0, 2 
;ir.h,94 :: 		SensorTRISA.B3 = OUTPUT;
	BCF         TRISA+0, 3 
;ir.h,95 :: 		SensorTRISA.B4 = OUTPUT;
	BCF         TRISA+0, 4 
;ir.h,96 :: 		SensorTRISA.B5 = OUTPUT;
	BCF         TRISA+0, 5 
;ir.h,97 :: 		SensorTRISE.B0 = OUTPUT;
	BCF         TRISE+0, 0 
;ir.h,98 :: 		SensorTRISE.B1 = OUTPUT;
	BCF         TRISE+0, 1 
;ir.h,100 :: 		SensorLATA.B0 = HIGH;
	BSF         LATA+0, 0 
;ir.h,101 :: 		SensorLATA.B1 = HIGH;
	BSF         LATA+0, 1 
;ir.h,102 :: 		SensorLATA.B2 = HIGH;
	BSF         LATA+0, 2 
;ir.h,103 :: 		SensorLATA.B3 = HIGH;
	BSF         LATA+0, 3 
;ir.h,104 :: 		SensorLATA.B4 = HIGH;
	BSF         LATA+0, 4 
;ir.h,105 :: 		SensorLATA.B5 = HIGH;
	BSF         LATA+0, 5 
;ir.h,106 :: 		SensorLATE.B0 = HIGH;
	BSF         LATE+0, 0 
;ir.h,107 :: 		SensorLATE.B1 = HIGH;
	BSF         LATE+0, 1 
;ir.h,108 :: 		}
L_end_IR_high:
	RETURN      0
; end of _IR_high

_IR_low:

;ir.h,111 :: 		void IR_low() {
;ir.h,114 :: 		SensorTRISA.B0 = INPUT;
	BSF         TRISA+0, 0 
;ir.h,115 :: 		SensorTRISA.B1 = INPUT;
	BSF         TRISA+0, 1 
;ir.h,116 :: 		SensorTRISA.B2 = INPUT;
	BSF         TRISA+0, 2 
;ir.h,117 :: 		SensorTRISA.B3 = INPUT;
	BSF         TRISA+0, 3 
;ir.h,118 :: 		SensorTRISA.B4 = INPUT;
	BSF         TRISA+0, 4 
;ir.h,119 :: 		SensorTRISA.B5 = INPUT;
	BSF         TRISA+0, 5 
;ir.h,120 :: 		SensorTRISE.B0 = INPUT;
	BSF         TRISE+0, 0 
;ir.h,121 :: 		SensorTRISE.B1 = INPUT;
	BSF         TRISE+0, 1 
;ir.h,123 :: 		SensorLATA.B0 = LOW;
	BCF         LATA+0, 0 
;ir.h,124 :: 		SensorLATA.B1 = LOW;
	BCF         LATA+0, 1 
;ir.h,125 :: 		SensorLATA.B2 = LOW;
	BCF         LATA+0, 2 
;ir.h,126 :: 		SensorLATA.B3 = LOW;
	BCF         LATA+0, 3 
;ir.h,127 :: 		SensorLATA.B4 = LOW;
	BCF         LATA+0, 4 
;ir.h,128 :: 		SensorLATA.B5 = LOW;
	BCF         LATA+0, 5 
;ir.h,129 :: 		SensorLATE.B0 = LOW;
	BCF         LATE+0, 0 
;ir.h,130 :: 		SensorLATE.B1 = LOW;
	BCF         LATE+0, 1 
;ir.h,131 :: 		}
L_end_IR_low:
	RETURN      0
; end of _IR_low

_sensor_assign:

;ir.h,134 :: 		void sensor_assign() {
;ir.h,136 :: 		sensor1 = SensorPORTA.B0;
	MOVLW       0
	BTFSC       PORTA+0, 0 
	MOVLW       1
	MOVWF       _sensor1+0 
;ir.h,137 :: 		sensor2 = SensorPORTA.B1;
	MOVLW       0
	BTFSC       PORTA+0, 1 
	MOVLW       1
	MOVWF       _sensor2+0 
;ir.h,138 :: 		sensor3 = SensorPORTA.B2;
	MOVLW       0
	BTFSC       PORTA+0, 2 
	MOVLW       1
	MOVWF       _sensor3+0 
;ir.h,139 :: 		sensor4 = SensorPORTA.B3;
	MOVLW       0
	BTFSC       PORTA+0, 3 
	MOVLW       1
	MOVWF       _sensor4+0 
;ir.h,140 :: 		sensor5 = SensorPORTA.B4;
	MOVLW       0
	BTFSC       PORTA+0, 4 
	MOVLW       1
	MOVWF       _sensor5+0 
;ir.h,141 :: 		sensor6 = SensorPORTA.B5;
	MOVLW       0
	BTFSC       PORTA+0, 5 
	MOVLW       1
	MOVWF       _sensor6+0 
;ir.h,142 :: 		sensor7 = SensorPORTE.B0;
	MOVLW       0
	BTFSC       PORTE+0, 0 
	MOVLW       1
	MOVWF       _sensor7+0 
;ir.h,143 :: 		sensor8 = SensorPORTE.B1;
	MOVLW       0
	BTFSC       PORTE+0, 1 
	MOVLW       1
	MOVWF       _sensor8+0 
;ir.h,144 :: 		}
L_end_sensor_assign:
	RETURN      0
; end of _sensor_assign

_IR_read:

;ir.h,147 :: 		void IR_read() {
;ir.h,150 :: 		IR_high();
	CALL        _IR_high+0, 0
;ir.h,152 :: 		Delay_us(15);
	MOVLW       4
	MOVWF       R13, 0
L_IR_read41:
	DECFSZ      R13, 1, 1
	BRA         L_IR_read41
	NOP
	NOP
;ir.h,155 :: 		IR_low();
	CALL        _IR_low+0, 0
;ir.h,158 :: 		Delay_us(750);
	MOVLW       249
	MOVWF       R13, 0
L_IR_read42:
	DECFSZ      R13, 1, 1
	BRA         L_IR_read42
	NOP
	NOP
;ir.h,161 :: 		sensor_assign();
	CALL        _sensor_assign+0, 0
;ir.h,162 :: 		}
L_end_IR_read:
	RETURN      0
; end of _IR_read

_position:

;ir.h,165 :: 		signed short position() {
;ir.h,188 :: 		IR_read();
	CALL        _IR_read+0, 0
;ir.h,190 :: 		pos = sensor1 * 1 + sensor2 * 3 + sensor3 * 5 + sensor4 * 7 +
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
;ir.h,191 :: 		sensor5 * 11 + sensor6 * 13 + sensor7 * 15 + sensor8 * 17;
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
;ir.h,193 :: 		switch(pos) {
	GOTO        L_position43
;ir.h,195 :: 		case 36 : pos_val = 0; break;
L_position45:
	CLRF        _pos_val+0 
	GOTO        L_position44
;ir.h,196 :: 		case 41 : pos_val = 0; break;
L_position46:
	CLRF        _pos_val+0 
	GOTO        L_position44
;ir.h,197 :: 		case 49 : pos_val = 0; break;
L_position47:
	CLRF        _pos_val+0 
	GOTO        L_position44
;ir.h,198 :: 		case 46 : pos_val = 1; break;
L_position48:
	MOVLW       1
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,199 :: 		case 57 : pos_val = 1; break;
L_position49:
	MOVLW       1
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,200 :: 		case 56 : pos_val = 2; break;
L_position50:
	MOVLW       2
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,201 :: 		case 63 : pos_val = 2; break;
L_position51:
	MOVLW       2
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,202 :: 		case 68 : pos_val = 3; break;
L_position52:
	MOVLW       3
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,203 :: 		case 71 : pos_val = 4; break;
L_position53:
	MOVLW       4
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,204 :: 		case 26 : pos_val = -1; break;
L_position54:
	MOVLW       255
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,205 :: 		case 33 : pos_val = -1; break;
L_position55:
	MOVLW       255
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,206 :: 		case 27 : pos_val = -2; break;
L_position56:
	MOVLW       254
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,207 :: 		case 16 : pos_val = -2; break;
L_position57:
	MOVLW       254
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,208 :: 		case 40 : pos_val = -3; break;
L_position58:
	MOVLW       253
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,209 :: 		case 55 : pos_val = -4; break;
L_position59:
	MOVLW       252
	MOVWF       _pos_val+0 
	GOTO        L_position44
;ir.h,210 :: 		default : pos_val = 0;
L_position60:
	CLRF        _pos_val+0 
;ir.h,211 :: 		}
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
;ir.h,212 :: 		return pos_val;
	MOVF        _pos_val+0, 0 
	MOVWF       R0 
;ir.h,213 :: 		}
L_end_position:
	RETURN      0
; end of _position

_junction:

;ir.h,216 :: 		short junction() {
;ir.h,228 :: 		IR_read();
	CALL        _IR_read+0, 0
;ir.h,230 :: 		pos = sensor1 * 1 + sensor2 * 3 + sensor3 * 5 + sensor4 * 7 +
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
;ir.h,231 :: 		sensor5 * 11 + sensor6 * 13 + sensor7 * 15 + sensor8 * 17;
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
;ir.h,233 :: 		switch (pos) {
	GOTO        L_junction61
;ir.h,235 :: 		case 0 : junc_val = strip; break;
L_junction63:
	MOVLW       2
	MOVWF       _junc_val+0 
	GOTO        L_junction62
;ir.h,236 :: 		case 4 : junc_val = left; break;
L_junction64:
	CLRF        _junc_val+0 
	GOTO        L_junction62
;ir.h,237 :: 		case 9 : junc_val = left; break;
L_junction65:
	CLRF        _junc_val+0 
	GOTO        L_junction62
;ir.h,238 :: 		case 32 : junc_val = right; break;
L_junction66:
	MOVLW       1
	MOVWF       _junc_val+0 
	GOTO        L_junction62
;ir.h,239 :: 		case 45 : junc_val = right; break;
L_junction67:
	MOVLW       1
	MOVWF       _junc_val+0 
	GOTO        L_junction62
;ir.h,240 :: 		case 72 : junc_val = lost; break;
L_junction68:
	MOVLW       3
	MOVWF       _junc_val+0 
	GOTO        L_junction62
;ir.h,241 :: 		default : junc_val = on_line;
L_junction69:
	MOVLW       4
	MOVWF       _junc_val+0 
;ir.h,242 :: 		}
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
;ir.h,243 :: 		return junc_val;
	MOVF        _junc_val+0, 0 
	MOVWF       R0 
;ir.h,244 :: 		}
L_end_junction:
	RETURN      0
; end of _junction

_init_PWM:

;motor.h,87 :: 		void init_PWM() {
;motor.h,90 :: 		PWM1_init(PWM_f); // Left side wheel
	BCF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       199
	MOVWF       PR2+0, 0
	CALL        _PWM1_Init+0, 0
;motor.h,91 :: 		PWM2_init(PWM_f); // Right side wheel
	BCF         T2CON+0, 0, 0
	BCF         T2CON+0, 1, 0
	MOVLW       199
	MOVWF       PR2+0, 0
	CALL        _PWM2_Init+0, 0
;motor.h,92 :: 		}
L_end_init_PWM:
	RETURN      0
; end of _init_PWM

_init_motor:

;motor.h,95 :: 		void init_motor() {
;motor.h,98 :: 		Motor1ATRIS = OUTPUT;
	BCF         TRISD+0, 1 
;motor.h,99 :: 		Motor1BTRIS = OUTPUT;
	BCF         TRISD+0, 0 
;motor.h,100 :: 		Motor2ATRIS = OUTPUT;
	BCF         TRISC+0, 3 
;motor.h,101 :: 		Motor2BTRIS = OUTPUT;
	BCF         TRISC+0, 0 
;motor.h,104 :: 		Motor1TRIS = OUTPUT;
	BCF         TRISC+0, 1 
;motor.h,105 :: 		Motor2TRIS = OUTPUT;
	BCF         TRISC+0, 2 
;motor.h,108 :: 		init_PWM();
	CALL        _init_PWM+0, 0
;motor.h,109 :: 		}
L_end_init_motor:
	RETURN      0
; end of _init_motor

_stop_motor:

;motor.h,112 :: 		void stop_motor() {
;motor.h,114 :: 		PWM1_Stop();
	CALL        _PWM1_Stop+0, 0
;motor.h,115 :: 		PWM2_Stop();
	CALL        _PWM2_Stop+0, 0
;motor.h,117 :: 		Motor1A = OFF;
	BCF         LATD+0, 1 
;motor.h,118 :: 		Motor1B = OFF;
	BCF         LATD+0, 0 
;motor.h,119 :: 		Motor2A = OFF;
	BCF         LATC+0, 3 
;motor.h,120 :: 		Motor2B = OFF;
	BCF         LATC+0, 0 
;motor.h,121 :: 		}
L_end_stop_motor:
	RETURN      0
; end of _stop_motor

_move_forth:

;motor.h,124 :: 		void move_forth() {
;motor.h,126 :: 		Motor1A = ON;
	BSF         LATD+0, 1 
;motor.h,127 :: 		Motor1B = OFF;
	BCF         LATD+0, 0 
;motor.h,128 :: 		Motor2A = ON;
	BSF         LATC+0, 3 
;motor.h,129 :: 		Motor2B = OFF;
	BCF         LATC+0, 0 
;motor.h,131 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;motor.h,132 :: 		PWM2_Start();
	CALL        _PWM2_Start+0, 0
;motor.h,134 :: 		PWM1_Set_Duty(Normal_speed);
	MOVLW       95
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;motor.h,135 :: 		PWM2_Set_Duty(Normal_speed);
	MOVLW       95
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;motor.h,136 :: 		}
L_end_move_forth:
	RETURN      0
; end of _move_forth

_turn:

;motor.h,139 :: 		void turn(short side) {
;motor.h,141 :: 		if (side == right) {
	MOVF        FARG_turn_side+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_turn70
;motor.h,143 :: 		Motor1A = OFF;
	BCF         LATD+0, 1 
;motor.h,144 :: 		Motor1B = OFF;
	BCF         LATD+0, 0 
;motor.h,145 :: 		Motor2A = ON;
	BSF         LATC+0, 3 
;motor.h,146 :: 		Motor2B = OFF;
	BCF         LATC+0, 0 
;motor.h,147 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;motor.h,148 :: 		PWM1_Set_Duty(150);
	MOVLW       150
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;motor.h,149 :: 		}
	GOTO        L_turn71
L_turn70:
;motor.h,150 :: 		else if (side == left) {
	MOVF        FARG_turn_side+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_turn72
;motor.h,152 :: 		Motor1A = ON;
	BSF         LATD+0, 1 
;motor.h,153 :: 		Motor1B = OFF;
	BCF         LATD+0, 0 
;motor.h,154 :: 		Motor2A = OFF;
	BCF         LATC+0, 3 
;motor.h,155 :: 		Motor2B = OFF;
	BCF         LATC+0, 0 
;motor.h,156 :: 		PWM2_Start();
	CALL        _PWM2_Start+0, 0
;motor.h,157 :: 		PWM2_Set_Duty(150);
	MOVLW       150
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;motor.h,158 :: 		}
L_turn72:
L_turn71:
;motor.h,159 :: 		}
L_end_turn:
	RETURN      0
; end of _turn

_rotate:

;motor.h,162 :: 		void rotate(short side) {
;motor.h,164 :: 		if (side == right) {
	MOVF        FARG_rotate_side+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_rotate73
;motor.h,165 :: 		Motor1A = OFF;
	BCF         LATD+0, 1 
;motor.h,166 :: 		Motor1B = ON;
	BSF         LATD+0, 0 
;motor.h,167 :: 		Motor2A = ON;
	BSF         LATC+0, 3 
;motor.h,168 :: 		Motor2B = OFF;
	BCF         LATC+0, 0 
;motor.h,169 :: 		}
	GOTO        L_rotate74
L_rotate73:
;motor.h,170 :: 		else if (side == left) {
	MOVF        FARG_rotate_side+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_rotate75
;motor.h,171 :: 		Motor1A = ON;
	BSF         LATD+0, 1 
;motor.h,172 :: 		Motor1B = OFF;
	BCF         LATD+0, 0 
;motor.h,173 :: 		Motor2A = OFF;
	BCF         LATC+0, 3 
;motor.h,174 :: 		Motor2B = ON;
	BSF         LATC+0, 0 
;motor.h,175 :: 		}
L_rotate75:
L_rotate74:
;motor.h,177 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;motor.h,178 :: 		PWM2_Start();
	CALL        _PWM2_Start+0, 0
;motor.h,180 :: 		PWM1_Set_Duty(150);
	MOVLW       150
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;motor.h,181 :: 		PWM2_Set_Duty(150);
	MOVLW       150
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;motor.h,182 :: 		}
L_end_rotate:
	RETURN      0
; end of _rotate

_reverse:

;motor.h,185 :: 		void reverse() {
;motor.h,187 :: 		Motor1A = OFF;
	BCF         LATD+0, 1 
;motor.h,188 :: 		Motor1B = ON;
	BSF         LATD+0, 0 
;motor.h,189 :: 		Motor2A = OFF;
	BCF         LATC+0, 3 
;motor.h,190 :: 		Motor2B = ON;
	BSF         LATC+0, 0 
;motor.h,192 :: 		PWM1_Start();
	CALL        _PWM1_Start+0, 0
;motor.h,193 :: 		PWM2_Start();
	CALL        _PWM2_Start+0, 0
;motor.h,195 :: 		PWM1_Set_Duty(Reverse_speed);
	MOVLW       115
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;motor.h,196 :: 		PWM2_Set_Duty(Reverse_speed);
	MOVLW       115
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;motor.h,197 :: 		}
L_end_reverse:
	RETURN      0
; end of _reverse

_fan_job:

;motor.h,200 :: 		void fan_job() {
;motor.h,202 :: 		Delay_ms(10000);
	MOVLW       51
	MOVWF       R11, 0
	MOVLW       187
	MOVWF       R12, 0
	MOVLW       223
	MOVWF       R13, 0
L_fan_job76:
	DECFSZ      R13, 1, 1
	BRA         L_fan_job76
	DECFSZ      R12, 1, 1
	BRA         L_fan_job76
	DECFSZ      R11, 1, 1
	BRA         L_fan_job76
	NOP
	NOP
;motor.h,203 :: 		}
L_end_fan_job:
	RETURN      0
; end of _fan_job

_move:

;mains.h,51 :: 		void move() {
;mains.h,54 :: 		PValve = position();
	CALL        _position+0, 0
	MOVF        R0, 0 
	MOVWF       _PValve+0 
;mains.h,56 :: 		move_forth();
	CALL        _move_forth+0, 0
;mains.h,59 :: 		switch (PValve) {
	GOTO        L_move77
;mains.h,61 :: 		case 4 :
L_move79:
;mains.h,62 :: 		turn(right); Delay_ms(25);
	MOVLW       1
	MOVWF       FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       33
	MOVWF       R12, 0
	MOVLW       118
	MOVWF       R13, 0
L_move80:
	DECFSZ      R13, 1, 1
	BRA         L_move80
	DECFSZ      R12, 1, 1
	BRA         L_move80
	NOP
;mains.h,63 :: 		break;
	GOTO        L_move78
;mains.h,64 :: 		case -4 :
L_move81:
;mains.h,65 :: 		turn(left); Delay_ms(25);
	CLRF        FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       33
	MOVWF       R12, 0
	MOVLW       118
	MOVWF       R13, 0
L_move82:
	DECFSZ      R13, 1, 1
	BRA         L_move82
	DECFSZ      R12, 1, 1
	BRA         L_move82
	NOP
;mains.h,66 :: 		break;
	GOTO        L_move78
;mains.h,67 :: 		case 3 :
L_move83:
;mains.h,68 :: 		turn(right); Delay_ms(25);
	MOVLW       1
	MOVWF       FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       33
	MOVWF       R12, 0
	MOVLW       118
	MOVWF       R13, 0
L_move84:
	DECFSZ      R13, 1, 1
	BRA         L_move84
	DECFSZ      R12, 1, 1
	BRA         L_move84
	NOP
;mains.h,69 :: 		break;
	GOTO        L_move78
;mains.h,70 :: 		case -3 :
L_move85:
;mains.h,71 :: 		turn(left); Delay_ms(25);
	CLRF        FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       33
	MOVWF       R12, 0
	MOVLW       118
	MOVWF       R13, 0
L_move86:
	DECFSZ      R13, 1, 1
	BRA         L_move86
	DECFSZ      R12, 1, 1
	BRA         L_move86
	NOP
;mains.h,72 :: 		break;
	GOTO        L_move78
;mains.h,73 :: 		case 2 :
L_move87:
;mains.h,74 :: 		turn(right); Delay_ms(29);
	MOVLW       1
	MOVWF       FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       168
	MOVWF       R13, 0
L_move88:
	DECFSZ      R13, 1, 1
	BRA         L_move88
	DECFSZ      R12, 1, 1
	BRA         L_move88
	NOP
;mains.h,75 :: 		break;
	GOTO        L_move78
;mains.h,76 :: 		case -2 :
L_move89:
;mains.h,77 :: 		turn(left); Delay_ms(29);
	CLRF        FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       168
	MOVWF       R13, 0
L_move90:
	DECFSZ      R13, 1, 1
	BRA         L_move90
	DECFSZ      R12, 1, 1
	BRA         L_move90
	NOP
;mains.h,78 :: 		break;
	GOTO        L_move78
;mains.h,79 :: 		case 1 :
L_move91:
;mains.h,80 :: 		turn(right); Delay_ms(29);
	MOVLW       1
	MOVWF       FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       168
	MOVWF       R13, 0
L_move92:
	DECFSZ      R13, 1, 1
	BRA         L_move92
	DECFSZ      R12, 1, 1
	BRA         L_move92
	NOP
;mains.h,81 :: 		break;
	GOTO        L_move78
;mains.h,82 :: 		case -1 :
L_move93:
;mains.h,83 :: 		turn(left); Delay_ms(29);
	CLRF        FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       168
	MOVWF       R13, 0
L_move94:
	DECFSZ      R13, 1, 1
	BRA         L_move94
	DECFSZ      R12, 1, 1
	BRA         L_move94
	NOP
;mains.h,84 :: 		break;
	GOTO        L_move78
;mains.h,85 :: 		default :
L_move95:
;mains.h,86 :: 		break;
	GOTO        L_move78
;mains.h,87 :: 		}
L_move77:
	MOVF        _PValve+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_move79
	MOVF        _PValve+0, 0 
	XORLW       252
	BTFSC       STATUS+0, 2 
	GOTO        L_move81
	MOVF        _PValve+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_move83
	MOVF        _PValve+0, 0 
	XORLW       253
	BTFSC       STATUS+0, 2 
	GOTO        L_move85
	MOVF        _PValve+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_move87
	MOVF        _PValve+0, 0 
	XORLW       254
	BTFSC       STATUS+0, 2 
	GOTO        L_move89
	MOVF        _PValve+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_move91
	MOVF        _PValve+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_move93
	GOTO        L_move95
L_move78:
;mains.h,88 :: 		}
L_end_move:
	RETURN      0
; end of _move

_right_junction:

;mains.h,91 :: 		void right_junction() {
;mains.h,94 :: 		stop_motor();
	CALL        _stop_motor+0, 0
;mains.h,96 :: 		Rr = check_right(); Delay_ms(100);
	CALL        _check_right+0, 0
	MOVF        R0, 0 
	MOVWF       _Rr+0 
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_right_junction96:
	DECFSZ      R13, 1, 1
	BRA         L_right_junction96
	DECFSZ      R12, 1, 1
	BRA         L_right_junction96
	NOP
	NOP
;mains.h,98 :: 		if (Rr) {
	MOVF        _Rr+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_right_junction97
;mains.h,100 :: 		reverse(); Delay_ms(20);
	CALL        _reverse+0, 0
	MOVLW       26
	MOVWF       R12, 0
	MOVLW       248
	MOVWF       R13, 0
L_right_junction98:
	DECFSZ      R13, 1, 1
	BRA         L_right_junction98
	DECFSZ      R12, 1, 1
	BRA         L_right_junction98
	NOP
;mains.h,102 :: 		rotate_right();
	CALL        _rotate_right+0, 0
;mains.h,104 :: 		fan_job();
	CALL        _fan_job+0, 0
;mains.h,106 :: 		rotate_left();
	CALL        _rotate_left+0, 0
;mains.h,107 :: 		}
L_right_junction97:
;mains.h,108 :: 		}
L_end_right_junction:
	RETURN      0
; end of _right_junction

_left_junction:

;mains.h,111 :: 		void left_junction() {
;mains.h,114 :: 		stop_motor();
	CALL        _stop_motor+0, 0
;mains.h,116 :: 		Ll = check_left(); Delay_ms(100);
	CALL        _check_left+0, 0
	MOVF        R0, 0 
	MOVWF       _Ll+0 
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_left_junction99:
	DECFSZ      R13, 1, 1
	BRA         L_left_junction99
	DECFSZ      R12, 1, 1
	BRA         L_left_junction99
	NOP
	NOP
;mains.h,118 :: 		if (Ll) {
	MOVF        _Ll+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_left_junction100
;mains.h,120 :: 		reverse(); Delay_ms(20);
	CALL        _reverse+0, 0
	MOVLW       26
	MOVWF       R12, 0
	MOVLW       248
	MOVWF       R13, 0
L_left_junction101:
	DECFSZ      R13, 1, 1
	BRA         L_left_junction101
	DECFSZ      R12, 1, 1
	BRA         L_left_junction101
	NOP
;mains.h,122 :: 		rotate_left();
	CALL        _rotate_left+0, 0
;mains.h,124 :: 		fan_job();
	CALL        _fan_job+0, 0
;mains.h,126 :: 		rotate_right();
	CALL        _rotate_right+0, 0
;mains.h,127 :: 		}
L_left_junction100:
;mains.h,128 :: 		}
L_end_left_junction:
	RETURN      0
; end of _left_junction

_RrandLl:

;mains.h,131 :: 		void RrandLl() {
;mains.h,134 :: 		rotate_right();
	CALL        _rotate_right+0, 0
;mains.h,136 :: 		fan_job();
	CALL        _fan_job+0, 0
;mains.h,138 :: 		rotate_left();
	CALL        _rotate_left+0, 0
;mains.h,140 :: 		Delay_ms(500);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_RrandLl102:
	DECFSZ      R13, 1, 1
	BRA         L_RrandLl102
	DECFSZ      R12, 1, 1
	BRA         L_RrandLl102
	DECFSZ      R11, 1, 1
	BRA         L_RrandLl102
	NOP
	NOP
;mains.h,142 :: 		rotate_left();
	CALL        _rotate_left+0, 0
;mains.h,144 :: 		fan_job();
	CALL        _fan_job+0, 0
;mains.h,146 :: 		rotate_right();
	CALL        _rotate_right+0, 0
;mains.h,148 :: 		end_course();
	CALL        _end_course+0, 0
;mains.h,149 :: 		}
L_end_RrandLl:
	RETURN      0
; end of _RrandLl

_Rronly:

;mains.h,152 :: 		void Rronly() {
;mains.h,155 :: 		rotate_right();
	CALL        _rotate_right+0, 0
;mains.h,157 :: 		fan_job();
	CALL        _fan_job+0, 0
;mains.h,159 :: 		rotate_left();
	CALL        _rotate_left+0, 0
;mains.h,161 :: 		end_course();
	CALL        _end_course+0, 0
;mains.h,162 :: 		}
L_end_Rronly:
	RETURN      0
; end of _Rronly

_Llonly:

;mains.h,165 :: 		void Llonly() {
;mains.h,168 :: 		rotate_left();
	CALL        _rotate_left+0, 0
;mains.h,170 :: 		fan_job();
	CALL        _fan_job+0, 0
;mains.h,172 :: 		rotate_right();
	CALL        _rotate_right+0, 0
;mains.h,174 :: 		end_course();
	CALL        _end_course+0, 0
;mains.h,175 :: 		}
L_end_Llonly:
	RETURN      0
; end of _Llonly

_end_course:

;mains.h,178 :: 		void end_course() {
;mains.h,180 :: 		move();
	CALL        _move+0, 0
;mains.h,181 :: 		Delay_ms(2000);
	MOVLW       11
	MOVWF       R11, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       93
	MOVWF       R13, 0
L_end_course103:
	DECFSZ      R13, 1, 1
	BRA         L_end_course103
	DECFSZ      R12, 1, 1
	BRA         L_end_course103
	DECFSZ      R11, 1, 1
	BRA         L_end_course103
	NOP
	NOP
;mains.h,183 :: 		while (ON) {
L_end_course104:
;mains.h,184 :: 		stop_motor();
	CALL        _stop_motor+0, 0
;mains.h,185 :: 		}
	GOTO        L_end_course104
;mains.h,186 :: 		}
L_end_end_course:
	RETURN      0
; end of _end_course

_rotate_right:

;mains.h,189 :: 		void rotate_right() {
;mains.h,191 :: 		do {
L_rotate_right106:
;mains.h,192 :: 		rotate(right);
	MOVLW       1
	MOVWF       FARG_rotate_side+0 
	CALL        _rotate+0, 0
;mains.h,193 :: 		IR_read();
	CALL        _IR_read+0, 0
;mains.h,194 :: 		} while (sensor8 == 1);
	MOVF        _sensor8+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_rotate_right106
;mains.h,196 :: 		do {
L_rotate_right109:
;mains.h,197 :: 		rotate(right);
	MOVLW       1
	MOVWF       FARG_rotate_side+0 
	CALL        _rotate+0, 0
;mains.h,198 :: 		IR_read();
	CALL        _IR_read+0, 0
;mains.h,199 :: 		} while (sensor8 == 0);
	MOVF        _sensor8+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_rotate_right109
;mains.h,201 :: 		do {
L_rotate_right112:
;mains.h,202 :: 		rotate(right);
	MOVLW       1
	MOVWF       FARG_rotate_side+0 
	CALL        _rotate+0, 0
;mains.h,203 :: 		IR_read();
	CALL        _IR_read+0, 0
;mains.h,204 :: 		} while (sensor5 == 1);
	MOVF        _sensor5+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_rotate_right112
;mains.h,206 :: 		stop_motor();
	CALL        _stop_motor+0, 0
;mains.h,207 :: 		}
L_end_rotate_right:
	RETURN      0
; end of _rotate_right

_rotate_left:

;mains.h,210 :: 		void rotate_left() {
;mains.h,212 :: 		do {
L_rotate_left115:
;mains.h,213 :: 		rotate(left);
	CLRF        FARG_rotate_side+0 
	CALL        _rotate+0, 0
;mains.h,214 :: 		IR_read();
	CALL        _IR_read+0, 0
;mains.h,215 :: 		} while (sensor1 == 1);
	MOVF        _sensor1+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_rotate_left115
;mains.h,217 :: 		do {
L_rotate_left118:
;mains.h,218 :: 		rotate(left);
	CLRF        FARG_rotate_side+0 
	CALL        _rotate+0, 0
;mains.h,219 :: 		IR_read();
	CALL        _IR_read+0, 0
;mains.h,220 :: 		} while (sensor1 == 0);
	MOVF        _sensor1+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_rotate_left118
;mains.h,222 :: 		do {
L_rotate_left121:
;mains.h,223 :: 		rotate(left);
	CLRF        FARG_rotate_side+0 
	CALL        _rotate+0, 0
;mains.h,224 :: 		IR_read();
	CALL        _IR_read+0, 0
;mains.h,225 :: 		} while (sensor4 == 1);
	MOVF        _sensor4+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_rotate_left121
;mains.h,227 :: 		stop_motor();
	CALL        _stop_motor+0, 0
;mains.h,228 :: 		}
L_end_rotate_left:
	RETURN      0
; end of _rotate_left

_init_main:

;MyProject.c,18 :: 		void init_main() {
;MyProject.c,20 :: 		init_sensor();
	CALL        _init_sensor+0, 0
;MyProject.c,21 :: 		init_motor();
	CALL        _init_motor+0, 0
;MyProject.c,22 :: 		init_sonar();
	CALL        _init_sonar+0, 0
;MyProject.c,23 :: 		}
L_end_init_main:
	RETURN      0
; end of _init_main

_main:

;MyProject.c,25 :: 		void main() {
;MyProject.c,28 :: 		init_main();
	CALL        _init_main+0, 0
;MyProject.c,29 :: 		first_line = 1;
	MOVLW       1
	MOVWF       _first_line+0 
;MyProject.c,31 :: 		while (ON) {
L_main124:
;MyProject.c,34 :: 		while (first_line) {
L_main126:
	MOVF        _first_line+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main127
;MyProject.c,35 :: 		move();
	CALL        _move+0, 0
;MyProject.c,36 :: 		junc_value = junction();
	CALL        _junction+0, 0
	MOVF        R0, 0 
	MOVWF       _junc_value+0 
;MyProject.c,37 :: 		if (junc_value == strip) {
	MOVF        R0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main128
;MyProject.c,38 :: 		move();
	CALL        _move+0, 0
;MyProject.c,39 :: 		Delay_ms(300);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       134
	MOVWF       R12, 0
	MOVLW       153
	MOVWF       R13, 0
L_main129:
	DECFSZ      R13, 1, 1
	BRA         L_main129
	DECFSZ      R12, 1, 1
	BRA         L_main129
	DECFSZ      R11, 1, 1
	BRA         L_main129
;MyProject.c,40 :: 		first_line = 0;
	CLRF        _first_line+0 
;MyProject.c,41 :: 		}
L_main128:
;MyProject.c,42 :: 		}
	GOTO        L_main126
L_main127:
;MyProject.c,45 :: 		junc_value = junction();
	CALL        _junction+0, 0
	MOVF        R0, 0 
	MOVWF       _junc_value+0 
;MyProject.c,48 :: 		if (junc_value == on_line) {
	MOVF        R0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_main130
;MyProject.c,49 :: 		move();
	CALL        _move+0, 0
;MyProject.c,50 :: 		}
	GOTO        L_main131
L_main130:
;MyProject.c,53 :: 		else if (junc_value == right) {
	MOVF        _junc_value+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main132
;MyProject.c,54 :: 		Delay_ms(150);
	MOVLW       195
	MOVWF       R12, 0
	MOVLW       205
	MOVWF       R13, 0
L_main133:
	DECFSZ      R13, 1, 1
	BRA         L_main133
	DECFSZ      R12, 1, 1
	BRA         L_main133
;MyProject.c,55 :: 		stop_motor();
	CALL        _stop_motor+0, 0
;MyProject.c,56 :: 		Delay_ms(50);
	MOVLW       65
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_main134:
	DECFSZ      R13, 1, 1
	BRA         L_main134
	DECFSZ      R12, 1, 1
	BRA         L_main134
	NOP
;MyProject.c,57 :: 		rotate_right();
	CALL        _rotate_right+0, 0
;MyProject.c,58 :: 		fan_job();
	CALL        _fan_job+0, 0
;MyProject.c,59 :: 		rotate_left();
	CALL        _rotate_left+0, 0
;MyProject.c,68 :: 		}
	GOTO        L_main135
L_main132:
;MyProject.c,71 :: 		else if (junc_value == left) {
	MOVF        _junc_value+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main136
;MyProject.c,72 :: 		Delay_ms(150);
	MOVLW       195
	MOVWF       R12, 0
	MOVLW       205
	MOVWF       R13, 0
L_main137:
	DECFSZ      R13, 1, 1
	BRA         L_main137
	DECFSZ      R12, 1, 1
	BRA         L_main137
;MyProject.c,73 :: 		stop_motor();
	CALL        _stop_motor+0, 0
;MyProject.c,74 :: 		Delay_ms(50);
	MOVLW       65
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_main138:
	DECFSZ      R13, 1, 1
	BRA         L_main138
	DECFSZ      R12, 1, 1
	BRA         L_main138
	NOP
;MyProject.c,75 :: 		rotate_left();
	CALL        _rotate_left+0, 0
;MyProject.c,76 :: 		fan_job();
	CALL        _fan_job+0, 0
;MyProject.c,77 :: 		rotate_right();
	CALL        _rotate_right+0, 0
;MyProject.c,85 :: 		}
	GOTO        L_main139
L_main136:
;MyProject.c,87 :: 		else if (junc_value == strip) {
	MOVF        _junc_value+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main140
;MyProject.c,88 :: 		Delay_ms(150);
	MOVLW       195
	MOVWF       R12, 0
	MOVLW       205
	MOVWF       R13, 0
L_main141:
	DECFSZ      R13, 1, 1
	BRA         L_main141
	DECFSZ      R12, 1, 1
	BRA         L_main141
;MyProject.c,89 :: 		stop_motor();
	CALL        _stop_motor+0, 0
;MyProject.c,90 :: 		Delay_ms(50);
	MOVLW       65
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_main142:
	DECFSZ      R13, 1, 1
	BRA         L_main142
	DECFSZ      R12, 1, 1
	BRA         L_main142
	NOP
;MyProject.c,91 :: 		rotate_left();
	CALL        _rotate_left+0, 0
;MyProject.c,92 :: 		fan_job();
	CALL        _fan_job+0, 0
;MyProject.c,93 :: 		rotate_right();
	CALL        _rotate_right+0, 0
;MyProject.c,94 :: 		Delay_ms(500);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main143:
	DECFSZ      R13, 1, 1
	BRA         L_main143
	DECFSZ      R12, 1, 1
	BRA         L_main143
	DECFSZ      R11, 1, 1
	BRA         L_main143
	NOP
	NOP
;MyProject.c,95 :: 		rotate_right();
	CALL        _rotate_right+0, 0
;MyProject.c,96 :: 		fan_job();
	CALL        _fan_job+0, 0
;MyProject.c,97 :: 		rotate_left();
	CALL        _rotate_left+0, 0
;MyProject.c,98 :: 		}
L_main140:
L_main139:
L_main135:
L_main131:
;MyProject.c,99 :: 		}
	GOTO        L_main124
;MyProject.c,100 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
