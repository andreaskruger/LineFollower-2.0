#include <Arduino.h>


// LED_BUILTIN in connected to pin 25 of the RP2040 chip.
// It controls the on board LED, at the top-left corner.

/*
Motor driver 1
GP17 - PWM B - LEFT WHEEL
GP16 - PWM A - MIDDLE WHEEL
GP14 - A2M 
GP13 - A1M
GP12 - B1L
GP10-  B2L

Motor driver 2
GP15 - PWM B - RIGHT MOTOR
GP11 - B1
GP9 - B2
*/



void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(17, OUTPUT);
  pinMode(12, OUTPUT);
  pinMode(11, OUTPUT);
  pinMode(16, OUTPUT);

  pinMode(14, OUTPUT);
  pinMode(13, OUTPUT);
  pinMode(10, OUTPUT);
  
  pinMode(9, OUTPUT);
  pinMode(15, OUTPUT);

  digitalWrite(10, 1);
  digitalWrite(12, 0);

  digitalWrite(14, 1);
  digitalWrite(13, 0);
  analogWriteResolution(8);
  analogWrite(17, 1000);
  //analogWrite(16, 100);
  //delay(2000);

  digitalWrite(11, 1);
  digitalWrite(9, 0);
  analogWrite(15, 1000);

}

void loop() {
  digitalWrite(LED_BUILTIN, HIGH);
  delay(500);
  digitalWrite(LED_BUILTIN, LOW);
  delay(500);
}


