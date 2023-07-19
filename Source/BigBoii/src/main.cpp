#include <Arduino.h>
#include "config.h"
#include "sensor.h" 

int32_t sensor_value = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(bauderate);
  sensor_init(); 
  delay(3000);
  sensor_calibrate(100);
}

void loop() {
  sensor_value = sensor_compute();  
  Serial.println(sensor_value);
  delay(100); 
}



