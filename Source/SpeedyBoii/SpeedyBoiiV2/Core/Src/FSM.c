/*
 * FSM.c
 *
 *  Created on: Apr 19, 2024
 *      Author: Andreas
 */


/*Includes*/
#include "FSM.h"

/*Defines*/
#define NR_OF_SENSORS (5)							/*Number of sensors in use*/
#define LINE_REF (1)								/*Refernce value for the line*/
#define BASE (0.7f)									/*Base speed for motors*/
#define _maxValue 5000
#define NR_OF_CALIBRATIONS 2000						/*Number of sensor calibrations, 1 ms per nr of calibration*/

/*Variables*/
int32_t sensor_val[NR_OF_SENSORS] = {0};				/*Variable to save sensor readings*/
float Kp = 1.0f;
float Kd = 0.0f;
float Ki = 0.0f;

int32_t num = 0;										/*Used in "get_line()"*/
int32_t denom = 0;										/*Used in "get_line()"*/

int currentTime = 0;
int prevTime = 0;

uint16_t calibration_maximum[NR_OF_SENSORS];	    /*Maximum value from all calibrations per sensor*/
uint16_t calibration_minimum[NR_OF_SENSORS];		/*Minimum value from all calibrations per sensor*/

extern ADC_HandleTypeDef hadc1;
extern TIM_HandleTypeDef htim2;
extern TIM_HandleTypeDef htim3;


enum fsm_state_e {fsm_state_startup = 0, fsm_state_cal, fsm_state_wait, fsm_state_run, fsm_state_err};
enum fsm_state_e state = fsm_state_startup;

void read_sensor(){
	for(size_t i = 0; i < NR_OF_SENSORS; i++){
		HAL_GPIO_WritePin(GPIOA, S0_Pin, (i & 0x01));
		HAL_GPIO_WritePin(GPIOC, S1_Pin, (i >> 1) & 0x01);
		HAL_GPIO_WritePin(GPIOC, S2_Pin, (i >> 2) & 0x01);
		HAL_GPIO_WritePin(GPIOC, S3_Pin, (i >> 3) & 0x01);
		HAL_ADC_Start(&hadc1);
		HAL_ADC_PollForConversion(&hadc1, 100);
		sensor_val[i] = HAL_ADC_GetValue(&hadc1);

		//TODO: Ingen aning om det här stämmer, taget från git.
		uint16_t denominator = calibration_maximum - calibration_minimum;
		int16_t value = 0;

		if (denominator != 0){
			value = (((int32_t)sensor_val[i]) - (int32_t)calibration_minimum) * 1000 / denominator;
		}
		if (value < 0) { value = 0; }
		else if (value > 1000){value = 1000;}
		sensor_val[i] = value;
	}
}



void cal_sensors(){
	uint16_t maxSensorValues[NR_OF_SENSORS];
	uint16_t minSensorValues[NR_OF_SENSORS];

	for(size_t i = 0; i < NR_OF_SENSORS; i++){
		maxSensorValues[i] = 0;
		minSensorValues[i] = _maxValue;
	}
	for (size_t j = 0; j < NR_OF_CALIBRATIONS; j++){
		read_sensor();
		for (size_t i = 0; i < NR_OF_SENSORS; i++){
			if((sensor_val[i] > maxSensorValues[i])){
				maxSensorValues[i] = sensor_val[i];
			}
			if((sensor_val[i] < minSensorValues[i])){
				minSensorValues[i] = sensor_val[i];
			}
		}
		HAL_Delay(1);
	}
	for (size_t i = 0; i < NR_OF_SENSORS; i++){
		calibration_maximum[i] = maxSensorValues[i];
		calibration_minimum[i] = minSensorValues[i];
	}
}

int32_t get_line(){
	num = 0;
	denom = 0;
	for(size_t i = 0; i < 5; i++){
		num += sensor_val[i]*(i)*1000;
		denom += sensor_val[i];
	}
	return num/denom;
}


int32_t PID(int32_t error){
	int32_t speed = error*Kp + Kd*(error);
	return speed;
}

void set_motor_speed(float left, float right){

	int32_t leftPwm = (int32_t) (left*65535);
	int32_t rightPwm = (int32_t) (right*65535);

	if (leftPwm >= 0) {
		TIM3->CCR1 = leftPwm;
		TIM3->CCR2 = 0;
	}
	else {
		TIM3->CCR1 = 0;
		TIM3->CCR2 = -leftPwm;
	}
	if (rightPwm >= 0) {
		TIM2->CCR1 = rightPwm;
		TIM2->CCR2 = 0;
	}
	else {
		TIM2->CCR1 = 0;
		TIM2->CCR2 = -rightPwm;
	}
}

//TODO: Slutför calibration
//TODO: Använd calibration vid sensorläsning
//TODO: Kolla get_line()
//TODO: Sätt in line_est värde och skicka in värden i set_motor_Speed.
//TODO: Tune PID

void run_fsm(void){
	switch(state){
		case fsm_state_startup:
			HAL_TIM_PWM_Start(&htim3, TIM_CHANNEL_1);
			HAL_TIM_PWM_Start(&htim3, TIM_CHANNEL_2);

			HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_1);
			HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_2);
			state = fsm_state_cal;
			break;
		case fsm_state_cal:
			cal_sensors();
			state = fsm_state_wait;
			break;
		case fsm_state_wait:
			while(HAL_GPIO_ReadPin(Button_GPIO_Port, Button_Pin) == 1){HAL_Delay(1);}
			state = fsm_state_run;
			break;
		case fsm_state_run:
			read_sensor();
			int32_t line_est = get_line();
			set_motor_speed(0.9f, 0.9f);
			break;
		default:
			break;
	}
}

