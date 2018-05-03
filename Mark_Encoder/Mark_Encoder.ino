// Mark's Encoder Code
#include "DualVNH5019MotorShield.h"

// usually the rotary encoders three pins have the ground pin in the middle
enum PinAssignments {
  encoderPinA = 2,   // right (labeled DT on our decoder, yellow wire)
  encoderPinB = 3,   // left (labeled CLK on our decoder, green wire)
};

//volatile unsigned int encoderPos = 0;  // a counter for the dial
volatile  int encoderPos = 0;  // a counter for the dial
volatile  int lastPos=0;


//unsigned int lastReportedPos = 1;   // change management
int lastReportedPos = 1;   // change management
static boolean rotating=false;      // debounce management

// interrupt service routine vars
boolean A_set = false;              
boolean B_set = false;

#define LOOPTIME        100 
unsigned long lastMilli = 0;                    // loop timing 
unsigned long lastMilliPrint = 0;               // loop timing
float speed_req = -50;                            // speed (Set Point)
float speed_act = 0;
int PWM_val = 0;
float Kp =   .5;                                // PID proportional control Gain
float Kd =    .7; 

DualVNH5019MotorShield md;

void setup() {
//set pin to input and enable pullup
  pinMode(encoderPinA, INPUT_PULLUP);
  pinMode(encoderPinB, INPUT_PULLUP); 

// encoder pin on interrupt 0 (pin 2)
  attachInterrupt(0, doEncoderA, CHANGE);
// encoder pin on interrupt 1 (pin 3)
  attachInterrupt(1, doEncoderB, CHANGE);

  Serial.begin(9600);  // output
  md.init();
  md.setM1Speed(0);
}

// main loop, work is done by interrupt service routines, this one only prints stuff
void loop() { 
  encoderUpdate();
  if((millis()-lastMilli) >= LOOPTIME) {  // enter tmed loop
    //Serial.println("Required Speed: "+ String(speed_req));
    lastMilli = millis();
    Serial.println("Speed Before Update: " + String(speed_act));
    //Serial.println("Positions: ");
    getMotorData();                                                           // calculate speed, volts and Amps
    
    PWM_val= updatePid(PWM_val, speed_req, speed_act);  // compute PWM value
    Serial.println("PWM: " + String(PWM_val));
    md.setM1Speed(PWM_val); // send PWM to motor
    Serial.println("\n");
  }
}

void getMotorData()  { // calculate speed   
  static long lastPos = 0; // last count
  //Serial.println((encoderPos));
  //Serial.println((lastPos));
  speed_act = ((encoderPos - lastPos)*(60*(1000/LOOPTIME)))/(16*29); // 16 pulses X 29 gear ratio = 464 counts per output shaft rev
  Serial.println("Speed After Update:" + String(speed_act));
  lastPos = encoderPos;
}

int updatePid(int command, int targetValue, int currentValue)   {             // compute PWM value
float pidTerm = 0;                                                            // PID correction
int error=0;                                  
static int last_error=0;                             
 error = (targetValue) - (currentValue); 
 //Serial.println("Error: " + String(error));
 //Serial.println("Last Error: " + String(last_error));
 pidTerm = (Kp * error) + (Kd * (error - last_error)); 
 //Serial.println("pidTerm: " + String(pidTerm));   
 //Serial.println("command: " + String(command));                 
 last_error = error;
 return constrain(command + int(pidTerm), -400, 0);
}

void encoderUpdate(void){
  rotating = true;  // reset the debouncer
  if (lastReportedPos != encoderPos) {
    //Serial.print("Encoder:");
    //Serial.println(encoderPos, DEC);
    //Serial.println(lastReportedPos);
    lastReportedPos = encoderPos;
  }
}









// Interrupt on A changing state
void doEncoderA(){
  // debounce
  if ( rotating ) delay (1);  // wait a little until the bouncing is done

  // Test transition, did things really change? 
  if( digitalRead(encoderPinA) != A_set ) {  // debounce once more
    A_set = !A_set;

    // adjust counter + if A leads B
    if ( A_set && !B_set ) 
      encoderPos += 1;

    rotating = false;  // no more debouncing until loop() hits again
  }
}

// Interrupt on B changing state, same as A above
void doEncoderB(){
  if ( rotating ) delay (1);
  if( digitalRead(encoderPinB) != B_set ) {
    B_set = !B_set;
    //  adjust counter - 1 if B leads A
    if( B_set && !A_set ) 
      encoderPos -= 1;

    rotating = false;
  }
}
