#pragma once
#include <Arduino.h>

#define pwmRes 255

#define AD 26u
#define S0 18u
#define S1 19u
#define S2 20u
#define S3 21u

#define STRT 1u

#define MID_1 13u
#define MID_2 14u

#define LEFT_1 10u
#define LEFT_2 12u

#define RIGHT_1 9u
#define RIGHT_2 11u

int sens_max[11] = {0};
int sens_min[11] = {5000, 5000, 5000, 5000, 5000, 5000, 5000, 5000, 5000, 5000, 5000};
int sens_meas[11] = {0};

void readSensor()
{
    uint8_t j = 0;
    int val = 0;
    for (size_t i = 3; i < 13; i++)
    {

        digitalWrite(S0, i & 0x01);
        digitalWrite(S1, (i >> 1) & 0x01);
        digitalWrite(S2, (i >> 2) & 0x01);
        digitalWrite(S3, (i >> 3) & 0x01);

        // delay(0.1);
        val = analogRead(AD);
        sens_meas[j] = val;

        // Serial.print(i);
        // Serial.print(" : ");
        // Serial.print(val);
        // Serial.println(" ");
        // delay(100);
        j++;
    }
}

void setSpeed(int16_t left, int16_t right)
{
    left = constrain(left, -pwmRes, pwmRes);
    right = constrain(right, -pwmRes, pwmRes);

    if (left > 0)
    {
        analogWrite(LEFT_1, 0);
        analogWrite(LEFT_2, left);
    }
    else
    {
        analogWrite(LEFT_1, 0);
        analogWrite(LEFT_2, -0.8 * left);
    }

    if (right > 0)
    {
        analogWrite(RIGHT_1, right);
        analogWrite(RIGHT_2, 0);
    }
    else
    {
        analogWrite(RIGHT_1, 0);
        analogWrite(RIGHT_2, -0.8 * right);
    }
}

void sweepCal(uint8_t print)
{
    for (uint16_t i = 0; i < 100; i++)
    {
        readSensor();

        for (int k = 0; k < 11; k++)
        {
            if (sens_meas[k] > sens_max[k])
            {
                sens_max[k] = sens_meas[k];
            }

            if (sens_meas[k] < sens_min[k])
            {
                sens_min[k] = sens_meas[k];
            }
        }
        delay(20);

        // Print the calibrated min and max values
    }

    if (print)
    {
        Serial.println("Calibration completed:");
        for (int k = 0; k < 3; k++)
        {
            Serial.print("Sensor ");
            Serial.print(k);
            Serial.print(": Min = ");
            Serial.print(sens_min[k]);
            Serial.print(", Max = ");
            Serial.println(sens_max[k]);
        }
    }
}