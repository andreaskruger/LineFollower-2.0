#include "config.h"
#include "Arduino.h"


double Kp = 1;  
double Kd = 0;
double ki = 0;
double currentTime=0;
double lastTime = 0;
double lastError = 0;
double eTime;
double cum;
int baseLine_Speed = 255;
int baseLine_sensor_value = 8000;

time_t loop_time = 10;

float PID_set_motor_speed(float speed){
    if(speed < 0){
        speed = baseLine_Speed + speed;
    }
    if(speed >= 0){
        speed = baseLine_Speed - speed;
    }
    if(speed < 0){speed = 0;}
    if(speed >255){speed = 255;}
    return speed;
}

float PID_compute(int position){
    int error = position - baseLine_sensor_value;
    currentTime = millis();
    eTime = currentTime - lastTime;
    cum = cum + error*eTime;
    int motorSpeed = Kp * error + Kd * ((error - lastError)/(eTime))+ ki*(cum);
    motorSpeed = PID_set_motor_speed(motorSpeed);
    lastError = error;
    while(millis() - currentTime <= loop_time){delay(1);}
    lastTime = currentTime;

    return motorSpeed;
}