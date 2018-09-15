
//=======================================
//  Beta_v2 TDL
//=====================================
#include <OneWire.h>
#include <SoftwareSerial.h>

OneWire ds(10);
// Connect the ds18b20 to pin 10 "Data"
byte i;
byte present = 0;
byte type_s;
byte data[12];
byte addr[8];
float celsius, fahrenheit, temp;
int numberOfMeas = 0;
SoftwareSerial BTserial(8, 9); // RX | TX
// Connect the HM-10 TX to Arduino pin 8 RX. 
// Connect the HM-10 RX to Arduino pin 9 TX through a voltage divider.
String tempArray = "";
char command; 
void setup() 
{
  Serial.begin(9600);
  BTserial.begin(9600);    
 
  //============================
  //  initialization ds18b20
  //============================
  
  ds.search(addr);
  switch (addr[0]) 
  {
    case 0x10:
      type_s = 1;
      break;
    case 0x28:
      type_s = 0;
      break;
    case 0x22:
      type_s = 0;
      break;
   default:
      return;
  }
}
 
void loop()
{
  temp = DS1820(addr);
  //Serial.println(temp);
  //BTserial.println(temp);
  tempArray += String(temp) + " ";
   
    numberOfMeas++;
    
  if (Serial.available()) 
  {
  }
  if (BTserial.available()) 
  {
    command = BTserial.read();
    if (command == '1')
    {
      BTserial.print(tempArray);
      BTserial.println();
    }
    if (command == '0')
    {
      BTserial.println(temp);
    }
    if (command == '2')
    {
      BTserial.println(numberOfMeas);
    }
  }

}
  
//==================================================================================
//                            Get temperature
//==================================================================================

float DS1820(byte *adds)

{ 
  ds.reset();
  ds.select(adds);
  ds.write(0x44); 
  delay(1000);
  present = ds.reset();
  ds.select(adds);
  ds.write(0xBE); 
  
for ( i = 0; i < 9; i++) 
{
  data[i] = ds.read();
}
  int16_t raw = (data[1] << 8) | data[0];

if (type_s) {
  raw = raw << 3;
  if (data[7] == 0x10) {
    raw = (raw & 0xFFF0) + 12 - data[6];
  }
} 
else {
  byte cfg = (data[4] & 0x60);
  if (cfg == 0x00) raw = raw & ~7; 
    else if (cfg == 0x20) raw = raw & ~3; 
    else if (cfg == 0x40) raw = raw & ~1; 
}
  
celsius = (float)raw / 16.0;
//fahrenheit = celsius * 1.8 + 32.0;
return celsius;

}
