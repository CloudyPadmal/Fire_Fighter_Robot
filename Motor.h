/*******************************************************************************
  This is the header file for motor controlling using PWM library in MikroC.
  Two motors can be handled using this.

  # init_motor()
    Call this method at the beginning of "main()" method. It will initiate
    appropriate pins as outputs.

  # init_PWM()
    This method will initiate PWM library functions in MikroC at the given
    frequency.

  # stop_motor()
    When called, this will stop the movements of both of the motors.

  # move_forth()
    This will rotate both motors in forward direction at Normal_speed, so the
    robot will just move forward.
    
  # turn()
    This is used to adjust course of the robot when moving in a straight line.
    Simple turns will keep the robot on the line.

  # rotate()
    This is used to rotate the robot in it's z axis.

  # reverse()
    This will move the robot backwards by rotating the wheels in the opposite
    direction to moving forward.

  # fan_job()
    This will turn the fan on for 10 seconds and turn it off. That will be the
    complete step to extinguish the fire.
    
*******************************************************************************/

#ifndef Motor
#define Motor

#define HIGH    1
#define LOW     0

#define ON      1
#define OFF     0

#define INPUT   1
#define OUTPUT  0

#define Motor1Enable                    LATC.B1
#define Motor2Enable                    LATC.B2

#define Motor1TRIS                      TRISC.B1
#define Motor2TRIS                      TRISC.B2
#define Motor1ATRIS                     TRISD.B1
#define Motor1BTRIS                     TRISD.B0
#define Motor2ATRIS                     TRISC.B3
#define Motor2BTRIS                     TRISC.B0

#define Motor1A                         LATD.B1
#define Motor1B                         LATD.B0
#define Motor2A                         LATC.B3
#define Motor2B                         LATC.B0

#define FanRENTRIS                      TRISD.B4
#define FanLENTRIS                      TRISD.B5
#define FanR                            LATD.B4
#define FanL                            LATD.B5


#define right                           1
#define left                            0

#define PWM_f                           5000
#define Turn_speed                      170
#define Turn_time                       270
#define Rotate_speed                    124
#define Rotate_time                     800
#define Reverse_speed                   115
    
#define Normal_speed                    100

// Initiate
void init_PWM(void);
void init_motor(void);
void stop_motor(void);
void move_forth(void);
void turn(short side);
void rotate(short side);
void reverse(void);
void fan_job(void);
void accelerate(void);

/**************************** Initiate PWM modules ****************************/
void init_PWM() {

    // Initiate PWM on RC1 and RC2 CCP Pins
    PWM1_init(PWM_f); // Left side wheel
    PWM2_init(PWM_f); // Right side wheel
}

/******************************* Initiate Motors ******************************/
void init_motor() {

    // Motor pins TRISB
    Motor1ATRIS = OUTPUT;
    Motor1BTRIS = OUTPUT;
    Motor2ATRIS = OUTPUT;
    Motor2BTRIS = OUTPUT;
    
    // Enable pins TRISB CCP1, CCP2
    Motor1TRIS = OUTPUT;
    Motor2TRIS = OUTPUT;
    
    // Initiate PWM on those pins
    init_PWM();

    // Initiate Fan contronller
    FanRENTRIS = OUTPUT;
    FanLENTRIS = OUTPUT;
}

/********************************* Stop Motor *********************************/
void stop_motor() {

    PWM1_Stop();
    PWM2_Stop();

    Motor1A = OFF;
    Motor1B = OFF;
    Motor2A = OFF;
    Motor2B = OFF;
}

/******************************** Move forward ********************************/
void move_forth() {

    Motor1A = ON;
    Motor1B = OFF;
    Motor2A = ON;
    Motor2B = OFF;

    PWM1_Start();
    PWM2_Start();

    PWM1_Set_Duty(Normal_speed);
    PWM2_Set_Duty(Normal_speed);
}

/************************* Turn method for small turns ************************/
void turn(short side) {

    if (side == right) {
    // Turn Right
        Motor1A = OFF;
        Motor1B = OFF;
        Motor2A = ON;
        Motor2B = OFF;
        PWM1_Start();
        PWM1_Set_Duty(150);
    }
    else if (side == left) {
    // Turn Left
        Motor1A = ON;
        Motor1B = OFF;
        Motor2A = OFF;
        Motor2B = OFF;
        PWM2_Start();
        PWM2_Set_Duty(150);
    }
}

/***************************** Rotate like a tank *****************************/
void rotate(short side) {

    if (side == right) {
        Motor1A = OFF;
        Motor1B = ON;
        Motor2A = ON;
        Motor2B = OFF;
    }
    else if (side == left) {
        Motor1A = ON;
        Motor1B = OFF;
        Motor2A = OFF;
        Motor2B = ON;
    }

    PWM1_Start();
    PWM2_Start();

    PWM1_Set_Duty(150);
    PWM2_Set_Duty(150);
}

/********************************** Reverse ***********************************/
void reverse() {

    Motor1A = OFF;
    Motor1B = ON;
    Motor2A = OFF;
    Motor2B = ON;

    PWM1_Start();
    PWM2_Start();

    PWM1_Set_Duty(Reverse_speed);
    PWM2_Set_Duty(Reverse_speed);
}

/*************************** Fire Extinguish method ***************************/
void fan_job(short side) {

    switch (side) {

        case 0 :
        FanL = ON;
        FanR = OFF;
        Delay_ms(4000);
        FanL = OFF;
        break;

        case 1 :
        FanL = OFF;
        FanR = ON;
        Delay_ms(4000);
        FanR = OFF;
        break;

        case 2 :
        FanL = ON;
        FanR = ON;
        Delay_ms(4000);
        FanR = OFF;
        FanL = OFF;
        break;

        default :
        FanR = OFF;
        FanL = OFF;
        break;
    }
}

/********************************* Accelerate *********************************/
void accelerate() {

    Motor1A = ON;
    Motor1B = OFF;
    Motor2A = ON;
    Motor2B = OFF;

    PWM1_Start();
    PWM2_Start();

    PWM1_Set_Duty(170);
    PWM2_Set_Duty(170);

    Delay_ms(10);
}

void move_pid (short er) {

    short p, d, kp=10, kd=0, correction;
    p = er * kp;
    //d = er - perr;
    correction = p + (er - perr)*kd;
    perr = er;

    Motor1A = ON;
    Motor1B = OFF;
    Motor2A = ON;
    Motor2B = OFF;

    PWM1_Start();
    PWM2_Start();

    PWM1_Set_Duty(108 - correction);
    PWM2_Set_Duty(108 + correction);
}

/******************************************************************************/
#endif