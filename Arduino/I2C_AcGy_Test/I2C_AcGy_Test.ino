#include<Wire.h>
#define MPU 0x68
#define MPU_2G (0<<4)
#define MPU_4G (1<<4)
#define MPU_8G (2<<4)
#define MPU_16G (3<<4)
#define TAX (1<<7)
#define TAY (1<<6)
#define TAZ (1<<5)

int AcX,AcY,AcZ;
int EX,EY,EZ;

void setup(){
  EX=0;
  EY=0;
  EZ=0;
  Wire.begin();
  Wire.beginTransmission(MPU);
  Wire.write(0x6B); 
  Wire.write(0); 
  Wire.endTransmission(true);
  Wire.beginTransmission(MPU);
  Wire.write(0x1C);
  Wire.write(MPU_2G);
  Wire.endTransmission(true);
  Serial.begin(230400);
  //
  /*
  Wire.beginTransmission(MPU);
  Wire.write(0x1C);
  Wire.write(TAX|TAY|TAZ|MPU_16G);
  Wire.requestFrom(MPU,14,true);
  EX=Wire.read()<<8|Wire.read();
  EY=Wire.read()<<8|Wire.read();
  Wire.endTransmission(true);*/
  /*Wire.beginTransmission(MPU);
  Wire.write(0x1C);
  Wire.write(0|0|0|MPU_2G);
  Wire.requestFrom(MPU,14,true);
  EX-=int(Wire.read()<<8|Wire.read());
  EY-=int(Wire.read()<<8|Wire.read());
  EZ-=int(Wire.read()<<8|Wire.read());
  Wire.endTransmission(true);*/
}
void loop(){
  Wire.beginTransmission(MPU);
  Wire.write(0x3B);
  Wire.requestFrom(MPU,14,true);
  Wire.endTransmission(true);
  Serial.println(int(Wire.read()<<8|Wire.read())-603);
  Serial.println(int(Wire.read()<<8|Wire.read())+371);
  Serial.println(int(Wire.read()<<8|Wire.read())+2267);
  
  /*
  Serial.print(EX);
  Serial.print('\t');
  Serial.print(EY);
  Serial.print('\t');
  Serial.print(EZ);
  Serial.print('\n');
  */
  delay(20);
}
