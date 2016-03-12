/*******************************************************************************
  This is the header file for additional code used in the main method. So the
  main c file will have only the main method.

  # move()
    This method will call functions from motor.h and make movements forward. So
    according to the PValve, the motors will be controlled in turns to guide it
    in a straight line.

  # right_junction()
    This is the procedure followed when came across with a junction to right.
    We need to turn to that side only if there is any object detected. Or else
    we can move forth.

  # left_junction()
    This is the procedure followed when came across with a junction to left.
    We need to turn to that side only if there is any object detected. Or else
    we can move forth.

  # RrandLl()
    This is the procedure followed at the end of the line where there is a
    two way junction. If both the sides have objects detected, this is the
    method needed to be followed.

  # end_course()
    This is the procedure followed at the end of the track where the robot will
    move into the finishing square and stop and terminate the program.

*******************************************************************************/
#ifndef Mains
#define Mains

// Initiate
void move(void);
void right_junction(void);
void left_junction(void);
void RrandLl(void);
void Rronly(void);
void Llonly(void);
void end_course(void);
void right_job(void);
void left_job(void);
void rotate_right(void);
void rotate_left(void);
void left_junc(void);
void right_junc(void);

/***************************** Initiate Variables *****************************/
short Ll, Rr;
signed short PValve;

/******************************** Move forward ********************************/
void move() {

    // Get speed details from sensors
    PValve = position();
    // Move forward
    move_forth();
    
    // Make necessary turns to make it a straight path
    switch (PValve) {

        case 4 :
            turn(right); Delay_ms(25);
            break;
        case -4 :
            turn(left); Delay_ms(25);
            break;
        case 3 :
            turn(right); Delay_ms(25);
            break;
        case -3 :
            turn(left); Delay_ms(25);
            break;
        case 2 :
            turn(right); Delay_ms(29);
            break;
        case -2 :
            turn(left); Delay_ms(29);
            break;
        case 1 :
            turn(right); Delay_ms(29);
            break;
        case -1 :
            turn(left); Delay_ms(29);
            break;
        default :
            break;
    }
}

/***************************** At a right junction ****************************/
void right_junction() {

    // Stop
    stop_motor();
    // Check right sonar
    Rr = check_right(); Delay_ms(100);
    // If right sonar detects any object, turn right and move
    if (Rr) {
        // Reverse and adjust
        reverse(); Delay_ms(20);
        // Turn right
        rotate_right();
        // Start the extinguishing process
        fan_job();
        // Turn around for the main track
        rotate_left();
    }
}

/****************************** At a left junction ****************************/
void left_junction() {

    // Stop
    stop_motor();
    // Check right sonar
    Ll = check_left(); Delay_ms(100);
    // If right sonar detects any object, turn right and move
    if (Ll) {
        // Reverse and adjust
        reverse(); Delay_ms(20);
        // Turn right
        rotate_left();
        // Start the extinguishing process
        fan_job();
        // Turn around for the main track
        rotate_right();
    }
}

/*************************** Right and Left Special ***************************/
void RrandLl() {

    // Turn right
    rotate_right();
    // Start the extinguishing process
    fan_job();
    // Turn around
    rotate_left();
    // Wait a little
    Delay_ms(500);
    // Turn again
    rotate_left();
    // Start the extinguishing process
    fan_job();
    // Turn around
    rotate_right();
    // Finish
    end_course();
}

/*************************** Right or Left special ****************************/
void Rronly() {

    // Turn right
    rotate_right();
    // Start the extinguishing process
    fan_job();
    // Turn around for the main track
    rotate_left();
    // Finish
    end_course();
}

/*************************** Right or Left special ****************************/
void Llonly() {

    // Turn right
    rotate_left();
    // Start the extinguishing process
    fan_job();
    // Turn around for the main track
    rotate_right();
    // Finish
    end_course();
}

/*********************************** Finish ***********************************/
void end_course() {

    move();
    Delay_ms(2000);

    while (ON) {
        stop_motor();
    }
}

/***************************** Junction to Right ******************************/
void rotate_right() {

    do {
        rotate(right);
        IR_read();
    } while (sensor8 == 1);

    do {
        rotate(right);
        IR_read();
    } while (sensor8 == 0);

    do {
        rotate(right);
        IR_read();
    } while (sensor5 == 1);

    stop_motor();
}

/***************************** Junction to Right ******************************/
void rotate_left() {

    do {
        rotate(left);
        IR_read();
    } while (sensor1 == 1);

    do {
        rotate(left);
        IR_read();
    } while (sensor1 == 0);

    do {
        rotate(left);
        IR_read();
    } while (sensor4 == 1);
    
    stop_motor();
}

/************************ Backup method Right junction ************************/
void right_junc() {

    // Stop
    stop_motor();
    // Check right sonar
    Rr = check_right(); Delay_ms(100);
    // If right sonar detects any object, turn right and move
    if (Rr) {
        // Wait for the extinguishing process
        fan_job(right);
    }
    // Kick forward
    accelerate();
}

/************************* Backup method Left junction ************************/
void left_junc() {

    // Stop
    stop_motor();
    // Check right sonar
    Ll = check_left(); Delay_ms(100);
    // If right sonar detects any object, turn right and move
    if (Ll) {
        // Wait for the extinguishing process
        fan_job(left);
    }
    // Kick forward
    accelerate();
}

/******************************************************************************/
#endif