//////////////////////////////////////////////////////////////////////////////
//
//  USBDriver.h
//
//
//  User-space driver class that abstracts communication with the USB
//  peripheral.
//
//
//  Copyright (C) 2009 Alpha Devices LLC. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////

#import <Cocoa/Cocoa.h>

#import <CoreFoundation/CoreFoundation.h>
#import <IOKit/usb/IOUSBLib.h>
#import <IOKit/IOCFPlugIn.h>


typedef struct {
	void *buffer;
	void *driver;
} referenceContext;

@interface USBDriver : NSObject {
	IOUSBInterfaceInterface	**usbInterfaceInterface;
	void			 *bufferPool;
	referenceContext	 *refCons;
	NSMutableArray		 *filledBuffers;
	
	// Message to communicate to user via the status bar
	NSString		*statusMessage;
}
- (id)initWithConfiguredVendorID:(SInt32)configuredUsbVendor
	     configuredProductID:(SInt32)configuredUsbProduct
	    unconfiguredVendorID:(SInt32)unconfiguredUsbVendor
	   unconfiguredProductID:(SInt32)unconfiguredUsbProduct;
- (id)buffer;
- (void)setUsbInterfaceInterface:(IOUSBInterfaceInterface **)newUsbInterfaceInterface;
- (IOUSBInterfaceInterface **)usbInterfaceInterface;
- (void)setBufferPool:(void *)newBufferPool;
- (void *)bufferPool;
- (void)setRefCons:(referenceContext *)newRefCons;
- (referenceContext *)refCons;

@property (retain, readwrite) NSMutableArray *filledBuffers;
@property (retain, readwrite) NSString       *statusMessage;

@end
