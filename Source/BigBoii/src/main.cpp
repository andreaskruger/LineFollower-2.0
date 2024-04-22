#include <Arduino.h>
#include <helper.h>
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

uint8_t calib = 0;
uint8_t start = 0;

void setup()
{
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);

  pinMode(12, OUTPUT);
  pinMode(10, OUTPUT);

  pinMode(11, OUTPUT);
  pinMode(9, OUTPUT);

  pinMode(14, OUTPUT);
  pinMode(13, OUTPUT);

  pinMode(S0, OUTPUT);
  pinMode(S1, OUTPUT);
  pinMode(S2, OUTPUT);
  pinMode(S3, OUTPUT);

  pinMode(AD, INPUT);
  pinMode(STRT, INPUT_PULLUP);

  analogWriteResolution(8);
  analogWrite(MID_2, 0);
  analogWrite(MID_1, 0);

  sweepCal(0);

  setSpeed(0, 0);

  while (1)
  {
    delay(100);
    if (digitalRead(STRT) == 0)
    {
      break;
    }
  }

  delay(200);

  while (1)
  {
    delay(100);
    if (digitalRead(STRT) == 0)
    {
      break;
    }
  }

  delay(200);

  while (1)
  {
    delay(100);
    if (digitalRead(STRT) == 0)
    {
      break;
    }
  }

  delay(200);
}

int val = 0;

uint8_t j = 0;

int line_est, num, denom;

// const float Kp = 0.01;
// const float Ki = 0;
// const float Kd = 0.001;

// const float Kp = 2;
// const float Ki = 0;
// const float Kd = 0;

// WOrks well
// const float Kp = 1;
// const float Ki = 0;
// const float Kd = 0.2;

// Works better
// const float Kp = 1;
// const float Ki = 0;
// const float Kd = 0.5;

// Works better
const float Kp = 2;
const float Ki = 0;
const float Kd = 1.2;

// const float Kd = 0.65; //goes back and forward

// const float Kp = 1.6;
// const float Ki = 0;
// const float Kd = 0.8;

int16_t base = 200;

int16_t spd = 0;
int16_t err = 0;
int16_t prev_err = 0;
bool onLine = true;
int16_t prev_spd = 0;

float sens_norm[11] = {0};

void loop()
{

  readSensor();

  // Normalize sensor values
  for (int k = 0; k < 11; k++)
  {
    // Serial.print("k=");
    // Serial.print(k);
    // Serial.print(", Value: ");
    // Serial.print(sens_meas[k]);
    if (sens_max[k] != sens_min[k])
    {
      sens_norm[k] = (float)(sens_meas[k] - sens_min[k]) / (sens_max[k] - sens_min[k]); // Map to max and min and scaled to {0,1}
      sens_norm[k] = 100 * sens_norm[k];                                                // Scaled to {0,1000}
    }
    else
    {
      sens_norm[k] = 0.0; // Handle division by zero case
    }
  }
  // Serial.println("");

  // for (int k = 0; k < 11; k++)
  // {
  //   if (sens_norm[k] < 50) {
  //     onLine = true;
  //     break;
  //   }
  //   else {
  //     onLine = false;
  //     break;
  //   }
  // }

  num = (int)0 * sens_norm[0] + 100 * sens_norm[1] + 200 * sens_norm[2] + 300 * sens_norm[3] + 400 * sens_norm[4] + 500 * sens_norm[5] + 600 * sens_norm[6] + 700 * sens_norm[7] + 800 * sens_norm[8] + 900 * sens_norm[9] + 1000 * sens_norm[10];
  denom = (int)sens_norm[0] + sens_norm[1] + sens_norm[2] + sens_norm[3] + sens_norm[4] + sens_norm[5] + sens_norm[6] + sens_norm[7] + sens_norm[8] + sens_norm[9] + sens_norm[10];
  line_est = num / denom;

  err = 400 - line_est;
  spd = Kp * err + Kd * (err - prev_err);
  prev_err = err;
  prev_spd = spd;
  // Serial.print("Value: ");
  // Serial.println(spd);
  // if(abs(spd)<10){spd = 0;}

  // if (spd < 0){
  //     analogWrite(LEFT_1, 0);
  //     analogWrite(LEFT_2, base - abs(spd));
  // }
  // else{
  //     analogWrite(RIGHT_1, base - abs(spd));
  //     analogWrite(RIGHT_2, 0);
  // }
  // if (!onLine) {
  //   setSpeed(base + 1.5*prev_spd, base - 1.5*prev_spd);
  // }
  // else {
  setSpeed(base + spd, base - spd);
  //}

}
