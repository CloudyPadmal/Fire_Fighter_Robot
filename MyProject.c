#include "Sonar.h"
#include "LED.h"
#include "IR.h"
#include "Motor.h"
#include "Mains.h"

#define ON      1
#define OFF     0

#define right   1
#define left    0

// Initiate
void init_main(void);
short junc_value, first_line;
/****************************** Initializing Codes ****************************/
// Initiate main panels
void init_main() {

    init_sensor();
    init_motor();
    init_sonar();
}

void main() {

    // Initiate panels
    init_main();
    first_line = 1;

    while (ON) {

        // Pass the first empty line first
        while (first_line) {
            move();
            junc_value = junction();
            if (junc_value == strip) {
                move();
                Delay_ms(300);
                first_line = 0;
            }
        }

        // Check path for junctions
        junc_value = junction();

        // While on the line, keep moving
        if (junc_value == on_line) {
            move();
        }

        // A junction to the right
        else if (junc_value == right) {
            Delay_ms(150);
            stop_motor();
            Delay_ms(50);
            rotate_right();
            fan_job();
            rotate_left();
            //right_junction(); 
            /*
            reverse();
            Delay_ms(20);
            rotate_right();
            Delay_ms(5000);
            rotate_left();
            Delay_ms(1000);   */
        }

        // A junction to the left
        else if (junc_value == left) {
            Delay_ms(150);
            stop_motor();
            Delay_ms(50);
            rotate_left();
            fan_job();
            rotate_right();
            //left_junction()
            /*reverse();
            Delay_ms(20);
            rotate_left();
            Delay_ms(5000);
            rotate_right();
            Delay_ms(1000);*/
        }
        
        else if (junc_value == strip) {
            Delay_ms(150);
            stop_motor();
            Delay_ms(50);
            rotate_left();
            fan_job();
            rotate_right();
            Delay_ms(500);
            rotate_right();
            fan_job();
            rotate_left();
        }
    }
}