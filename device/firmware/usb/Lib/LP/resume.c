//-----------------------------------------------------------------------------
// File: resume.c
// Contents: function to wake-up the host after a resume 
//
// $Archive: /USB/Target/Lib/lp/resume.c $
// $Date: 3/23/05 2:51p $
// $Revision: 2 $
//
//
//-----------------------------------------------------------------------------
// Copyright 2003, Cypress Semiconductor Corporation
//
// This software is owned by Cypress Semiconductor Corporation (Cypress) and is
// protected by United States copyright laws and international treaty provisions. Cypress
// hereby grants to Licensee a personal, non-exclusive, non-transferable license to copy,
// use, modify, create derivative works of, and compile the Cypress Source Code and
// derivative works for the sole purpose of creating custom software in support of Licensee
// product ("Licensee Product") to be used only in conjunction with a Cypress integrated
// circuit. Any reproduction, modification, translation, compilation, or representation of this
// software except as specified above is prohibited without the express written permission of
// Cypress.
//
// Disclaimer: Cypress makes no warranty of any kind, express or implied, with regard to
// this material, including, but not limited to, the implied warranties of merchantability and
// fitness for a particular purpose. Cypress reserves the right to make changes without
// further notice to the materials described herein. Cypress does not assume any liability
// arising out of the application or use of any product or circuit described herein. Cypress�
// products described herein are not authorized for use as components in life-support
// devices.
//
// This software is protected by and subject to worldwide patent coverage, including U.S.
// and foreign patents. Use may be limited by and subject to the Cypress Software License
// Agreement.
//-----------------------------------------------------------------------------
#include <fx2.h>
#include <fx2regs.h>

void EZUSB_Resume(void)
{
	if( ((WAKEUPCS & bmWUEN)&&(WAKEUPCS & bmWU)) ||   // Check status AND Enable
		((WAKEUPCS & bmWU2EN)&&(WAKEUPCS & bmWU2)) )
	{
		USBCS |= bmSIGRESUME;
		EZUSB_Delay(20);
		USBCS &= ~bmSIGRESUME;
	}
}
