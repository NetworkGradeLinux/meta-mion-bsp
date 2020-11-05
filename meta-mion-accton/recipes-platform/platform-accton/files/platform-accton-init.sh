#!/bin/sh

# SPDX-License-Identifier: MIT 

function set_clocksouce() {
	echo tsc > /sys/devices/system/clocksource/clocksource0/current_clocksource
}

function enable_tx() {
	# Set Module TX-Disable Registers
	i2cset -y 2 0x33 0x08 0x00
	i2cset -y 2 0x33 0x09 0x00
	i2cset -y 2 0x33 0x0a 0x00
	i2cset -y 2 0x33 0x0b 0x00
	i2cset -y 2 0x33 0x0c 0x00
	i2cset -y 2 0x33 0x0d 0x00
}

function wait_for_file() {
	FILE=$1
	i=0
	while [ $i -lt 10 ]; do
		test -e $FILE && return 0
		i=$(( i + 1 ))
		sleep 1
	done
	return 1
}

wait_for_file /sys/bus/i2c/devices/0-0069 && set_clocksouce
wait_for_file /sys/bus/i2c/devices/i2c-2 && enable_tx
