#include <Arduino.h>

// put function declarations here:

#define sensL 26
#define sensM 27
#define sensR 28

// A = right
// B = left

#define STBY 12

#define AIN1 11
#define AIN2 10
#define BIN1 16
#define BIN2 17

#define PWMA 9
#define PWMB 18

#define PUSH 2

uint8_t calib = 0;
uint8_t start = 0;

void setSpeed(int16_t left, int16_t right)
{
	left = constrain(left, -255, 255);
	right = constrain(right, -255, 255);

	if (left > 0)
	{
		digitalWrite(BIN1, 0);
		digitalWrite(BIN2, 1);
	}
	else
	{
		digitalWrite(BIN1, 1);
		digitalWrite(BIN2, 0);
	}

	if (right > 0)
	{
		digitalWrite(AIN1, 0);
		digitalWrite(AIN2, 1);
	}
	else
	{
		digitalWrite(AIN1, 1);
		digitalWrite(AIN2, 0);
	}

	analogWrite(PWMB, abs(left));
	analogWrite(PWMA, abs(right));
}

int sens_max[3] = {0};
int sens_min[3] = {5000, 5000, 5000};
int sens_meas[3] = {0};

void setup()
{
	// put your setup code here, to run once:
	Serial.begin(115200);
	pinMode(A0, INPUT);
	pinMode(A1, INPUT);
	pinMode(A2, INPUT);

	pinMode(STBY, OUTPUT);
	pinMode(AIN1, OUTPUT);
	pinMode(AIN2, OUTPUT);
	pinMode(BIN1, OUTPUT);
	pinMode(BIN2, OUTPUT);
	pinMode(PWMA, OUTPUT);
	pinMode(PWMB, OUTPUT);

	analogWriteResolution(8);
	//analogReadResolution(12);

	delay(500);

	// Wait for button press
	while (!calib)
	{
		if (digitalRead(PUSH) == 0)
		{
			calib = 1;
		}
		delay(100);
	}

	digitalWrite(STBY, 0);
	setSpeed(0, 0);
	digitalWrite(STBY, 1);

	delay(2000);

	// Sweep left
	setSpeed(50, -50);
	for (uint16_t i = 0; i < 70; i++)
	{
		sens_meas[0] = analogRead(A0);
		sens_meas[1] = analogRead(A1);
		sens_meas[2] = analogRead(A2);

		for (int k = 0; k < 3; k++)
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
		delay(10);
	}

	// Sweep right
	setSpeed(-50, 50);
	for (uint16_t i = 0; i < 140; i++)
	{

		sens_meas[0] = analogRead(A0);
		sens_meas[1] = analogRead(A1);
		sens_meas[2] = analogRead(A2);

		for (int k = 0; k < 3; k++)
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

		delay(10);
	}

	// Return to starting position
	setSpeed(50, -50);
	for (uint16_t i = 0; i < 70; i++)
	{
		delay(10);
	}

	setSpeed(0, 0);
	delay(1000);

	// Print the calibrated min and max values
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

	// Wait for button press
	/*
	while (!start)
	{
		if (digitalRead(PUSH) == 0)
		{
			start = 1;
		}
		delay(100);
	}
	*/
}

int left, center, right;
int line_est, num, denom;

/*
float Kp = 0.8;
float Ki = 0;
float Kd = 0.6;
int16_t spd = 0;
int16_t base = 200;
int16_t err = 0;
int16_t prev_err = 0;
*/

/*
const float Kp = 0.2;
const float Ki = 0;
const float Kd = 0.4;
int16_t base = 100;
*/

const float Kp = 0.4;
const float Ki = 0;
const float Kd = 0.4;
int16_t base = 200;

int16_t spd = 0;
int16_t err = 0;
int16_t prev_err = 0;

int sens [3];
float sens_norm [3];

void loop()
{
	// Read sensor values
	sens[0] = analogRead(A0);
	sens[1] = analogRead(A1);
	sens[2] = analogRead(A2);

	// Normalize sensor values
	for (int k = 0; k < 3; k++)
	{
		if (sens_max[k] != sens_min[k])
		{
			sens_norm[k] = (float)(sens[k] - sens_min[k]) / (sens_max[k] - sens_min[k]); //Map to max and min and scaled to {0,1}
			sens_norm[k] = 1000*sens_norm[k]; //Scaled to {0,1000}
		}
		else
		{
			sens_norm[k] = 0.0; // Handle division by zero case
		}
	}

	num = (int) 0 * sens_norm[0] + 1000 * sens_norm[1] + 2000 * sens_norm[2];
	denom = (int) sens_norm[0] + sens_norm[1] + sens_norm[2];
	line_est = num / denom;

	err = 1000 - line_est;
	spd = Kp * err + Kd * (err - prev_err);

	setSpeed(base - spd, base + spd);

	/*
	Serial.print(sens_norm[0]);
	Serial.print(" ");
	Serial.print(sens_norm[1]);
	Serial.print(" ");
	Serial.print(sens_norm[2]);
	Serial.print(" -- ");
	Serial.println(line_est);
	*/		
	
}
