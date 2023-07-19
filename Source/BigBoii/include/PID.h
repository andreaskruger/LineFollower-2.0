#ifndef PID_H
#define PID_H
#include "config.h"

float PID_set_motor_speed(float speed);

float PID_compute(int position);

#endif