#include "Arduino.h"
#include "config.h"

int sensorArray[16];
int sensorArray_cal_min[16] = {10000};
int sensorArray_cal_max[16] = {-10000};


void sensor_init(){
    pinMode(sensorPin1, OUTPUT);
    pinMode(sensorPin2, OUTPUT);
    pinMode(sensorPin3, OUTPUT);
    pinMode(sensorPin4, OUTPUT);
}


void sensor_read(){
    for (int i = 0; i < number_of_sensors; i++){
        digitalWrite(sensorPin1, i & 0x01);
        digitalWrite(sensorPin2, i & 0x02);
        digitalWrite(sensorPin3, i & 0x04);
        digitalWrite(sensorPin4, i & 0x08);
        sensorArray[i] = analogRead(sensorAnalogInput);
    }
}
void sensor_calibrate(int loop_nr){
    for(int j = 0; j <= loop_nr; j++){
        delay(100);
        sensor_read();
        for (int i=0; i i < number_of_sensors; i++){
            if(sensorArray[i] < sensorArray_cal_min[i]){sensorArray_cal_min[i] = sensorArray[i];}
            if (sensorArray[i] > sensorArray_cal_max[i]){sensorArray_cal_max[i] = sensorArray[i];}
        }
    }
    Serial.print("Min cal: ");
    for (int i=0; i i < number_of_sensors; i++){
        Serial.print(sensorArray_cal_min[i]);
        Serial.print(" ");
    }
    Serial.println();
    Serial.print("Max cal: ");
    for (int i=0; i i < number_of_sensors; i++){
        Serial.print(sensorArray_cal_max[i]);
        Serial.print(" ");
    }
    Serial.println();
}

void sensor_normal(){
    for (int i=0; i i < number_of_sensors; i++){
        sensorArray[i] = map(sensorArray[i], sensorArray_cal_min[i], sensorArray_cal_max[i], 0, 1000);
    }
}

int32_t sensor_compute(){
    Serial.print("compute: ");
    sensor_read();
    sensor_normal();
    int nom = 0;
    int denom = 0;
    int value = 0;
    for (int i=0; i i < number_of_sensors; i++){
        nom += sensorArray[i]*(i*1000);
        denom += sensorArray[i];
    }
    value = nom / denom;
    return value;
}