/*
 * FSM.h
 *
 *  Created on: Apr 19, 2024
 *      Author: Andreas
 */

#ifndef INC_FSM_H_
#define INC_FSM_H_

/*Includes*/
#include "main.h"
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
/*Prototypes*/

/**
 * @brief Runs the state machine
 * @note
 * @param
 */
void run_fsm(void);

/**
 * @brief clamps sensor readings to calibration min/max
 * @note
 * @param
 */
void read_calibrated();

/**
 * @brief Read all sensors
 * @note
 * @param
 */
void read_sensor(void);

/**
 * @brief Calibrate sensors
 * @note
 * @param
 */
void cal_sensors(void);


/**
 * @brief PID calculations using sensor values
 * @note
 * @param
 */
int32_t PID(int32_t);

/**
 * @brief Sets speed to the motors
 * @note
 * @param
 */
void set_motor_speed(float left, float right);

/**
 * @brief Finds the line value
 * @note
 * @param
 */
int32_t get_line();
#endif /* INC_FSM_H_ */



