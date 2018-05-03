#include "DualVNH5019MotorShield.h"

DualVNH5019MotorShield md;
float switchState = 0;
int i = 0;

void setup()
{
  Serial.begin(115200);
  Serial.println("Dual VNH5019 Motor Shield");
  md.init();
  
  pinMode(A5, INPUT);
  
}

void loop()
{
  switchState = analogRead(A5);
  Serial.println(i);
  md.setM1Speed(-400*sin(i/(2000*PI)));
  i = i + 1;
}
