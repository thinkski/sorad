Sorad
=====

A homebrew software radio that is so radicool:

* Plenty of space for custom IP middleware: 500k gate FPGA
* Fast: 125 Msps ADC
* Plays nice: 50 ohm input impedance
* Pre-amplifies: 20 dB LNA
* Filters: 2nd-order low-pass
* 70 dB dynamic range
* IEEE 1149 JTAG BSP
* Fat pipe: 480 Mbps USB
* Reconfigurable: FPGA configures over USB

Hardware
--------

The hardware consists primarily of a field programmable gate array (FPGA),
an analog-to-digital converter (ADC), and a USB 2.0 microcontroller.

RF from the antenna is amplified by a low noise amplifier (LNA) and filtered
by a second-order low-pass filter. The ADC then digitizes the signal into the
FPGA.

The FPGA can act as a conduit, in which case it simply clocks the digitized
RF into the USB endpoint for transmission to the host Mac. The FPGA can also
down-convert the RF using a cascaded integrator-comb (CIC) filter and
numerically controlled oscillator (NCO), useful for sample rates beyond
10Msps.

Software
--------

The software consists of Cocoa / OpenGL applications which do visualization
and demodulation. A user-space device driver is included with each application.

Two applications are currently available for sorad, a spectrum analyzer and
a spectrogrammer.

Other applications, such as an oscilloscope, am/fm radio, etc. may be
developed in the future.
