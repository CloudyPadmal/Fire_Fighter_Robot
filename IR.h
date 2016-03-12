/*******************************************************************************
  This is the header file for IR sensors. There are 8 IR Sensors and they will
  return 1 if they are on a black surface because black absorbs IR which leads
  to lack of rays to drain the capacitors and will return 0 on a white surface
  because white reflects IR making an open path to the ground to capacitors. 
 
  # init_sensor()
    Call this method at the beginning of your "main()" method. It will turn on
    the IR LEDs and make the sensor panel available through out the code.
  
  # IR_high()
    This will make the sensor pins output and HIGH

  # IR_low()
    This will make the sensor pins inputs and LOW

  # sensor_assign()
    This will read the PORT values of each pin and assign them to separate 8
    variables 'sensor n' where n is in range [1,8]

  # IR_read()
    This will perform the necessary actions to read data from sensor panel &
    assign them to variables.

  # position()
    This will return a short value depending on the position the panel is on.
    It will read sensor data from IR_read() and switch case the appropriate 
    value.

  # junction()
    This will return a short value based on the junction type it comes across
    according to the given layout format.
*******************************************************************************/

#ifndef IR
#define IR

#define HIGH    1
#define LOW     0

#define ON      1
#define OFF     0

#define INPUT   1
#define OUTPUT  0

#define left    0
#define right   1
#define strip   2
#define lost    3
#define on_line 4

#define SensorTRISA                     TRISA
#define SensorTRISE                     TRISE
#define SensorPORTA                     PORTA
#define SensorPORTE                     PORTE
#define SensorLATA                      LATA
#define SensorLATE                      LATE

#define LEDpath                         TRISD.B2
#define SensorON                        LATD.B2

// Initiate
void init_sensor(void);
void IR_high(void);
void IR_low(void);
void IR_read(void);
void sensor_assign(void);
signed short position(void);
short junction(void);
signed short error(void);

/**************************** Initiating variables ****************************/
char sensor1, sensor2, sensor3, sensor4, sensor5, sensor6, sensor7, sensor8;
short pos, pos_val, junc_val, err, perr;

/****************************** Initiate Sensors ******************************/
void init_sensor() {

    // Enable sensor LEDs
    LEDpath = OUTPUT;
    SensorON = ON;
    // Make all Analog Pins Digital
    ANSEL0 = 0x00;
    ANSEL1 = 0;
}

/*************************** Sets sensor pins high ****************************/
void IR_high() {

    // Set pins as outputs
    SensorTRISA.B0 = OUTPUT;
    SensorTRISA.B1 = OUTPUT;
    SensorTRISA.B2 = OUTPUT;
    SensorTRISA.B3 = OUTPUT;
    SensorTRISA.B4 = OUTPUT;
    SensorTRISA.B5 = OUTPUT;
    SensorTRISE.B0 = OUTPUT;
    SensorTRISE.B1 = OUTPUT;
    // Make them 5V
    SensorLATA.B0 = HIGH;
    SensorLATA.B1 = HIGH;
    SensorLATA.B2 = HIGH;
    SensorLATA.B3 = HIGH;
    SensorLATA.B4 = HIGH;
    SensorLATA.B5 = HIGH;
    SensorLATE.B0 = HIGH;
    SensorLATE.B1 = HIGH;
}

/**************************** Sets sensor pins low ****************************/
void IR_low() {

    // Set pins as inputs
    SensorTRISA.B0 = INPUT;
    SensorTRISA.B1 = INPUT;
    SensorTRISA.B2 = INPUT;
    SensorTRISA.B3 = INPUT;
    SensorTRISA.B4 = INPUT;
    SensorTRISA.B5 = INPUT;
    SensorTRISE.B0 = INPUT;
    SensorTRISE.B1 = INPUT;
    // Make them 0V
    SensorLATA.B0 = LOW;
    SensorLATA.B1 = LOW;
    SensorLATA.B2 = LOW;
    SensorLATA.B3 = LOW;
    SensorLATA.B4 = LOW;
    SensorLATA.B5 = LOW;
    SensorLATE.B0 = LOW;
    SensorLATE.B1 = LOW;
}

/************************** Assign sensor variables ***************************/
void sensor_assign() {

    sensor1 = SensorPORTA.B0;
    sensor2 = SensorPORTA.B1;
    sensor3 = SensorPORTA.B2;
    sensor4 = SensorPORTA.B3;
    sensor5 = SensorPORTA.B4;
    sensor6 = SensorPORTA.B5;
    sensor7 = SensorPORTE.B0;
    sensor8 = SensorPORTE.B1;
}

/**************************** Get sensor readings *****************************/
void IR_read() {

    // First, make all the pins outputs and HIGH them for 10 micro seconds
    IR_high();

    Delay_us(15);

    // Then make them inputs and clear the PORT register
    IR_low();

    // Now wait for a few microsecond and read the values
    Delay_us(750);

    // Assign each input to defined variables
    sensor_assign();
}

/************************* PWM according to position **************************/
signed short position() {

    /***************************************************************************
    Multiplication factors = [01 03 05 07 11 13 15 17]

    * 11000011        36                mid
    * 11100011        41                mid right
    * 11000111        49                mid left
    * 10000111        46                little left
    * 10001111        57                little left
    * 00001111        56                more left
    * 00011111        63                more left
    * 00111111        68                lot left
    * 01111111        71                a lot left
    * 11100001        26                little right
    * 11110001        33                little right
    * 11110000        16                more right
    * 11111000        27                more right
    * 11111100        40                lot right
    * 11111110        55                a lot right
    ***************************************************************************/
    
    // Set IRs and check path
    IR_read();
    // Assign the processed value to a variable to be used in switch case
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

/******************************* Junction type ********************************/
short junction() {

    /***************************************************************************
       11111111        72                lost
       00000111        45                junction to right
       00000011        32                junction to right
       11100000        9                 junction to left
       11000000        4                 junction to left
       00000000        0                 on a strip
    ***************************************************************************/
    
    // Set IRs and check path
    IR_read();
    // Assign the processed value to a variable to use in the switch case
    pos = sensor1 * 1 + sensor2 * 3 + sensor3 * 5 + sensor4 * 7 +
          sensor5 * 11 + sensor6 * 13 + sensor7 * 15 + sensor8 * 17;
    
    switch (pos) {

        case 0 : junc_val = strip; break;
        case 4 : junc_val = left; break;
        case 9 : junc_val = left; break;
        case 32 : junc_val = right; break;
        case 45 : junc_val = right; break;
        case 72 : junc_val = lost; break;
        default : junc_val = on_line;
    }
    return junc_val;
}

/************************* PWM according to position **************************/
signed short error() {

    /***************************************************************************
    Multiplication factors = [01 03 05 07 11 13 15 17]

    * 11000011        36                mid
    * 11100011        41                mid right
    * 11000111        49                mid left
    * 10000111        46                little left
    * 10001111        57                little left
    * 00001111        56                more left
    * 00011111        63                more left
    * 00111111        68                lot left
    * 01111111        71                a lot left
    * 11100001        26                little right
    * 11110001        33                little right
    * 11110000        16                more right
    * 11111000        27                more right
    * 11111100        40                lot right
    * 11111110        55                a lot right
    ***************************************************************************/
    
    // Set IRs and check path
    IR_read();
    // Assign the processed value to a variable to be used in switch case
    pos = sensor1 * 1 + sensor2 * 3 + sensor3 * 5 + sensor4 * 7 +
          sensor5 * 11 + sensor6 * 13 + sensor7 * 15 + sensor8 * 17;
               
    switch(pos) {

        case 36 : err = 0; break;
        case 41 : err = 0; break;
        case 49 : err = 0; break;
        case 46 : err = -1; break;
        case 57 : err = -1; break;
        case 56 : err = -2; break;
        case 63 : err = -2; break;
        case 68 : err = -3; break;
        case 71 : err = -4; break;
        case 26 : err = 1; break;
        case 33 : err = 1; break;
        case 27 : err = 2; break;
        case 16 : err = 2; break;
        case 40 : err = 3; break;
        case 55 : err = 4; break;
        case 72 : err = 10; break;
        default : err = 0;
    }
    return err;
}

/******************************************************************************/
#endif