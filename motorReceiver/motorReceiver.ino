#include <Wire.h>
#include <MotorControl.h>

#define MAX_SENT_BYTES 10

MotorControl *leftMotor;
MotorControl *rightMotor;

char motorCode;
int speedValue;

void setup()
{ 
  Wire.begin(9);
  Wire.onReceive(answerer);
  Serial.begin(9600);
  leftMotor = new MotorControl(12, 3, 9);
  rightMotor = new MotorControl(13, 11, 8);
  
  leftMotor->setup();
  rightMotor->setup();
}
void answerer(int bytesReceived)
{
  boolean reverse = false;

  while (Wire.available()) {
    motorCode = Wire.read(); // first byte should be a char
    speedValue = Wire.read(); // rest should be the speed value  
  }

  if (motorCode != 0) {

    if (speedValue < 0) {
      speedValue = speedValue * -1;
      reverse = true;
    } else {
      reverse = false;
    }
    
    if (motorCode == 'l') {
        leftMotor->setSpeed(speedValue);
        if (reverse) {
          leftMotor->reverse();
        } else {
          leftMotor->forward();
        }    
    } else if (motorCode == 'r') {
        rightMotor->setSpeed(speedValue);
        if (reverse) {
          rightMotor->reverse();
        } else {
          rightMotor->forward();
        }    
    } else if (motorCode == 'm') {
        leftMotor->setSpeed(speedValue);
        rightMotor->setSpeed(speedValue);
        if (reverse) {
          leftMotor->reverse();
          rightMotor->reverse();
        } else {
          leftMotor->forward();
          rightMotor->forward();
        }    
    } else {
      stop();
    }
  } else {
    stop();
  }
}
void stop()
{
  leftMotor->stop();
  rightMotor->stop();
}
void loop()
{
  if (motorCode != 0) {
    Serial.print(motorCode);
    Serial.println(" at " + speedValue);
  }
}
