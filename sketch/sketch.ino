#include <SPI.h>
#include <ble.h>

void setup()
{
  SPI.setDataMode(SPI_MODE0);
  SPI.setBitOrder(LSBFIRST);
  SPI.setClockDivider(SPI_CLOCK_DIV16);
  SPI.begin();
  ble_begin();
  Serial.begin(9600);
}
void get_ble_value(char* readString)
{
  int counter = 0;
  boolean was_available = false;
  char speed_string_array[3];

  // we have to pull out all the values that are being transmitted  
  while (ble_available()) {
    readString[counter] = ble_read();
    was_available = true;
    counter++;
  }
  // c++ so we have to terminate the string
  readString[counter] = '\0';
}

void split_motor_speed(char * instring, char * motor, char * motorSpeed)
{
  String input = String(instring);
  String motorString;
  String motorSpeedString;

  motorString = input.substring(0,1);
  motorString.toCharArray(motor, sizeof(motor));

  motorSpeedString = input.substring(2, 10);
  motorSpeedString.toCharArray(motorSpeed, sizeof(motorSpeed));
  Serial.println(motorSpeed);
}

String motorCodeToString(char * motor)
{
  return String(motor);
}
int motorSpeedArrayToInt(char * motorSpeed)
{
  int speedValue;
  speedValue = atoi(motorSpeed);
  return floor(speedValue);
}

void loop()
{
  char val[10];
  char motorArray[2];
  char motorSpeedArray[10];
  String motorCode;
  int speedValue;
  get_ble_value(val);
  if (val[0] != 0) {
    split_motor_speed(val, motorArray, motorSpeedArray);

    motorCode = motorCodeToString(motorArray);
    speedValue = motorSpeedArrayToInt(motorSpeedArray);
  }
//  if (val[0] != 0) {
//    Serial.println(motorSpeedArray);
//    //Serial.println(motorCode + " at " + speedValue);
//  }
  ble_do_events();
}