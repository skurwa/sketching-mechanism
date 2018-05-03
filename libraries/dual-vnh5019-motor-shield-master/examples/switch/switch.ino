#include "DualVNH5019MotorShield.h"

DualVNH5019MotorShield md;
int switchstate = 0;

void setup()
{
  Serial.begin(115200);
  Serial.println("Dual VNH5019 Motor Shield");
  md.init();
  
  pinMode(3, INPUT);
  Serial.println("1");
}

void loop()
{
  
  switchstate = digitalRead(3);
  Serial.println(switchstate);
  if (switchstate == HIGH){
    md.setM1Speed(400);
  } else {
    md.setM1Speed(-400);
  }
}
