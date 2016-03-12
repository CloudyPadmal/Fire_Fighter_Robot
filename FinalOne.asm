
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
	GOTO        L__check_right155
	MOVLW       126
	SUBWF       R2, 0 
L__check_right155:
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
	GOTO        L__check_left157
	MOVLW       126
	SUBWF       R2, 0 
L__check_left157:
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
	GOTO        L__check_front159
	MOVLW       250
	SUBWF       R2, 0 
L__check_front159:
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
L_IR_read39:
	DECFSZ      R13, 1, 1
	BRA         L_IR_read39
	NOP
	NOP
;ir.h,155 :: 		IR_low();
	CALL        _IR_low+0, 0
;ir.h,158 :: 		Delay_us(750);
	MOVLW       249
	MOVWF       R13, 0
L_IR_read40:
	DECFSZ      R13, 1, 1
	BRA         L_IR_read40
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
	ADDWF       _sensor1+0, 0 
	MOVWF       _pos+0 
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
	GOTO        L_position41
;ir.h,195 :: 		case 36 : pos_val = 0; break;
L_position43:
	CLRF        _pos_val+0 
	GOTO        L_position42
;ir.h,196 :: 		case 41 : pos_val = 0; break;
L_position44:
	CLRF        _pos_val+0 
	GOTO        L_position42
;ir.h,197 :: 		case 49 : pos_val = 0; break;
L_position45:
	CLRF        _pos_val+0 
	GOTO        L_position42
;ir.h,198 :: 		case 46 : pos_val = 1; break;
L_position46:
	MOVLW       1
	MOVWF       _pos_val+0 
	GOTO        L_position42
;ir.h,199 :: 		case 57 : pos_val = 1; break;
L_position47:
	MOVLW       1
	MOVWF       _pos_val+0 
	GOTO        L_position42
;ir.h,200 :: 		case 56 : pos_val = 2; break;
L_position48:
	MOVLW       2
	MOVWF       _pos_val+0 
	GOTO        L_position42
;ir.h,201 :: 		case 63 : pos_val = 2; break;
L_position49:
	MOVLW       2
	MOVWF       _pos_val+0 
	GOTO        L_position42
;ir.h,202 :: 		case 68 : pos_val = 3; break;
L_position50:
	MOVLW       3
	MOVWF       _pos_val+0 
	GOTO        L_position42
;ir.h,203 :: 		case 71 : pos_val = 4; break;
L_position51:
	MOVLW       4
	MOVWF       _pos_val+0 
	GOTO        L_position42
;ir.h,204 :: 		case 26 : pos_val = -1; break;
L_position52:
	MOVLW       255
	MOVWF       _pos_val+0 
	GOTO        L_position42
;ir.h,205 :: 		case 33 : pos_val = -1; break;
L_position53:
	MOVLW       255
	MOVWF       _pos_val+0 
	GOTO        L_position42
;ir.h,206 :: 		case 27 : pos_val = -2; break;
L_position54:
	MOVLW       254
	MOVWF       _pos_val+0 
	GOTO        L_position42
;ir.h,207 :: 		case 16 : pos_val = -2; break;
L_position55:
	MOVLW       254
	MOVWF       _pos_val+0 
	GOTO        L_position42
;ir.h,208 :: 		case 40 : pos_val = -3; break;
L_position56:
	MOVLW       253
	MOVWF       _pos_val+0 
	GOTO        L_position42
;ir.h,209 :: 		case 55 : pos_val = -4; break;
L_position57:
	MOVLW       252
	MOVWF       _pos_val+0 
	GOTO        L_position42
;ir.h,210 :: 		default : pos_val = 0;
L_position58:
	CLRF        _pos_val+0 
;ir.h,211 :: 		}
	GOTO        L_position42
L_position41:
	MOVF        _pos+0, 0 
	XORLW       36
	BTFSC       STATUS+0, 2 
	GOTO        L_position43
	MOVF        _pos+0, 0 
	XORLW       41
	BTFSC       STATUS+0, 2 
	GOTO        L_position44
	MOVF        _pos+0, 0 
	XORLW       49
	BTFSC       STATUS+0, 2 
	GOTO        L_position45
	MOVF        _pos+0, 0 
	XORLW       46
	BTFSC       STATUS+0, 2 
	GOTO        L_position46
	MOVF        _pos+0, 0 
	XORLW       57
	BTFSC       STATUS+0, 2 
	GOTO        L_position47
	MOVF        _pos+0, 0 
	XORLW       56
	BTFSC       STATUS+0, 2 
	GOTO        L_position48
	MOVF        _pos+0, 0 
	XORLW       63
	BTFSC       STATUS+0, 2 
	GOTO        L_position49
	MOVF        _pos+0, 0 
	XORLW       68
	BTFSC       STATUS+0, 2 
	GOTO        L_position50
	MOVF        _pos+0, 0 
	XORLW       71
	BTFSC       STATUS+0, 2 
	GOTO        L_position51
	MOVF        _pos+0, 0 
	XORLW       26
	BTFSC       STATUS+0, 2 
	GOTO        L_position52
	MOVF        _pos+0, 0 
	XORLW       33
	BTFSC       STATUS+0, 2 
	GOTO        L_position53
	MOVF        _pos+0, 0 
	XORLW       27
	BTFSC       STATUS+0, 2 
	GOTO        L_position54
	MOVF        _pos+0, 0 
	XORLW       16
	BTFSC       STATUS+0, 2 
	GOTO        L_position55
	MOVF        _pos+0, 0 
	XORLW       40
	BTFSC       STATUS+0, 2 
	GOTO        L_position56
	MOVF        _pos+0, 0 
	XORLW       55
	BTFSC       STATUS+0, 2 
	GOTO        L_position57
	GOTO        L_position58
L_position42:
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
	ADDWF       _sensor1+0, 0 
	MOVWF       _pos+0 
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
	GOTO        L_junction59
;ir.h,235 :: 		case 0 : junc_val = strip; break;
L_junction61:
	MOVLW       2
	MOVWF       _junc_val+0 
	GOTO        L_junction60
;ir.h,236 :: 		case 4 : junc_val = left; break;
L_junction62:
	CLRF        _junc_val+0 
	GOTO        L_junction60
;ir.h,237 :: 		case 9 : junc_val = left; break;
L_junction63:
	CLRF        _junc_val+0 
	GOTO        L_junction60
;ir.h,238 :: 		case 32 : junc_val = right; break;
L_junction64:
	MOVLW       1
	MOVWF       _junc_val+0 
	GOTO        L_junction60
;ir.h,239 :: 		case 45 : junc_val = right; break;
L_junction65:
	MOVLW       1
	MOVWF       _junc_val+0 
	GOTO        L_junction60
;ir.h,240 :: 		case 72 : junc_val = lost; break;
L_junction66:
	MOVLW       3
	MOVWF       _junc_val+0 
	GOTO        L_junction60
;ir.h,241 :: 		default : junc_val = on_line;
L_junction67:
	MOVLW       4
	MOVWF       _junc_val+0 
;ir.h,242 :: 		}
	GOTO        L_junction60
L_junction59:
	MOVF        _pos+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_junction61
	MOVF        _pos+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_junction62
	MOVF        _pos+0, 0 
	XORLW       9
	BTFSC       STATUS+0, 2 
	GOTO        L_junction63
	MOVF        _pos+0, 0 
	XORLW       32
	BTFSC       STATUS+0, 2 
	GOTO        L_junction64
	MOVF        _pos+0, 0 
	XORLW       45
	BTFSC       STATUS+0, 2 
	GOTO        L_junction65
	MOVF        _pos+0, 0 
	XORLW       72
	BTFSC       STATUS+0, 2 
	GOTO        L_junction66
	GOTO        L_junction67
L_junction60:
;ir.h,243 :: 		return junc_val;
	MOVF        _junc_val+0, 0 
	MOVWF       R0 
;ir.h,244 :: 		}
L_end_junction:
	RETURN      0
; end of _junction

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
	GOTO        L_turn68
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
	GOTO        L_turn69
L_turn68:
;motor.h,161 :: 		else if (side == left) {
	MOVF        FARG_turn_side+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_turn70
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
L_turn70:
L_turn69:
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
	GOTO        L_rotate71
;motor.h,176 :: 		Motor1A = OFF;
	BCF         LATD+0, 1 
;motor.h,177 :: 		Motor1B = ON;
	BSF         LATD+0, 0 
;motor.h,178 :: 		Motor2A = ON;
	BSF         LATC+0, 3 
;motor.h,179 :: 		Motor2B = OFF;
	BCF         LATC+0, 0 
;motor.h,180 :: 		}
	GOTO        L_rotate72
L_rotate71:
;motor.h,181 :: 		else if (side == left) {
	MOVF        FARG_rotate_side+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_rotate73
;motor.h,182 :: 		Motor1A = ON;
	BSF         LATD+0, 1 
;motor.h,183 :: 		Motor1B = OFF;
	BCF         LATD+0, 0 
;motor.h,184 :: 		Motor2A = OFF;
	BCF         LATC+0, 3 
;motor.h,185 :: 		Motor2B = ON;
	BSF         LATC+0, 0 
;motor.h,186 :: 		}
L_rotate73:
L_rotate72:
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
	GOTO        L_fan_job74
;motor.h,215 :: 		case 0 :
L_fan_job76:
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
L_fan_job77:
	DECFSZ      R13, 1, 1
	BRA         L_fan_job77
	DECFSZ      R12, 1, 1
	BRA         L_fan_job77
	DECFSZ      R11, 1, 1
	BRA         L_fan_job77
	NOP
;motor.h,219 :: 		FanL = OFF;
	BCF         LATD+0, 5 
;motor.h,220 :: 		break;
	GOTO        L_fan_job75
;motor.h,222 :: 		case 1 :
L_fan_job78:
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
L_fan_job79:
	DECFSZ      R13, 1, 1
	BRA         L_fan_job79
	DECFSZ      R12, 1, 1
	BRA         L_fan_job79
	DECFSZ      R11, 1, 1
	BRA         L_fan_job79
	NOP
;motor.h,226 :: 		FanR = OFF;
	BCF         LATD+0, 4 
;motor.h,227 :: 		break;
	GOTO        L_fan_job75
;motor.h,229 :: 		case 2 :
L_fan_job80:
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
L_fan_job81:
	DECFSZ      R13, 1, 1
	BRA         L_fan_job81
	DECFSZ      R12, 1, 1
	BRA         L_fan_job81
	DECFSZ      R11, 1, 1
	BRA         L_fan_job81
	NOP
;motor.h,233 :: 		FanR = OFF;
	BCF         LATD+0, 4 
;motor.h,234 :: 		FanL = OFF;
	BCF         LATD+0, 5 
;motor.h,235 :: 		break;
	GOTO        L_fan_job75
;motor.h,237 :: 		default :
L_fan_job82:
;motor.h,238 :: 		FanR = OFF;
	BCF         LATD+0, 4 
;motor.h,239 :: 		FanL = OFF;
	BCF         LATD+0, 5 
;motor.h,240 :: 		break;
	GOTO        L_fan_job75
;motor.h,241 :: 		}
L_fan_job74:
	MOVF        FARG_fan_job_side+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_fan_job76
	MOVF        FARG_fan_job_side+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_fan_job78
	MOVF        FARG_fan_job_side+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_fan_job80
	GOTO        L_fan_job82
L_fan_job75:
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
;motor.h,255 :: 		PWM1_Set_Duty(180);
	MOVLW       180
	MOVWF       FARG_PWM1_Set_Duty_new_duty+0 
	CALL        _PWM1_Set_Duty+0, 0
;motor.h,256 :: 		PWM2_Set_Duty(180);
	MOVLW       180
	MOVWF       FARG_PWM2_Set_Duty_new_duty+0 
	CALL        _PWM2_Set_Duty+0, 0
;motor.h,258 :: 		Delay_ms(10);
	MOVLW       13
	MOVWF       R12, 0
	MOVLW       251
	MOVWF       R13, 0
L_accelerate83:
	DECFSZ      R13, 1, 1
	BRA         L_accelerate83
	DECFSZ      R12, 1, 1
	BRA         L_accelerate83
	NOP
	NOP
;motor.h,259 :: 		}
L_end_accelerate:
	RETURN      0
; end of _accelerate

_move:

;mains.h,48 :: 		void move() {
;mains.h,51 :: 		PValve = position();
	CALL        _position+0, 0
	MOVF        R0, 0 
	MOVWF       _PValve+0 
;mains.h,53 :: 		move_forth();
	CALL        _move_forth+0, 0
;mains.h,56 :: 		switch (PValve) {
	GOTO        L_move84
;mains.h,58 :: 		case 4 :
L_move86:
;mains.h,59 :: 		turn(right); Delay_ms(25);
	MOVLW       1
	MOVWF       FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       33
	MOVWF       R12, 0
	MOVLW       118
	MOVWF       R13, 0
L_move87:
	DECFSZ      R13, 1, 1
	BRA         L_move87
	DECFSZ      R12, 1, 1
	BRA         L_move87
	NOP
;mains.h,60 :: 		break;
	GOTO        L_move85
;mains.h,61 :: 		case -4 :
L_move88:
;mains.h,62 :: 		turn(left); Delay_ms(25);
	CLRF        FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       33
	MOVWF       R12, 0
	MOVLW       118
	MOVWF       R13, 0
L_move89:
	DECFSZ      R13, 1, 1
	BRA         L_move89
	DECFSZ      R12, 1, 1
	BRA         L_move89
	NOP
;mains.h,63 :: 		break;
	GOTO        L_move85
;mains.h,64 :: 		case 3 :
L_move90:
;mains.h,65 :: 		turn(right); Delay_ms(25);
	MOVLW       1
	MOVWF       FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       33
	MOVWF       R12, 0
	MOVLW       118
	MOVWF       R13, 0
L_move91:
	DECFSZ      R13, 1, 1
	BRA         L_move91
	DECFSZ      R12, 1, 1
	BRA         L_move91
	NOP
;mains.h,66 :: 		break;
	GOTO        L_move85
;mains.h,67 :: 		case -3 :
L_move92:
;mains.h,68 :: 		turn(left); Delay_ms(25);
	CLRF        FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       33
	MOVWF       R12, 0
	MOVLW       118
	MOVWF       R13, 0
L_move93:
	DECFSZ      R13, 1, 1
	BRA         L_move93
	DECFSZ      R12, 1, 1
	BRA         L_move93
	NOP
;mains.h,69 :: 		break;
	GOTO        L_move85
;mains.h,70 :: 		case 2 :
L_move94:
;mains.h,71 :: 		turn(right); Delay_ms(29);
	MOVLW       1
	MOVWF       FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       168
	MOVWF       R13, 0
L_move95:
	DECFSZ      R13, 1, 1
	BRA         L_move95
	DECFSZ      R12, 1, 1
	BRA         L_move95
	NOP
;mains.h,72 :: 		break;
	GOTO        L_move85
;mains.h,73 :: 		case -2 :
L_move96:
;mains.h,74 :: 		turn(left); Delay_ms(29);
	CLRF        FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       168
	MOVWF       R13, 0
L_move97:
	DECFSZ      R13, 1, 1
	BRA         L_move97
	DECFSZ      R12, 1, 1
	BRA         L_move97
	NOP
;mains.h,75 :: 		break;
	GOTO        L_move85
;mains.h,76 :: 		case 1 :
L_move98:
;mains.h,77 :: 		turn(right); Delay_ms(29);
	MOVLW       1
	MOVWF       FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       168
	MOVWF       R13, 0
L_move99:
	DECFSZ      R13, 1, 1
	BRA         L_move99
	DECFSZ      R12, 1, 1
	BRA         L_move99
	NOP
;mains.h,78 :: 		break;
	GOTO        L_move85
;mains.h,79 :: 		case -1 :
L_move100:
;mains.h,80 :: 		turn(left); Delay_ms(29);
	CLRF        FARG_turn_side+0 
	CALL        _turn+0, 0
	MOVLW       38
	MOVWF       R12, 0
	MOVLW       168
	MOVWF       R13, 0
L_move101:
	DECFSZ      R13, 1, 1
	BRA         L_move101
	DECFSZ      R12, 1, 1
	BRA         L_move101
	NOP
;mains.h,81 :: 		break;
	GOTO        L_move85
;mains.h,82 :: 		default :
L_move102:
;mains.h,83 :: 		break;
	GOTO        L_move85
;mains.h,84 :: 		}
L_move84:
	MOVF        _PValve+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_move86
	MOVF        _PValve+0, 0 
	XORLW       252
	BTFSC       STATUS+0, 2 
	GOTO        L_move88
	MOVF        _PValve+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_move90
	MOVF        _PValve+0, 0 
	XORLW       253
	BTFSC       STATUS+0, 2 
	GOTO        L_move92
	MOVF        _PValve+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_move94
	MOVF        _PValve+0, 0 
	XORLW       254
	BTFSC       STATUS+0, 2 
	GOTO        L_move96
	MOVF        _PValve+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_move98
	MOVF        _PValve+0, 0 
	XORLW       255
	BTFSC       STATUS+0, 2 
	GOTO        L_move100
	GOTO        L_move102
L_move85:
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
L_right_junc103:
	DECFSZ      R13, 1, 1
	BRA         L_right_junc103
	DECFSZ      R12, 1, 1
	BRA         L_right_junc103
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
L_right_junc104:
	DECFSZ      R13, 1, 1
	BRA         L_right_junc104
	DECFSZ      R12, 1, 1
	BRA         L_right_junc104
	NOP
	NOP
;mains.h,124 :: 		if (Rr) {
	MOVF        _Rr+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_right_junc105
;mains.h,126 :: 		fan_job(right);
	MOVLW       1
	MOVWF       FARG_fan_job_side+0 
	CALL        _fan_job+0, 0
;mains.h,127 :: 		}
L_right_junc105:
;mains.h,129 :: 		if (Ll) {
	MOVF        _Ll+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_right_junc106
;mains.h,131 :: 		fan_job(left);
	CLRF        FARG_fan_job_side+0 
	CALL        _fan_job+0, 0
;mains.h,132 :: 		}
L_right_junc106:
;mains.h,134 :: 		if (Rr && Ll) {
	MOVF        _Rr+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_right_junc109
	MOVF        _Ll+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_right_junc109
L__right_junc145:
;mains.h,135 :: 		fan_job(both);
	MOVLW       2
	MOVWF       FARG_fan_job_side+0 
	CALL        _fan_job+0, 0
;mains.h,136 :: 		}
L_right_junc109:
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
L_left_junc110:
	DECFSZ      R13, 1, 1
	BRA         L_left_junc110
	DECFSZ      R12, 1, 1
	BRA         L_left_junc110
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
L_left_junc111:
	DECFSZ      R13, 1, 1
	BRA         L_left_junc111
	DECFSZ      R12, 1, 1
	BRA         L_left_junc111
	NOP
	NOP
;mains.h,151 :: 		if (Ll) {
	MOVF        _Ll+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_left_junc112
;mains.h,153 :: 		fan_job(left);
	CLRF        FARG_fan_job_side+0 
	CALL        _fan_job+0, 0
;mains.h,154 :: 		}
L_left_junc112:
;mains.h,156 :: 		if (Rr) {
	MOVF        _Rr+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_left_junc113
;mains.h,158 :: 		fan_job(right);
	MOVLW       1
	MOVWF       FARG_fan_job_side+0 
	CALL        _fan_job+0, 0
;mains.h,159 :: 		}
L_left_junc113:
;mains.h,161 :: 		if (Rr && Ll) {
	MOVF        _Rr+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_left_junc116
	MOVF        _Ll+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_left_junc116
L__left_junc146:
;mains.h,162 :: 		fan_job(both);
	MOVLW       2
	MOVWF       FARG_fan_job_side+0 
	CALL        _fan_job+0, 0
;mains.h,163 :: 		}
L_left_junc116:
;mains.h,165 :: 		accelerate();
	CALL        _accelerate+0, 0
;mains.h,166 :: 		}
L_end_left_junc:
	RETURN      0
; end of _left_junc

_init_main:

;FinalOne.c,19 :: 		void init_main() {
;FinalOne.c,21 :: 		init_sensor();
	CALL        _init_sensor+0, 0
;FinalOne.c,22 :: 		init_motor();
	CALL        _init_motor+0, 0
;FinalOne.c,23 :: 		init_sonar();
	CALL        _init_sonar+0, 0
;FinalOne.c,24 :: 		}
L_end_init_main:
	RETURN      0
; end of _init_main

_main:

;FinalOne.c,26 :: 		void main() {
;FinalOne.c,29 :: 		init_main();
	CALL        _init_main+0, 0
;FinalOne.c,30 :: 		first_line = 1;
	MOVLW       1
	MOVWF       _first_line+0 
;FinalOne.c,31 :: 		accelerate();
	CALL        _accelerate+0, 0
;FinalOne.c,33 :: 		while (ON) {
L_main117:
;FinalOne.c,36 :: 		while (first_line) {
L_main119:
	MOVF        _first_line+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main120
;FinalOne.c,37 :: 		move();
	CALL        _move+0, 0
;FinalOne.c,38 :: 		junc_value = junction();
	CALL        _junction+0, 0
	MOVF        R0, 0 
	MOVWF       _junc_value+0 
;FinalOne.c,39 :: 		if (junc_value == strip) {
	MOVF        R0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main121
;FinalOne.c,40 :: 		move();
	CALL        _move+0, 0
;FinalOne.c,41 :: 		Delay_ms(300);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       134
	MOVWF       R12, 0
	MOVLW       153
	MOVWF       R13, 0
L_main122:
	DECFSZ      R13, 1, 1
	BRA         L_main122
	DECFSZ      R12, 1, 1
	BRA         L_main122
	DECFSZ      R11, 1, 1
	BRA         L_main122
;FinalOne.c,42 :: 		first_line = 0;
	CLRF        _first_line+0 
;FinalOne.c,43 :: 		}
L_main121:
;FinalOne.c,44 :: 		}
	GOTO        L_main119
L_main120:
;FinalOne.c,47 :: 		junc_value = junction();
	CALL        _junction+0, 0
	MOVF        R0, 0 
	MOVWF       _junc_value+0 
;FinalOne.c,50 :: 		if (junc_value == on_line) {
	MOVF        R0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_main123
;FinalOne.c,51 :: 		move();
	CALL        _move+0, 0
;FinalOne.c,52 :: 		}
	GOTO        L_main124
L_main123:
;FinalOne.c,55 :: 		else if (junc_value == right) {
	MOVF        _junc_value+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main125
;FinalOne.c,56 :: 		right_junc();
	CALL        _right_junc+0, 0
;FinalOne.c,57 :: 		}
	GOTO        L_main126
L_main125:
;FinalOne.c,60 :: 		else if (junc_value == left) {
	MOVF        _junc_value+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main127
;FinalOne.c,61 :: 		left_junc();
	CALL        _left_junc+0, 0
;FinalOne.c,62 :: 		}
	GOTO        L_main128
L_main127:
;FinalOne.c,65 :: 		else if (junc_value == strip) {
	MOVF        _junc_value+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main129
;FinalOne.c,68 :: 		stop_motor(); Delay_ms(15);
	CALL        _stop_motor+0, 0
	MOVLW       20
	MOVWF       R12, 0
	MOVLW       121
	MOVWF       R13, 0
L_main130:
	DECFSZ      R13, 1, 1
	BRA         L_main130
	DECFSZ      R12, 1, 1
	BRA         L_main130
	NOP
	NOP
;FinalOne.c,70 :: 		Ll = check_left(); Delay_ms(200);
	CALL        _check_left+0, 0
	MOVF        R0, 0 
	MOVWF       _Ll+0 
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main131:
	DECFSZ      R13, 1, 1
	BRA         L_main131
	DECFSZ      R12, 1, 1
	BRA         L_main131
	DECFSZ      R11, 1, 1
	BRA         L_main131
	NOP
;FinalOne.c,72 :: 		Rr = check_right(); Delay_ms(200);
	CALL        _check_right+0, 0
	MOVF        R0, 0 
	MOVWF       _Rr+0 
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main132:
	DECFSZ      R13, 1, 1
	BRA         L_main132
	DECFSZ      R12, 1, 1
	BRA         L_main132
	DECFSZ      R11, 1, 1
	BRA         L_main132
	NOP
;FinalOne.c,75 :: 		if (Rr && Ll) {
	MOVF        _Rr+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main135
	MOVF        _Ll+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main135
L__main149:
;FinalOne.c,76 :: 		RrandLl();
	CALL        _RrandLl+0, 0
;FinalOne.c,77 :: 		}
L_main135:
;FinalOne.c,78 :: 		if (Rr && !Ll) {
	MOVF        _Rr+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main138
	MOVF        _Ll+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main138
L__main148:
;FinalOne.c,79 :: 		Rronly();
	CALL        _Rronly+0, 0
;FinalOne.c,80 :: 		}
L_main138:
;FinalOne.c,81 :: 		if (!Rr && Ll) {
	MOVF        _Rr+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_main141
	MOVF        _Ll+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main141
L__main147:
;FinalOne.c,82 :: 		Llonly();
	CALL        _Llonly+0, 0
;FinalOne.c,83 :: 		}
L_main141:
;FinalOne.c,84 :: 		}
	GOTO        L_main142
L_main129:
;FinalOne.c,86 :: 		else if (junc_value == lost) {
	MOVF        _junc_value+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main143
;FinalOne.c,89 :: 		Delay_ms(100);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main144:
	DECFSZ      R13, 1, 1
	BRA         L_main144
	DECFSZ      R12, 1, 1
	BRA         L_main144
	NOP
	NOP
;FinalOne.c,91 :: 		stop_motor();
	CALL        _stop_motor+0, 0
;FinalOne.c,92 :: 		}
L_main143:
L_main142:
L_main128:
L_main126:
L_main124:
;FinalOne.c,93 :: 		}
	GOTO        L_main117
;FinalOne.c,94 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
