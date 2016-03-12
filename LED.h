/*******************************************************************************
  This is the header file for LED panel. LED panel is used just for debugging
  purposes and a set of pins are dedicated on the PIC to use by the LED panel.

  LEDs can be accessed with LEDn variable where n is in range [1,7]. Look into
  the define section to identify the pin arrangement and change pins there and
  there only.

  # init_led()
    This function, when called will initiate the assigned LED pins. Call this
    method in your 'main()' function.

  # test_board()
    To check if the LEDs are working properly, use this function. It will blink
    all the LEDs at a 1 second delay.
*******************************************************************************/

#ifndef LED
#define LED

#define HIGH    1
#define LOW     0

#define ON      1
#define OFF     0

#define INPUT   1
#define OUTPUT  0

#define LED1                            LATC.B4
#define LED2                            LATC.B5
#define LED3                            LATC.B6
#define LED4                            LATC.B7
#define LED5                            LATD.B4
#define LED6                            LATD.B5
#define LED7                            LATD.B6
#define LED8                            LATD.B7

/***************************** Initiate LED pins ******************************/
void init_led() {

    TRISD.B4 = OUTPUT;
    TRISD.B5 = OUTPUT;
    TRISC.B4 = OUTPUT;
    TRISC.B5 = OUTPUT;
    TRISC.B6 = OUTPUT;
    TRISC.B7 = OUTPUT;
    TRISD.B6 = OUTPUT;
    TRISD.B7 = OUTPUT;
}

/****************************** Blinks all LEDs *******************************/
void test_board() {
        
    LED1 = ON;
    LED2 = ON;
    LED3 = ON;
    LED4 = ON;
    LED5 = ON;
    LED6 = ON;
    LED7 = ON;
    LED8 = ON;
    Delay_ms(1000);
    
    LED1 = OFF;
    LED2 = OFF;
    LED3 = OFF;
    LED4 = OFF;
    LED5 = OFF;
    LED6 = OFF;
    LED7 = OFF;
    LED8 = OFF;
    Delay_ms(1000);
}

/******************************************************************************/
#endif