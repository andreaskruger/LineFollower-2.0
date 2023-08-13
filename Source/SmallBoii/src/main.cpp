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

uint8_t start = 0;

void setSpeed(int16_t left, int16_t right) {
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

void setup()
{
	// put your setup code here, to run once:
	Serial.begin(115200);
	pinMode(A0, INPUT);
	pinMode(A1, INPUT);
	pinMode(A2, INPUT);
	delay(500);

	
	while (!start)
	{
		if (digitalRead(PUSH) == 0)
		{
			start = 1;
		}
		delay(100);
	}

	delay(2000);

	pinMode(STBY, OUTPUT);

	pinMode(AIN1, OUTPUT);
	pinMode(AIN2, OUTPUT);
	pinMode(BIN1, OUTPUT);
	pinMode(BIN2, OUTPUT);

	pinMode(PWMA, OUTPUT);
	pinMode(PWMB, OUTPUT);

	analogWriteResolution(8);

	digitalWrite(STBY, 0);
	setSpeed(0, 0);
	digitalWrite(STBY, 1);

	
	//setSpeed(-255, 255);
	//delay(2000);
	//setSpeed(0, 0);

	/*
	//forward
	digitalWrite(AIN1, 0);
	digitalWrite(AIN2, 1);
	analogWrite(PWMA, 255);

	//forward
	digitalWrite(BIN1, 0);
	digitalWrite(BIN2, 1);
	analogWrite(PWMB, 255);
	
	digitalWrite(STBY, 1);

	delay(5000);

	digitalWrite(STBY, 0);
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

float Kp = 0.2;
float Ki = 0;
float Kd = 0.4;
int16_t spd = 0;
int16_t base = 100;
int16_t err = 0;
int16_t prev_err = 0;


void loop()
{
	// put your main code here, to run repeatedly:
	left = analogRead(A0);
	center = analogRead(A1);
	right = analogRead(A2);
	delay(10);

	num = 0*left + 1000*center + 2000*right;
	denom = left + center + right;
	line_est = num / denom;

	err = 1000 - line_est;
	spd = Kp*err +  Kd*(err-prev_err);
	
	setSpeed(base-spd, base+spd);
	
	/*
	Serial.print(left);
	Serial.print(" ");
	Serial.print(center);
	Serial.print(" ");
	Serial.print(right);
	Serial.print(" -- ");
	Serial.println(line_est);
	*/
}



// put function definitions here: