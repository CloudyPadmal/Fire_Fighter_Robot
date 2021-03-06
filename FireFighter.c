#include "Sonar.h"
#include "LED.h"
#include "IR.h"
#include "Motor.h"
#include "Mains.h"

#define ON      1
#define OFF     0

// Initiate
void init_main(void);
short err_value, first_line, junc_value;

/****************************** Initializing Codes ****************************/
// Initiate main panels
void init_main() {

    init_sensor();
    init_motor();
    init_sonar();
}

/************************************** MAIN **********************************/
void main() {

  // Initiate panels
    init_main();
    first_line = 1;
    perr = 0;
    accelerate();

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

        err_value = error();
        if (err_value == 10) {
           if (perr > 0) {
              err_value = 5;
           } else {
              err_value = -5;
           }
        }
        // Check path for junctions
        junc_value = junction();

        // On the line means move forth
        if (junc_value == on_line) {
            move_pid(err_value);
        }

        // At a right junction, do the right junction method
        else if (junc_value == right) {
            right_junc();
        }

        // At a left junction, do the left junction method
        else if (junc_value == left) {
            left_junc();
        }

        // Two way junction means, it is the last line
        else if (junc_value == strip) {
        
            // Stop
            stop_motor(); Delay_ms(15);
            // Check left
            Ll = check_left(); Delay_ms(200);
            // Check right
            Rr = check_right(); Delay_ms(200);

            // If both sides have objects,
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

        else if (junc_value == lost) {
            
            // Move forth a little
            Delay_ms(100);
            // Stop when lost 
            stop_motor();
        }
        
        }
}