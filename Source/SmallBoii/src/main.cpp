#include <Arduino.h>

// put function declarations here:

#define sensL 26
#define sensM 27
#define sensR 28

// A = left
// B = right ?

#define STBY 12

#define AIN1 11
#define AIN2 10
#define BIN1 16
#define BIN2 17

#define PWMA 9
#define PWMB 18

void setup()
{
	// put your setup code here, to run once:
	Serial.begin(115200);
	pinMode(A0, INPUT);
	pinMode(A1, INPUT);
	pinMode(A2, INPUT);
	delay(2000);
	/*
	pinMode(STBY, OUTPUT);

	pinMode(AIN1, OUTPUT);
	pinMode(AIN2, OUTPUT);
	pinMode(BIN1, OUTPUT);
	pinMode(BIN2, OUTPUT);

	pinMode(PWMA, OUTPUT);
	pinMode(PWMB, OUTPUT);

	analogWriteResolution(8);

	digitalWrite(AIN1, 1);
	digitalWrite(AIN2, 0);
	analogWrite(PWMA, 255);

	digitalWrite(BIN1, 1);
	digitalWrite(BIN2, 0);
	analogWrite(PWMB, 255);

	digitalWrite(STBY, 1);

	delay(2000);
	
	digitalWrite(STBY, 0);
	*/
}

uint16_t left, center, right;

void loop()
{
	// put your main code here, to run repeatedly:
	left = analogRead(A0);
	center = analogRead(A1);
	right = analogRead(A2);
	delay(500);
	Serial.print(left);
	Serial.print(" ");
	Serial.print(center);
	Serial.print(" ");
	Serial.println(right);
}

// put function definitions here: