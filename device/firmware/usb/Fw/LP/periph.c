/*------------------------------ PROPRIETARY -------------------------------*/

/* NAME
 *	periph.c
 *
 * DESCRIPTION
 *	This file contains hooks required to implement USB peripheral
 *	functions.
 *
 *	This file is a derivative work of periph.c distributed by Cypess
 *	Semiconductor Corporation in the FX2LP Development Kit FrameWorks
 *	software.
 *
 * AUTHORS
 * 	Cypress Semiconductor Corporation and
 * 	Chris Hiszpanski <chiszp@gmail.com>
 *
 * Mar 23 2005	Last noted modification by Cypress Semiconductor Corporation.
 * May 27 2008	Implemented FPGA configuration code. Not tested. (cphiszp)
 * Nov 14 2008	Changed device name from 'Bootloader' to 'SoRAD' in dscr.a51.
 *		Changes from May 27 2007 also work. (cphiszp)
 * Nov 15 2008	Added EP2CFG and EP2ISOINPKTS register initialization.
 *		(cphiszp)
 */

/* Do not generate interrupt vectors */
#pragma NOIV


/*-------------------------------- Includes --------------------------------*/

#include "fx2.h"
#include "fx2regs.h"
#include "syncdly.h"			/* Synchronization delay macro      */


/*---------------------------- Shared Variables ----------------------------*/

extern	BOOL	GotSUD;			/* Received setup data flag         */
extern	BOOL	Sleep;
extern	BOOL	Rwuen;
extern	BOOL	Selfpwr;

typedef enum {				/* State type definition            */
		PROG_LOW,
		PROG_HIGH,
		WAIT_FOR_INIT,
		WAIT_FOR_DONE
} STATE_T;

STATE_T	State;				/* Finite state machine state       */
BYTE	Count;				/* Delay counter                    */

BYTE	Configuration;			/* Current configuration            */
BYTE	AlternateSetting;		/* Alternate settings               */


/*------------------------- Task Dispatcher Hooks --------------------------*/

/* NAME
 *	TD_Init
 *	
 * DESCRIPTION
 * 	Called once at start-up.
 *
 *	Configures select PORT A pins as input/output, later used to
 *	configure the FPGA.
 *
 * ARGUMENTS
 * 	None.
 *
 *  RETURN
 *  	None.
 *
 * May 16 2008	Imported and modified FrameWorks code.
 * May 27 2008	Implemented initialization code for FPGA configuration.
 * Nov 15 2008	Added isochronous endpoint 2 initialization.
 */

void TD_Init (void)
{
//	int	i,j;

	/* CPU Control and Status:		48 MHz */
	CPUCS = ((CPUCS & ~bmCLKSPD) | bmCLKSPD1);

	/* Initialize variables */
	AlternateSetting = 0;

	REVCTL = 0x3;
	SYNCDELAY;

	/* Disable all endpoints */
	EP1OUTCFG = EP1INCFG = EP2CFG = EP4CFG = EP6CFG = EP8CFG = 0;
	SYNCDELAY;

	/* Interface Configuration:
	 * 1------- clock:			internal
	 * -1------ clock frequency:		48 MHz
	 * --0----- clock output enable:	disable
	 * ---0---- clock polarity:		not applicable
	 * ----1--- fifo mode:			asynchronous
	 * -----0-- drive gstate on port e:	disable
	 * ------00 mode: 		        ports
	 */
	IFCONFIG     = 0xC8;
	SYNCDELAY;

	USBIE |= bmSOF;

        /* Enable remote-wakeup */
        Rwuen = TRUE;
}

/* NAME
 * 	TD_Poll
 *
 * DESCRIPTION
 * 	Called repeatedly while the device is idle.
 *
 * ARGUMENTS
 * 	None.
 *
 * RETURN
 * 	None.
 *
 * May 16 2008	Imported and modified FrameWorks code.
 * May 27 2008	Implemented FPGA configuration finite state machine.
 * Nov 17 2008	Added condition to check for alt. interface 1
 */

void TD_Poll (void)
{
	/* verify that using fpga configuration interface */
	if (AlternateSetting == 1) {

		switch (State)
		{
	                /* Assert PROG_B pin on FPGA for >= 500ns */
			case PROG_LOW:
	                        /* Note the inverter between uC and PROG_B */
				IOA |= bmBIT3;
				Count++;
				if (Count > 25)
				{
					Count = 0;
					State = PROG_HIGH;
				}
				break;
	
	                /* De-assert PROG_B pin on FPGA */
			case PROG_HIGH:
				IOA &= ~(bmBIT3);
				State = WAIT_FOR_INIT;
				break;
	
	                /* Clock FPGA until its INIT_B pin is de-asserted */
			case WAIT_FOR_INIT:
				/* Toggle configuration clock */
	                        if (IOA & bmBIT0) {
	        			IOA = (IOA & bmBIT6) ? IOA & ~bmBIT6 : IOA | bmBIT6;
	                        }
	
	
				IOA = (IOA & bmBIT0) ? IOA & ~bmBIT0 : IOA | bmBIT0;
	
	
				/* Change state when INIT_B goes high */
				if (IOA & bmBIT7)
				{
					State = WAIT_FOR_DONE;
				}
				break;
	
	                /* Clock in data via interrupt service routine */
	                case WAIT_FOR_DONE:
	                        break;
		}
	}
}


/* NAME
 * 	TD_Suspend
 *
 * DESCRIPTION
 * 	Called before the device goes into suspend mode.
 *
 * ARGUMENTS
 * 	None.
 *
 * RETURN
 * 	True.
 *
 * May 16 2008	Imported and modified FrameWorks code.
 */

BOOL TD_Suspend (void)
{
	return(TRUE);
}


/* NAME
 * 	TD_Resume
 *
 * DESCRIPTION
 * 	Called after the device resumes.
 *
 * ARGUMENTS
 * 	None.
 *
 * RETURN
 * 	True.
 *
 * May 16 2008	Imported and modified FrameWorks code.
 */

BOOL TD_Resume (void)
{
	return(TRUE);
}

//----------------------------------------------------------------------------
// Device Request hooks
//   The following hooks are called by the end point 0 device request parser.
//----------------------------------------------------------------------------

BOOL DR_GetDescriptor(void)
{
   return(TRUE);
}

// Called when a Set Configuration command is received
BOOL DR_SetConfiguration(void)
{
   Configuration = SETUPDAT[2];
   return(TRUE);			// Handled by user code
}

// Called when a Get Configuration command is received
BOOL DR_GetConfiguration(void)
{
   EP0BUF[0] = Configuration;
   EP0BCH = 0;
   EP0BCL = 1;
   return(TRUE);			// Handled by user code
}

// Called when a Set Interface command is received
BOOL DR_SetInterface(void)
{
	/* store alternate setting for use outside this function */
	AlternateSetting = SETUPDAT[2];

	switch (AlternateSetting) {
		/* alternate interface for fpga configuration */
		case 1:
			/* initialize variables */
			State = PROG_LOW;
			Count = 0;

			/* Interface Configuration:
			 * ------00 mode: 		        ports
			 */
			IFCONFIG     = (IFCONFIG & 0xFC);
			SYNCDELAY;

			/* Ensure PORT A is in input/output mode */
			PORTACFG = 0;
		
			/* Set output levels:
			 * 	PA0 (CCLK)	low
			 * 	PA3 (PROG_B)	high (in-active)
			 * 	PA6 (DIN)	low
			 */
			IOA = bmBIT3;
		
			/* Set input/output pin directions:
			 * 	PA0 (CCLK)	output
			 * 	PA1 (DONE)	input
			 * 	PA3 (PROG_B)	output
			 * 	PA6 (DIN)	output
			 * 	PA7 (INIT_B)	input
			 */
			OEA = bmBIT6 | bmBIT3 | bmBIT0;


		        /* Configurure endpoints */
		        EP1OUTCFG    = 0xA0;    /* single buffered                           */
		        EP1INCFG     = 0xA0;	/* single buffered                           */

			/* Disable other endpoints */
			EP2CFG       = (EP2CFG & 0x7F);
			EP4CFG       = (EP4CFG & 0x7F);
			EP6CFG       = (EP6CFG & 0x7F);
			EP8CFG       = (EP8CFG & 0x7F);

		        /* Output endpoints are not armed by default -- arm EP1OUT */
		        EP1OUTBC = 0x40;
		
			/* Enable output endpoint 1 USB interrupts */
			EPIE |= bmBIT3;
		        /* Enable input endpoint 1 USB interrupts */
		        EPIE |= bmBIT2;

			break;

		/* alternate interface for isochronous sample transmission */
		case 2:
			/* Disable endpoint 1 USB interrupts */
			EPIE &= ~(bmBIT3 | bmBIT2);

			/* Interface Configuration:
			 * ------11 mode: 		        slave fifos
			 */
			IFCONFIG     = (IFCONFIG & 0xFC) | 0x3;
			SYNCDELAY;
		
			/* Endpoint 2 configuration:
			 * 1------- valid:			enable
			 * -1------ direction:			in
			 * --01---- type:			isochronous
			 * ----1--- size:			1024 bytes
			 * ------00 buffering:			quad
			 */
			EP2CFG       = 0xD8;
			SYNCDELAY;

			/* Disable other endpoints */
			EP1INCFG = EP1OUTCFG = EP4CFG = EP6CFG = EP8CFG = 0;
			SYNCDELAY;

			/* Clear out any committed packets */
			FIFORESET    = 0x80;	/* nak all transactions     */
			SYNCDELAY;
			FIFORESET    = 0x02;	/* reset endpoint 2 fifo    */
			SYNCDELAY;
			FIFORESET    = 0x00;	/* restore normal operation */
			SYNCDELAY;

			/* Endpoint 2 / slave FIFO configuration
			 * -0------ in FULL flag minus 1:	disable
			 * --0----- out EMPTY flag plus 1:	disable
			 * ---0---- auto out:			disable
			 * ----1--- auto in:			enable
			 * -----1-- zero length in:		enable
			 * -------1 wordwide:			enable
			 */
			EP2FIFOCFG   = 0x0D;
			SYNCDELAY;
		
			/* Endpoint 2 AUTOIN Packet Length H */
			EP2AUTOINLENH = 0x04;
			SYNCDELAY;
		
			/* Endpoint 2 AUTOIN Packet Length L */
			EP2AUTOINLENL = 0x00;
			SYNCDELAY;

			/* Endpoint 2 Isochronous IN Packets
			 * 1------- auto adjust:		enable
			 * ------11 packets per micro-frame:	3
			 */
			EP2ISOINPKTS = 0x83;
			break;

		/* alternate interface for re-numerating EZ-USB firmware */
		default:
			/* Disable endpoint 1 USB interrupts */
			EPIE &= ~(bmBIT3 | bmBIT2);

			/* Disable all endpoints */
			EP1INCFG      = (EP1INCFG & 0x7F);
			EP1OUTCFG     = (EP1OUTCFG & 0x7F);
			EP2CFG        = (EP2CFG & 0x7F);
			EP4CFG        = (EP4CFG & 0x7F);
			EP6CFG        = (EP6CFG & 0x7F);
			EP8CFG        = (EP8CFG & 0x7F);			
			break;
	}

	return(TRUE);			// Handled by user code
}

// Called when a Get Interface command is received
BOOL DR_GetInterface(void)
{
   EP0BUF[0] = AlternateSetting;
   EP0BCH = 0;
   EP0BCL = 1;
   return(TRUE);			// Handled by user code
}

BOOL DR_GetStatus(void)
{
   return(TRUE);
}

BOOL DR_ClearFeature(void)
{
   return(TRUE);
}

BOOL DR_SetFeature(void)
{
   return(TRUE);
}

BOOL DR_VendorCmnd(void)
{
   return(TRUE);
}

//----------------------------------------------------------------------------
// USB Interrupt Handlers
//   The following functions are called by the USB interrupt jump table.
//----------------------------------------------------------------------------

// Setup Data Available Interrupt Handler
void ISR_Sudav(void) interrupt 0
{
   GotSUD = TRUE;            // Set flag
   EZUSB_IRQ_CLEAR();
   USBIRQ = bmSUDAV;         // Clear SUDAV IRQ
}

// Setup Token Interrupt Handler
void ISR_Sutok(void) interrupt 0
{
   EZUSB_IRQ_CLEAR();
   USBIRQ = bmSUTOK;         // Clear SUTOK IRQ
}

void ISR_Sof(void) interrupt 0
{
   EZUSB_IRQ_CLEAR();
   USBIRQ = bmSOF;            // Clear SOF IRQ
}

void ISR_Ures(void) interrupt 0
{
   // whenever we get a USB reset, we should revert to full speed mode
   pConfigDscr = pFullSpeedConfigDscr;
   ((CONFIGDSCR xdata *) pConfigDscr)->type = CONFIG_DSCR;
   pOtherConfigDscr = pHighSpeedConfigDscr;
   ((CONFIGDSCR xdata *) pOtherConfigDscr)->type = OTHERSPEED_DSCR;
   
   EZUSB_IRQ_CLEAR();
   USBIRQ = bmURES;         // Clear URES IRQ
}

void ISR_Susp(void) interrupt 0
{
   Sleep = TRUE;
   EZUSB_IRQ_CLEAR();
   USBIRQ = bmSUSP;
}

void ISR_Highspeed(void) interrupt 0
{
   if (EZUSB_HIGHSPEED())
   {
      pConfigDscr = pHighSpeedConfigDscr;
      ((CONFIGDSCR xdata *) pConfigDscr)->type = CONFIG_DSCR;
      pOtherConfigDscr = pFullSpeedConfigDscr;
      ((CONFIGDSCR xdata *) pOtherConfigDscr)->type = OTHERSPEED_DSCR;
   }

   EZUSB_IRQ_CLEAR();
   USBIRQ = bmHSGRANT;
}
void ISR_Ep0ack(void) interrupt 0
{
}
void ISR_Stub(void) interrupt 0
{
}
void ISR_Ep0in(void) interrupt 0
{
}
void ISR_Ep0out(void) interrupt 0
{
}


/* NAME
 *      ISR_Ep1in
 *
 * DESCRIPTION
 *      This interrupt is triggered when the host has received
 *      the feedback sent by ISR_Ep1out. Upon this event, this
 *      handler re-arms the EP1OUT endpoint to accept another
 *      buffer.
 *
 * ARGUMENTS
 *      None.
 *
 * RETURN
 *      None.
 *
 * Nov 17 2008	Added condition to check that using alt. interface 1.
 */

void ISR_Ep1in(void) interrupt 0
{
	if (AlternateSetting == 1) {
	        /* Writing any value (in this case the endpoint size) re-arms */
	        EP1OUTBC = 64;
	}
	        /* Clear the interrupt */
	        EZUSB_IRQ_CLEAR();
	        EPIRQ = bmBIT2;
}


/* NAME
 *      ISR_Ep1out
 *
 * DESCRIPTION
 *      This interrupt is triggered when the EP1OUT endpoint receives a
 *      buffer. The buffer is written, bit by bit, MSB first starting with
 *      byte zero to the FPGA. The CCLK signal is also generated, with the
 *      rising edge denoting the clocking edge.
 *
 *      A feedback signal is sent to the host over EP1IN. The first byte of
 *      the feedback buffer denotes the level of the DONE signal. The second
 *      byte denotes the level of the INIT_B signal. 
 * ARGUMENTS
 *      None.
 *
 * RETURN
 *      None.
 *
 * Nov 17 2008	Added condition to check that using alt. interface 1.
 */

void ISR_Ep1out(void) interrupt 0
{
	/* Local (stack) variables */
	BYTE i, j;


	if (AlternateSetting == 1) {
		/* Clock out buffer to FPGA */
		for (i = 0; i < EP1OUTBC; i++)
		{
			/* Clock out bits */
			for (j = 0; j < 8; j++)
			{
				/* Generate falling clock edge */
				IOA &= ~bmBIT0;
	
				/* Output bit on DIN */
				IOA = (EP1OUTBUF[i] & (0x80 >> j)) ?
						IOA | bmBIT6 : IOA & ~bmBIT6;
	
				/* Clock in bit (generate rising clock edge) */
				IOA |= bmBIT0;
			}
		}
	
	        /* Signal to host state of DONE and INIT_B */
	        if (!(EP1INCS & bmEPBUSY)) {
	                EP1INBUF[0] = (IOA & bmBIT1) ? 1 : 0;
	                EP1INBUF[1] = (IOA & bmBIT7) ? 1 : 0;
	                EP1INBC     = 2;
	        }
	}

	/* Clear interrupt request */
	EZUSB_IRQ_CLEAR();
	EPIRQ = bmBIT3;
}


void ISR_Ep2inout(void) interrupt 0
{
}
void ISR_Ep4inout(void) interrupt 0
{
}
void ISR_Ep6inout(void) interrupt 0
{
}
void ISR_Ep8inout(void) interrupt 0
{
}
void ISR_Ibn(void) interrupt 0
{
}
void ISR_Ep0pingnak(void) interrupt 0
{
}
void ISR_Ep1pingnak(void) interrupt 0
{
}
void ISR_Ep2pingnak(void) interrupt 0
{
}
void ISR_Ep4pingnak(void) interrupt 0
{
}
void ISR_Ep6pingnak(void) interrupt 0
{
}
void ISR_Ep8pingnak(void) interrupt 0
{
}
void ISR_Errorlimit(void) interrupt 0
{
}
void ISR_Ep2piderror(void) interrupt 0
{
}
void ISR_Ep4piderror(void) interrupt 0
{
}
void ISR_Ep6piderror(void) interrupt 0
{
}
void ISR_Ep8piderror(void) interrupt 0
{
}
void ISR_Ep2pflag(void) interrupt 0
{
}
void ISR_Ep4pflag(void) interrupt 0
{
}
void ISR_Ep6pflag(void) interrupt 0
{
}
void ISR_Ep8pflag(void) interrupt 0
{
}
void ISR_Ep2eflag(void) interrupt 0
{
}
void ISR_Ep4eflag(void) interrupt 0
{
}
void ISR_Ep6eflag(void) interrupt 0
{
}
void ISR_Ep8eflag(void) interrupt 0
{
}
void ISR_Ep2fflag(void) interrupt 0
{
}
void ISR_Ep4fflag(void) interrupt 0
{
}
void ISR_Ep6fflag(void) interrupt 0
{
}
void ISR_Ep8fflag(void) interrupt 0
{
}
void ISR_GpifComplete(void) interrupt 0
{
}
void ISR_GpifWaveform(void) interrupt 0
{
}

/*------------------------------ PROPRIETARY -------------------------------*/
