# UART Transmitter and Receiver in Verilog HDL

## Overview

This project implements a UART (Universal Asynchronous Receiver Transmitter) Transmitter and Receiver using Verilog HDL.

The design supports:

* 8-bit data transmission
* 1 Start Bit
* 1 Stop Bit
* 9600 Baud Rate
* 50 MHz System Clock

A loopback test was performed by connecting the UART transmitter output directly to the UART receiver input.

## Features

* FSM-based UART Transmitter
* FSM-based UART Receiver
* Parameterized Baud Rate
* Verilog RTL Design
* Functional Verification using Vivado Simulator
* UART Loopback Validation

## Project Structure

rtl/

* uart_tx.v
* uart_rx.v

tb/

* uart_tx_tb.v
* uart_loopback_tb.v

## Simulation Result

Transmitted Byte:
0x55

Received Byte:
0x55

Result:
PASS

## Tools Used

* Verilog HDL
* Xilinx Vivado
* Behavioral Simulation

## Skills Demonstrated

* RTL Design
* Finite State Machines
* Digital Logic Design
* Serial Communication Protocols
* Functional Verification
* FPGA Design Flow

## Future Improvements

* UART FIFO Buffer
* Parity Support
* Configurable Data Width
* APB UART Interface
* FPGA Hardware Validation
