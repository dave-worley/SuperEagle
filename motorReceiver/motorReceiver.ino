#include <Wire.h>
#include <MotorControl.h>

MotorControl *leftMotor;
MotorControl *rightMotor;

void setup()
{ 
  Wire.begin(4);
  leftMotor = new MotorControl(12, 3, 9);
  rightMotor = new MotorControl(13, 11, 8);
  
  leftMotor->setup();
  rightMotor->setup();
}
void stop()
{
  leftMotor->stop();
  rightMotor->stop();
}
void split_motor_speed(char * instring, char * motor, char * motorSpeed)
{
  String input = String(instring);
  String motorString;
  String motorSpeedString;

  motorString = input.substring(0,1);
  motorString.toCharArray(motor, sizeof(motor));

  motorSpeedString = input.substring(2, 8);
  motorSpeedString.toCharArray(motorSpeed, 5);
}

String motorCodeToString(char * motor)
{
  return String(motor);
}
int motorSpeedArrayToInt(char * motorSpeed)
{
  int speedValue;
  speedValue = atoi(motorSpeed);
  return speedValue;
}
void loop()
{
  char val[10];
  char motorArray[2];
  char motorSpeedArray[10];
  String motorCode;
  int speedValue;
  int counter = 0;
  boolean reverse = false;

  while (Wire.available()) {
    val[counter] = Wire.read();
    counter++;
  }
  
  if (val[0] != 0) {
    split_motor_speed(val, motorArray, motorSpeedArray);
    motorCode = motorCodeToString(motorArray);
    speedValue = motorSpeedArrayToInt(motorSpeedArray);
    
    if (speedValue < 0) {
      speedValue = speedValue * -1;
      reverse = true;
    } else {
      reverse = false;
    }
    
    if (motorCode.equals("l")) {
        leftMotor->setSpeed(speedValue);
        if (reverse) {
          leftMotor->reverse();
        } else {
          leftMotor->forward();
        }    
    } else if (motorCode.equals("r")) {
        rightMotor->setSpeed(speedValue);
        if (reverse) {
          rightMotor->reverse();
        } else {
          rightMotor->forward();
        }    
    } else if (motorCode.equals("m")) {
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
