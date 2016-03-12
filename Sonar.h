/*******************************************************************************
  This is the header file for sonar sensors to check if there is any object in
  a given range. For the pin diagram, please refer resource files.

  # init_sonar()
    Call this method at the beginning of the "main()" method. This initiates
    necessary pins as inputs and outputs.

  # Trigger_1() - Trigger_3()
    These three methods will trig the sensors to generate a sonar wave.

  # check_right()
    This will trig the right sonar sensor and read time spent for the wave to
    arrive back at the receiver and will return 1 if there is any object and 0
    if there is none in the range.
 
  # check_left()
    This will trig the left sonar sensor and read time spent for the wave to
    arrive back at the receiver and will return 1 if there is any object and 0
    if there is none in the range.

  # check_front()
    This will trig the front sonar sensor and read time spent for the wave to
    arrive back at the receiver and will return 1 if there is any object and 0
    if there is none in the range.
*******************************************************************************/

#ifndef Sonar
#define Sonar

#define HIGH    1
#define LOW     0

#define ON      1
#define OFF     0

#define INPUT   1
#define OUTPUT  0

#define Sonar1TRIG_TRIS                 TRISB.B1
#define Sonar1TRIG_LAT                  LATB.B1
#define Sonar1ECHO_TRIS                 TRISB.B0
#define Sonar1ECHO_PORT                 PORTB.B0

#define Sonar2TRIG_TRIS                 TRISB.B3
#define Sonar2TRIG_LAT                  LATB.B3
#define Sonar2ECHO_TRIS                 TRISB.B2
#define Sonar2ECHO_PORT                 PORTB.B2

#define Sonar3TRIG_TRIS                 TRISB.B5
#define Sonar3TRIG_LAT                  LATB.B5
#define Sonar3ECHO_TRIS                 TRISB.B4
#define Sonar3ECHO_PORT                 PORTB.B4

#define CM40                            1150
#define CM10                            250

// Initiate
void init_sonar(void);
void Trigger_1(void);
void Trigger_2(void);
void Trigger_3(void);
short check_right(void);
short check_left(void);
short check_front(void);

/**************************** Initiating variables ****************************/
short right_flag, left_flag, front_flag, i, j, k;

/******************************* Initiate Sonar *******************************/
void init_sonar() {

    // Sonar Echo One
    Sonar1ECHO_TRIS = INPUT;
    // Sonar Echo Two
    Sonar2ECHO_TRIS = INPUT;
    // Sonar Echo Three
    Sonar3ECHO_TRIS = INPUT;

    // Sonar Trigger 1
    Sonar1TRIG_TRIS = OUTPUT;
    // Sonar Trigger 2
    Sonar2TRIG_TRIS = OUTPUT;
    // Sonar Trigger 3
    Sonar3TRIG_TRIS = OUTPUT;
}

/********************* Generate a pulse to start sonar 1 **********************/
void Trigger_1() {

    //TRIGGER HIGH
    Sonar1TRIG_LAT = HIGH;
    // Delay
    Delay_us(15);
    //TRIGGER LOW
    Sonar1TRIG_LAT = LOW;
}

/********************* Generate a pulse to start sonar 2 **********************/
void Trigger_2() {

    //TRIGGER HIGH
    Sonar2TRIG_LAT = HIGH;
    // Delay
    Delay_us(15);
    //TRIGGER LOW
    Sonar2TRIG_LAT = LOW;
}

/********************* Generate a pulse to start sonar 3 **********************/
void Trigger_3() {

    //TRIGGER HIGH
    Sonar3TRIG_LAT = HIGH;
    // Delay
    Delay_us(15);
    //TRIGGER LOW
    Sonar3TRIG_LAT = LOW;
}


/************************** Check right using Sonar ***************************/
short check_right() {

    // Initiate Timer and variables with a 2:1 prescaler
    T1CON = 0b00010000;
    right_flag = 0; j = 0;

    while (j < 5) {

        //Wait till ECHO sets it value to Low, in case if it's high
        while (Sonar1ECHO_PORT == 1) {asm nop;}

        // Send a pulse
        Trigger_1();

        //Wait till ECHO sets it value to High
        while (Sonar1ECHO_PORT == 0) {asm nop;}

        // Now start the timer and wait for the falling edge
        T1CON.TMR1ON = 0;
        TMR1H = 0x00; TMR1L = 0x00;
        T1CON.TMR1ON = 1;

        while ((TMR1H << 8 | TMR1L) < CM40) {
            if (Sonar1ECHO_PORT == 1) {continue;}
            else {
                // There is something inside this range
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

/*************************** Check left using Sonar ***************************/
short check_left() {

    // Initiate Timer and variables with a 2:1 prescaler
    T1CON = 0b00010000;
    left_flag = 0; i = 0;

    while (i < 5) {

        //Wait till ECHO sets it value to Low, in case if it's high
        while (Sonar2ECHO_PORT == 1) {asm nop;}

        // Send a pulse
        Trigger_2();

        //Wait till ECHO sets it value to High
        while (Sonar2ECHO_PORT == 0) {asm nop;}

        // Now start the timer and wait for the falling edge
        T1CON.TMR1ON = 0;
        TMR1H = 0x00; TMR1L = 0x00;
        T1CON.TMR1ON = 1;

        while ((TMR1H << 8 | TMR1L) < CM40) {
            if (Sonar2ECHO_PORT == 1) {continue;}
            else {
                // There is something inside this range
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

/*************************** Check front using Sonar **************************/
short check_front() {

    // Initiate Timer and variables with a 2:1 prescaler
    T1CON = 0b00010000;
    front_flag = 0; k = 0;

    while (k < 5) {

        //Wait till ECHO sets it value to Low, in case if it's high
        while (Sonar3ECHO_PORT == 1) {asm nop;}

        // Send a pulse
        Trigger_3();

        //Wait till ECHO sets it value to High
        while (Sonar3ECHO_PORT == 0) {asm nop;}

        // Now start the timer and wait for the falling edge
        T1CON.TMR1ON = 0;
        TMR1H = 0x00; TMR1L = 0x00;
        T1CON.TMR1ON = 1;

        while ((TMR1H << 8 | TMR1L) < CM10) {
            if (Sonar3ECHO_PORT == 1) {continue;}
            else {
                // There is something inside this range
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

/******************************************************************************/
#endif