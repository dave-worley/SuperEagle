#include <Wire.h>
#include <SPI.h>
#include <ble.h>

void setup()
{
  SPI.setDataMode(SPI_MODE0);
  SPI.setBitOrder(LSBFIRST);
  SPI.setClockDivider(SPI_CLOCK_DIV16);
  SPI.begin();
  ble_begin();
  Wire.begin();
  Serial.begin(9600);
}
void get_ble_value(char* readString)
{
  int counter = 0;
  while (ble_available()) {
    char c = ble_read();
    readString[counter] = c; 
    counter++;
  }
}

void loop()
{
  String val;
  while (ble_available()) {
    char c = char(ble_read());
    if (c != ':') {
      val += c;
    }
  }
  int value_length = val.length() + 1;
  char buffer[value_length];
  val.toCharArray(buffer, value_length);
  if (value_length > 1) {
    Wire.beginTransmission(9);
    Wire.write(buffer);
    Wire.endTransmission();
  }
  ble_do_events();
}
