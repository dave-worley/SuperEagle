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
  while (ble_available()) {
    readString[counter] = ble_read();
    was_available = true;
    counter++;
  }
  readString[counter] = '\0';
}
void loop()
{
  char * val;
  get_ble_value(val);
  if (val != '\0') {
    Serial.println(val);
  }
  ble_do_events();
}
