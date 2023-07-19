#ifndef SENSOR_H
#define SENSOR_H

#include "config.h"
#include "Arduino.h"



void sensor_init();

void sensor_read();

int32_t sensor_compute();

void sensor_calibrate(int loop_nr);
 
#endif

