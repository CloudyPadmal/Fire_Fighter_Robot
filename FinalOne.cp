#line 1 "E:/Robot/Main Code/FinalOne.c"
#line 1 "e:/robot/main code/sonar.h"
#line 59 "e:/robot/main code/sonar.h"
void init_sonar(void);
void Trigger_1(void);
void Trigger_2(void);
void Trigger_3(void);
short check_right(void);
short check_left(void);
short check_front(void);


short right_flag, left_flag, front_flag, i, j, k;


void init_sonar() {


  TRISB.B0  =  1 ;

  TRISB.B2  =  1 ;

  TRISB.B4  =  1 ;


  TRISB.B1  =  0 ;

  TRISB.B3  =  0 ;

  TRISB.B5  =  0 ;
}


void Trigger_1() {


  LATB.B1  =  1 ;

 Delay_us(15);

  LATB.B1  =  0 ;
}


void Trigger_2() {


  LATB.B3  =  1 ;

 Delay_us(15);

  LATB.B3  =  0 ;
}


void Trigger_3() {


  LATB.B5  =  1 ;

 Delay_us(15);

  LATB.B5  =  0 ;
}



short check_right() {


 T1CON = 0b00010000;
 right_flag = 0; j = 0;

 while (j < 5) {


 while ( PORTB.B0  == 1) {asm nop;}


 Trigger_1();


 while ( PORTB.B0  == 0) {asm nop;}


 T1CON.TMR1ON = 0;
 TMR1H = 0x00; TMR1L = 0x00;
 T1CON.TMR1ON = 1;

 while ((TMR1H << 8 | TMR1L) <  1150 ) {
 if ( PORTB.B0  == 1) {continue;}
 else {

 right_flag++;
 break;
 }
 }
 j++;
 }

 if (right_flag > 2) {
 return 1;
 } else {
 return 0;
 }
}


short check_left() {


 T1CON = 0b00010000;
 left_flag = 0; i = 0;

 while (i < 5) {


 while ( PORTB.B2  == 1) {asm nop;}


 Trigger_2();


 while ( PORTB.B2  == 0) {asm nop;}


 T1CON.TMR1ON = 0;
 TMR1H = 0x00; TMR1L = 0x00;
 T1CON.TMR1ON = 1;

 while ((TMR1H << 8 | TMR1L) <  1150 ) {
 if ( PORTB.B2  == 1) {continue;}
 else {

 left_flag++;
 break;
 }
 }
 i++;
 }

 if (left_flag > 2) {
 return 1;
 } else {
 return 0;
 }
}


short check_front() {


 T1CON = 0b00010000;
 front_flag = 0; k = 0;

 while (k < 5) {


 while ( PORTB.B4  == 1) {asm nop;}


 Trigger_3();


 while ( PORTB.B4  == 0) {asm nop;}


 T1CON.TMR1ON = 0;
 TMR1H = 0x00; TMR1L = 0x00;
 T1CON.TMR1ON = 1;

 while ((TMR1H << 8 | TMR1L) <  250 ) {
 if ( PORTB.B4  == 1) {continue;}
 else {

 front_flag++;
 break;
 }
 }
 k++;
 }

 if (front_flag > 2) {
 return 1;
 } else {
 return 0;
 }
}
#line 1 "e:/robot/main code/ir.h"
#line 64 "e:/robot/main code/ir.h"
void init_sensor(void);
void IR_high(void);
void IR_low(void);
void IR_read(void);
void sensor_assign(void);
signed short position(void);
short junction(void);


char sensor1, sensor2, sensor3, sensor4, sensor5, sensor6, sensor7, sensor8;
short pos, pos_val, junc_val;


void init_sensor() {


  TRISD.B2  =  0 ;
  LATD.B2  =  1 ;

 ANSEL0 = 0x00;
 ANSEL1 = 0;
}


void IR_high() {


  TRISA .B0 =  0 ;
  TRISA .B1 =  0 ;
  TRISA .B2 =  0 ;
  TRISA .B3 =  0 ;
  TRISA .B4 =  0 ;
  TRISA .B5 =  0 ;
  TRISE .B0 =  0 ;
  TRISE .B1 =  0 ;

  LATA .B0 =  1 ;
  LATA .B1 =  1 ;
  LATA .B2 =  1 ;
  LATA .B3 =  1 ;
  LATA .B4 =  1 ;
  LATA .B5 =  1 ;
  LATE .B0 =  1 ;
  LATE .B1 =  1 ;
}


void IR_low() {


  TRISA .B0 =  1 ;
  TRISA .B1 =  1 ;
  TRISA .B2 =  1 ;
  TRISA .B3 =  1 ;
  TRISA .B4 =  1 ;
  TRISA .B5 =  1 ;
  TRISE .B0 =  1 ;
  TRISE .B1 =  1 ;

  LATA .B0 =  0 ;
  LATA .B1 =  0 ;
  LATA .B2 =  0 ;
  LATA .B3 =  0 ;
  LATA .B4 =  0 ;
  LATA .B5 =  0 ;
  LATE .B0 =  0 ;
  LATE .B1 =  0 ;
}


void sensor_assign() {

 sensor1 =  PORTA .B0;
 sensor2 =  PORTA .B1;
 sensor3 =  PORTA .B2;
 sensor4 =  PORTA .B3;
 sensor5 =  PORTA .B4;
 sensor6 =  PORTA .B5;
 sensor7 =  PORTE .B0;
 sensor8 =  PORTE .B1;
}


void IR_read() {


 IR_high();

 Delay_us(15);


 IR_low();


 Delay_us(750);


 sensor_assign();
}


signed short position() {
#line 188 "e:/robot/main code/ir.h"
 IR_read();

 pos = sensor1 * 1 + sensor2 * 3 + sensor3 * 5 + sensor4 * 7 +
 sensor5 * 11 + sensor6 * 13 + sensor7 * 15 + sensor8 * 17;

 switch(pos) {

 case 36 : pos_val = 0; break;
 case 41 : pos_val = 0; break;
 case 49 : pos_val = 0; break;
 case 46 : pos_val = 1; break;
 case 57 : pos_val = 1; break;
 case 56 : pos_val = 2; break;
 case 63 : pos_val = 2; break;
 case 68 : pos_val = 3; break;
 case 71 : pos_val = 4; break;
 case 26 : pos_val = -1; break;
 case 33 : pos_val = -1; break;
 case 27 : pos_val = -2; break;
 case 16 : pos_val = -2; break;
 case 40 : pos_val = -3; break;
 case 55 : pos_val = -4; break;
 default : pos_val = 0;
 }
 return pos_val;
}


short junction() {
#line 228 "e:/robot/main code/ir.h"
 IR_read();

 pos = sensor1 * 1 + sensor2 * 3 + sensor3 * 5 + sensor4 * 7 +
 sensor5 * 11 + sensor6 * 13 + sensor7 * 15 + sensor8 * 17;

 switch (pos) {

 case 0 : junc_val =  2 ; break;
 case 4 : junc_val =  0 ; break;
 case 9 : junc_val =  0 ; break;
 case 32 : junc_val =  1 ; break;
 case 45 : junc_val =  1 ; break;
 case 72 : junc_val =  3 ; break;
 default : junc_val =  4 ;
 }
 return junc_val;
}
#line 1 "e:/robot/main code/motor.h"
#line 83 "e:/robot/main code/motor.h"
void init_PWM(void);
void init_motor(void);
void stop_motor(void);
void move_forth(void);
void turn(short side);
void rotate(short side);
void reverse(void);
void fan_job(void);
void accelerate(void);


void init_PWM() {


 PWM1_init( 5000 );
 PWM2_init( 5000 );
}


void init_motor() {


  TRISD.B1  =  0 ;
  TRISD.B0  =  0 ;
  TRISC.B3  =  0 ;
  TRISC.B0  =  0 ;


  TRISC.B1  =  0 ;
  TRISC.B2  =  0 ;


 init_PWM();


  TRISD.B4  =  0 ;
  TRISD.B5  =  0 ;
}


void stop_motor() {

 PWM1_Stop();
 PWM2_Stop();

  LATD.B1  =  0 ;
  LATD.B0  =  0 ;
  LATC.B3  =  0 ;
  LATC.B0  =  0 ;
}


void move_forth() {

  LATD.B1  =  1 ;
  LATD.B0  =  0 ;
  LATC.B3  =  1 ;
  LATC.B0  =  0 ;

 PWM1_Start();
 PWM2_Start();

 PWM1_Set_Duty( 100 );
 PWM2_Set_Duty( 100 );
}


void turn(short side) {

 if (side ==  1 ) {

  LATD.B1  =  0 ;
  LATD.B0  =  0 ;
  LATC.B3  =  1 ;
  LATC.B0  =  0 ;
 PWM1_Start();
 PWM1_Set_Duty(150);
 }
 else if (side ==  0 ) {

  LATD.B1  =  1 ;
  LATD.B0  =  0 ;
  LATC.B3  =  0 ;
  LATC.B0  =  0 ;
 PWM2_Start();
 PWM2_Set_Duty(150);
 }
}


void rotate(short side) {

 if (side ==  1 ) {
  LATD.B1  =  0 ;
  LATD.B0  =  1 ;
  LATC.B3  =  1 ;
  LATC.B0  =  0 ;
 }
 else if (side ==  0 ) {
  LATD.B1  =  1 ;
  LATD.B0  =  0 ;
  LATC.B3  =  0 ;
  LATC.B0  =  1 ;
 }

 PWM1_Start();
 PWM2_Start();

 PWM1_Set_Duty(150);
 PWM2_Set_Duty(150);
}


void reverse() {

  LATD.B1  =  0 ;
  LATD.B0  =  1 ;
  LATC.B3  =  0 ;
  LATC.B0  =  1 ;

 PWM1_Start();
 PWM2_Start();

 PWM1_Set_Duty( 115 );
 PWM2_Set_Duty( 115 );
}


void fan_job(short side) {

 switch (side) {

 case 0 :
  LATD.B5  =  1 ;
  LATD.B4  =  0 ;
 Delay_ms(4000);
  LATD.B5  =  0 ;
 break;

 case 1 :
  LATD.B5  =  0 ;
  LATD.B4  =  1 ;
 Delay_ms(4000);
  LATD.B4  =  0 ;
 break;

 case 2 :
  LATD.B5  =  1 ;
  LATD.B4  =  1 ;
 Delay_ms(4000);
  LATD.B4  =  0 ;
  LATD.B5  =  0 ;
 break;

 default :
  LATD.B4  =  0 ;
  LATD.B5  =  0 ;
 break;
 }
}


void accelerate() {

  LATD.B1  =  1 ;
  LATD.B0  =  0 ;
  LATC.B3  =  1 ;
  LATC.B0  =  0 ;

 PWM1_Start();
 PWM2_Start();

 PWM1_Set_Duty(180);
 PWM2_Set_Duty(180);

 Delay_ms(10);
}
#line 1 "e:/robot/main code/mains.h"
#line 36 "e:/robot/main code/mains.h"
void move(void);
void RrandLl(void);
void Rronly(void);
void Llonly(void);
void left_junc(void);
void right_junc(void);


short Ll, Rr;
signed short PValve;


void move() {


 PValve = position();

 move_forth();


 switch (PValve) {

 case 4 :
 turn( 1 ); Delay_ms(25);
 break;
 case -4 :
 turn( 0 ); Delay_ms(25);
 break;
 case 3 :
 turn( 1 ); Delay_ms(25);
 break;
 case -3 :
 turn( 0 ); Delay_ms(25);
 break;
 case 2 :
 turn( 1 ); Delay_ms(29);
 break;
 case -2 :
 turn( 0 ); Delay_ms(29);
 break;
 case 1 :
 turn( 1 ); Delay_ms(29);
 break;
 case -1 :
 turn( 0 ); Delay_ms(29);
 break;
 default :
 break;
 }
}


void RrandLl() {


 fan_job( 2 );

 accelerate();
}


void Rronly() {


 fan_job( 1 );

 accelerate();
}


void Llonly() {


 fan_job( 0 );

 accelerate();
}


void right_junc() {


 stop_motor();

 Rr = check_right(); Delay_ms(100);

 Ll = check_left(); Delay_ms(100);

 if (Rr) {

 fan_job( 1 );
 }

 if (Ll) {

 fan_job( 0 );
 }

 if (Rr && Ll) {
 fan_job( 2 );
 }

 accelerate();
}


void left_junc() {


 stop_motor();

 Ll = check_left(); Delay_ms(100);

 Rr = check_right(); Delay_ms(100);

 if (Ll) {

 fan_job( 0 );
 }

 if (Rr) {

 fan_job( 1 );
 }

 if (Rr && Ll) {
 fan_job( 2 );
 }

 accelerate();
}
#line 14 "E:/Robot/Main Code/FinalOne.c"
void init_main(void);
short junc_value, first_line;



void init_main() {

 init_sensor();
 init_motor();
 init_sonar();
}

void main() {


 init_main();
 first_line = 1;
 accelerate();

 while ( 1 ) {


 while (first_line) {
 move();
 junc_value = junction();
 if (junc_value ==  2 ) {
 move();
 Delay_ms(300);
 first_line = 0;
 }
 }


 junc_value = junction();


 if (junc_value ==  4 ) {
 move();
 }


 else if (junc_value ==  1 ) {
 right_junc();
 }


 else if (junc_value ==  0 ) {
 left_junc();
 }


 else if (junc_value ==  2 ) {


 stop_motor(); Delay_ms(15);

 Ll = check_left(); Delay_ms(200);

 Rr = check_right(); Delay_ms(200);


 if (Rr && Ll) {
 RrandLl();
 }
 if (Rr && !Ll) {
 Rronly();
 }
 if (!Rr && Ll) {
 Llonly();
 }
 }

 else if (junc_value ==  3 ) {


 Delay_ms(100);

 stop_motor();
 }
 }
}
