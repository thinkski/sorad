@echo off
REM #--------------------------------------------------------------------------
REM #	File:		BUILD.BAT
REM #	Contents:	Batch file to build firmware
REM #
REM # $Archive: /USB/Target/Fw/fx2lp/build.bat $
REM # $Date: 9/01/03 2:17p $
REM # $Revision: 1 $
REM #
REM #
REM #-----------------------------------------------------------------------------
REM # Copyright 2003, Cypress Semiconductor Corporation
REM #
REM # This software is owned by Cypress Semiconductor Corporation (Cypress) and is
REM # protected by United States copyright laws and international treaty provisions. Cypress
REM # hereby grants to Licensee a personal, non-exclusive, non-transferable license to copy,
REM # use, modify, create derivative works of, and compile the Cypress Source Code and
REM # derivative works for the sole purpose of creating custom software in support of Licensee
REM # product ("Licensee Product") to be used only in conjunction with a Cypress integrated
REM # circuit. Any reproduction, modification, translation, compilation, or representation of this
REM # software except as specified above is prohibited without the express written permission of
REM # Cypress.
REM #
REM # Disclaimer: Cypress makes no warranty of any kind, express or implied, with regard to
REM # this material, including, but not limited to, the implied warranties of merchantability and
REM # fitness for a particular purpose. Cypress reserves the right to make changes without
REM # further notice to the materials described herein. Cypress does not assume any liability
REM # arising out of the application or use of any product or circuit described herein. Cypress’
REM # products described herein are not authorized for use as components in life-support
REM # devices.
REM #
REM # This software is protected by and subject to worldwide patent coverage, including U.S.
REM # and foreign patents. Use may be limited by and subject to the Cypress Software License
REM # Agreement.
REM #-----------------------------------------------------------------------------

REM # command line switches
REM # ---------------------
REM # -clean delete temporary files

REM ### Compile FrameWorks code ###
c51 fw.c debug objectextend code small moddp2 id(..\..\Inc)

REM ### Compile user peripheral code ###
REM ### Note: This code does not generate interrupt vectors ###
c51 periph.c db oe code small moddp2 noiv id(..\..\Inc)

REM ### Assemble descriptor table ###
a51 dscr.a51 errorprint debug

REM ### Link object code (includes debug info) ###
REM ### Note: XDATA and CODE must not overlap ###
REM ### Note: using a response file here for line longer than 128 chars
echo fw.obj, dscr.obj, periph.obj, > tmp.rsp
echo ..\..\Lib\LP\USBJmpTb.obj, >> tmp.rsp
echo ..\..\Lib\LP\EZUSB.lib  >> tmp.rsp
echo TO fw RAMSIZE(256) PL(68) PW(78) CODE(80h) XDATA(1000h)  >> tmp.rsp
bl51 @tmp.rsp

REM ### Generate intel hex image of binary (no debug info) ###
oh51 fw HEXFILE(fw.hex)

REM ### Generate serial eeprom image for C2 bootload ###
if "%1" == "-i" %CYUSB%\Bin\hex2bix -i -f 0xC2 -o fw.c2 fw.hex

REM ### usage: build -clean to remove intermediate files after build
if "%1" == "-clean" del tmp.rsp
if "%1" == "-clean" del *.lst
if "%1" == "-clean" del *.obj
if "%1" == "-clean" del *.m51

