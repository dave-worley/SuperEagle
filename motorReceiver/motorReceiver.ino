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
  String val;
  int counter = 0;
  while (Wire.available()) {
    char c = Wire.read();
    if (counter == 0) {
      motorCode = c;
    } else if (counter > 0) {
      val += c;
    }
    counter++;
  }
  if (counter > 0) {
    speedValue = val.toInt();
    Serial.print(motorCode);
    Serial.println(speedValue);

    if (speedValue < 0) {
      speedValue = speedValue * -1;
      reverse = true;
    } else {
      reverse = false;
    }
    
    if (motorCode == 'l') {
        if (speedValue == 0) {
          stop();
        } else {
          leftMotor->setSpeed(speedValue);
          if (reverse) {
            leftMotor->reverse();
          } else {
            leftMotor->forward();
          }
        }
    } else if (motorCode == 'r') {
      if (speedValue == 0) {
        stop();
      } else {
        rightMotor->setSpeed(speedValue);
        if (reverse) {
          rightMotor->reverse();
        } else {
          rightMotor->forward();
        }
      } 
    } else if (motorCode == 'm') {
      if (speedValue == 0) {
        stop();
      } else {
        leftMotor->setSpeed(speedValue);
        rightMotor->setSpeed(speedValue);
        if (reverse) {
          leftMotor->reverse();
          rightMotor->reverse();
        } else {
          leftMotor->forward();
          rightMotor->forward();
        }
      } 
    }
  }
}
void stop()
{
  leftMotor->stop();
  rightMotor->stop();
}
void zeroSpeed()
{
  leftMotor->setSpeed(0);
  rightMotor->setSpeed(0);
}
void loop()
{
  zeroSpeed();
}
