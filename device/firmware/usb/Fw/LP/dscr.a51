;;-----------------------------------------------------------------------------
;;   File:      dscr.a51
;;   Contents:  This file contains descriptor data tables.
;;
;; $Archive: /USB/Examples/Fx2lp/bulkloop/dscr.a51 $
;; $Date: 9/01/03 8:51p $
;; $Revision: 3 $
;;
;;
;; Nov 15 2008	Added EP2IN isochronous endpoint and adjusted number of
;;		endpoints accordingly (cphiszp).
;; Nov 17 2008	Moved EP2IN isochronous endpoint to alt. interface 1 on same
;;		interface i.e. interface 0. This frees up memory for quad
;;		buffering, likely necessary for high-bandwidth endpoint with
;;		three packets per micro-frame (cphiszp).
;;
;;-----------------------------------------------------------------------------
;; Copyright 2003, Cypress Semiconductor Corporation
;;-----------------------------------------------------------------------------
;;-----------------------------------------------------------------------------
   
DSCR_DEVICE   equ   1   ;; Descriptor type: Device
DSCR_CONFIG   equ   2   ;; Descriptor type: Configuration
DSCR_STRING   equ   3   ;; Descriptor type: String
DSCR_INTRFC   equ   4   ;; Descriptor type: Interface
DSCR_ENDPNT   equ   5   ;; Descriptor type: Endpoint
DSCR_DEVQUAL  equ   6   ;; Descriptor type: Device Qualifier

DSCR_DEVICE_LEN   equ   18
DSCR_CONFIG_LEN   equ    9
DSCR_INTRFC_LEN   equ    9
DSCR_ENDPNT_LEN   equ    7
DSCR_DEVQUAL_LEN  equ   10

ET_CONTROL   equ   0   ;; Endpoint type: Control
ET_ISO       equ   1   ;; Endpoint type: Isochronous
ET_BULK      equ   2   ;; Endpoint type: Bulk
ET_INT       equ   3   ;; Endpoint type: Interrupt

public      DeviceDscr, DeviceQualDscr, HighSpeedConfigDscr, FullSpeedConfigDscr, StringDscr, UserDscr

DSCR   SEGMENT   CODE PAGE

;----------------------------------------------------------------------------
; Global Variables
;----------------------------------------------------------------------------
      rseg DSCR      ;; locate the descriptor table in on-part memory.

DeviceDscr:   
	db	DSCR_DEVICE_LEN		; Descriptor length
	db	DSCR_DEVICE		; Decriptor type
	dw	0002H			; Specification Version (BCD)
	db	0ffH			; Device class (vendor specific)
	db	0ffH			; Device sub-class (vendor specific)
	db	0ffH			; Device sub-sub-class
	db	64			; Maximum packet size for EP0
	dw	6666H			; Vendor ID (prototype = 6666h)
	dw	0100H			; Product ID (little endian)
	dw	0000H			; Product version ID
	db	1			; Manufacturer string index
	db	2			; Product string index
	db	0			; Serial number string index
	db	1			; Number of configurations

DeviceQualDscr:
	db	DSCR_DEVQUAL_LEN	; Descriptor length
	db	DSCR_DEVQUAL		; Decriptor type
	dw	0002H			; Specification Version (BCD)
	db	0ffH			; Device class (vendor specific)
	db	0ffH			; Device sub-class (vendor specific)
	db	0ffH			; Device sub-sub-class (vendor spec.)
	db	64			; Maximum packet size for other speed
	db	1			; Number of other configurations
	db	0			; Reserved


HighSpeedConfigDscr:   
	db	DSCR_CONFIG_LEN		; Descriptor length
	db	DSCR_CONFIG		; Descriptor type
					; Total Length (LSB)
	db	(HighSpeedConfigDscrEnd-HighSpeedConfigDscr) mod 256
					; Total Length (MSB)
	db	(HighSpeedConfigDscrEnd-HighSpeedConfigDscr)  /  256
	db	1			; Number of interfaces
	db	1			; Configuration number
	db	0			; Configuration string
	db	01000000b		; Attributes (b7 - buspwr,
					;             b6 - selfpwr,
					;             b5 - rwu)
	db	50			; Power requirement (div 2 ma)

; Interface Descriptor
	db	DSCR_INTRFC_LEN		; Descriptor length
	db	DSCR_INTRFC		; Descriptor type
	db	0			; Zero-based index of this interface
	db	0			; Alternate setting
	db	0			; Number of end points 
	db	0ffH			; Interface class
	db	0ffH			; Interface sub class
	db	0ffH			; Interface sub sub class
	db	0			; Interface descriptor string index

; Interface Descriptor
	db	DSCR_INTRFC_LEN		; Descriptor length
	db	DSCR_INTRFC		; Descriptor type
	db	0			; Zero-based index of this interface
	db	1			; Alternate setting
	db	2			; Number of end points 
	db	0ffH			; Interface class
	db	0ffH			; Interface sub class
	db	0ffH			; Interface sub sub class
	db	0			; Interface descriptor string index

; Endpoint Descriptor (EP1OUT)
	db	DSCR_ENDPNT_LEN		; Descriptor length
	db	DSCR_ENDPNT		; Descriptor type
	db	01H			; Endpoint number and direction
	db	ET_BULK			; Endpoint type
	db	00H			; Maximum packet size (LSB)
	db	02H			; Maximum packet size (MSB)
	db	00H			; Polling interval (in ms)

; Endpoint Descriptor (EP1IN)
	db	DSCR_ENDPNT_LEN		; Descriptor length
	db	DSCR_ENDPNT		; Descriptor type
	db	81H			; Endpoint number and direction
	db	ET_BULK			; Endpoint type
	db	00H			; Maximum packet size (LSB)
	db	02H			; Maximum packet size (MSB)
	db	00H			; Polling interval (in ms)

; Interface Descriptor
	db	DSCR_INTRFC_LEN		; Descriptor length
	db	DSCR_INTRFC		; Descriptor type
	db	0			; Zero-based index of this interface
	db	2			; Alternate setting
	db	1			; Number of end points 
	db	0ffH			; Interface class
	db	0ffH			; Interface sub class
	db	0ffH			; Interface sub sub class
	db	0			; Interface descriptor string index

; Endpoint Descriptor (EP2IN)
	db	DSCR_ENDPNT_LEN		; Descriptor length
	db	DSCR_ENDPNT		; Descriptor type
	db	82H			; Endpoint number and direction
	db	ET_ISO			; Endpoint type
	db	00H			; Maximum packet size (LSB)
	db	14H			; Maximum packet size (MSB)
	db	01H			; Polling interval (1 for isochronous)
HighSpeedConfigDscrEnd:


FullSpeedConfigDscr:   
	db	DSCR_CONFIG_LEN		; Descriptor length
	db	DSCR_CONFIG		; Descriptor type
					; Total Length (LSB)
	db	(FullSpeedConfigDscrEnd-FullSpeedConfigDscr) mod 256
					; Total Length (MSB)
	db	(FullSpeedConfigDscrEnd-FullSpeedConfigDscr)  /  256
	db	1			; Number of interfaces
	db	1			; Configuration number
	db	0			; Configuration string
	db	01000000b		; Attributes (b7 - buspwr,
					;             b6 - selfpwr,
					;             b5 - rwu)
	db	50			; Power requirement (div 2 ma)

; Interface Descriptor
	db	DSCR_INTRFC_LEN		; Descriptor length
	db	DSCR_INTRFC		; Descriptor type
	db	0			; Zero-based index of this interface
	db	0			; Alternate setting
	db	0			; Number of end points 
	db	0ffH			; Interface class
	db	0ffH			; Interface sub class
	db	0ffH			; Interface sub sub class
	db	0			; Interface descriptor string index

; Interface Descriptor
	db	DSCR_INTRFC_LEN		; Descriptor length
	db	DSCR_INTRFC		; Descriptor type
	db	0			; Zero-based index of this interface
	db	1			; Alternate setting
	db	2			; Number of end points 
	db	0ffH			; Interface class
	db	0ffH			; Interface sub class
	db	0ffH			; Interface sub sub class
	db	0			; Interface descriptor string index
      
; Endpoint Descriptor (EP1OUT)
	db	DSCR_ENDPNT_LEN		; Descriptor length
	db	DSCR_ENDPNT		; Descriptor type
	db	01H			; Endpoint number, and direction
	db	ET_BULK			; Endpoint type
	db	40H			; Maximum packet size (LSB)
	db	00H			; Maximum packet size (MSB)
	db	00H			; Polling interval (in ms)

; Endpoint Descriptor (EP1IN)
	db	DSCR_ENDPNT_LEN		; Descriptor length
	db	DSCR_ENDPNT		; Descriptor type
	db	81H			; Endpoint number and direction
	db	ET_BULK			; Endpoint type
	db	40H			; Maximum packet size (LSB)
	db	00H			; Maximum packet size (MSB)
	db	00H			; Polling interval (in ms)

; Interface Descriptor
	db	DSCR_INTRFC_LEN		; Descriptor length
	db	DSCR_INTRFC		; Descriptor type
	db	0			; Zero-based index of this interface
	db	2			; Alternate setting
	db	1			; Number of end points 
	db	0ffH			; Interface class
	db	0ffH			; Interface sub class
	db	0ffH			; Interface sub sub class
	db	0			; Interface descriptor string index

; Endpoint Descriptor (EP2IN)
	db	DSCR_ENDPNT_LEN		; Descriptor length
	db	DSCR_ENDPNT		; Descriptor type
	db	82H			; Endpoint number and direction
	db	ET_ISO			; Endpoint type
	db	00H			; Maximum packet size (LSB)
	db	40H			; Maximum packet size (MSB)
	db	01H			; Polling interval (1 for isochronous)
FullSpeedConfigDscrEnd:   


StringDscr:

StringDscr0:   
	db	StringDscr0End-StringDscr0
	db	DSCR_STRING
	db	09H,04H
StringDscr0End:

StringDscr1:   
	db	StringDscr1End-StringDscr1
	db	DSCR_STRING
	db	'C',00
	db	'h',00
	db	'r',00
	db	'i',00
	db	's',00
	db	' ',00
	db	'H',00
	db	'i',00
	db	's',00
	db	'z',00
	db	'p',00
	db	'a',00
	db	'n',00
	db	's',00
	db	'k',00
	db	'i',00
StringDscr1End:

StringDscr2:   
	db	StringDscr2End-StringDscr2
	db	DSCR_STRING
	db	'S',00
	db	'o',00
	db	'r',00
	db	'a',00
	db	'd',00
StringDscr2End:

UserDscr:      
	dw	0000H
	end
      
