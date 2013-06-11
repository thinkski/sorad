////////////////////////////////////////////////////////////////////////////////
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
////////////////////////////////////////////////////////////////////////////////

#import "USBDriver.h"


///  DEFINITIONS  //////////////////////////////////////////////////////////////

// Index numbers of endpoints in interface
#define	kCtrlOutputPipeRef	1	// EP1OUT
#define	kCtrlInputPipeRef	2	// EP1IN
#define	kDataInputPipeRef	3	// EP2IN

// Size (in bytes) of EP1OUT and EP1IN
#define	kEndpoint1Size		64


// NOTE: Since operating system context switches can last as long as 100
//       milliseconds and the maximum capacity of a USB bulk endpoint is
//       480 Mbps (60 megabytes per second), allocate at least 6 megabytes of
//       buffer space.

// Number of rotating asynchronous reads to use
#define	kNumberInternalBuffers	8

// Number of buffers use for read data before passing it off to client
#define	kNumberExternalBuffers	8

// Number of bytes per each asynchronous read buffer
#define	kBytesPerInternalBuffer	(1<<17)	// 128K



#define kMCUVendorRequest	0xA0
#define	kMCU_CPUCS		0xE600


///  INTERNAL C CALLBACK FUNCTION PROTOTYPES  //////////////////////////////////

static void bufferReceived(void *refCon, IOReturn result, void *arg0);

static void configuredDeviceAdded(void *refCon, io_iterator_t iter);
static void configuredDeviceRemoved(void *refCon, io_iterator_t iter);

static void unconfiguredDeviceAdded(void *refCon, io_iterator_t iter);
static void unconfiguredDeviceRemoved(void *refCon, io_iterator_t iter);


///  INTERNAL METHODS  /////////////////////////////////////////////////////////

@interface USBDriver(Private)
- (void)reader:(id)anObject;
@end

@implementation USBDriver(Private)
- (void)reader:(id)anObject
{
	NSInteger		i;
	kern_return_t		kr;
	CFRunLoopSourceRef	runLoopSource;

	
	// Create an autorelease pool for the thread
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	// Create an event source for asynchronous read events
	kr = (*usbInterfaceInterface)->CreateInterfaceAsyncEventSource(usbInterfaceInterface, &runLoopSource);

	// Add the source to the thread's run loop
	CFRunLoopAddSource([[NSRunLoop currentRunLoop] getCFRunLoop], runLoopSource, kCFRunLoopDefaultMode);
	
	// Schedule asynchronous read requests for the buffer pool
	for (i = 0; i < kNumberInternalBuffers; i++) {
		// Write driver instance pointer to head of buffer
		[self refCons][i].driver = self;
		[self refCons][i].buffer = [self bufferPool]+(kBytesPerInternalBuffer*i);
		
		// Asynchronous bulk read request
		kr = (*usbInterfaceInterface)->ReadPipeAsync(usbInterfaceInterface,
							     kDataInputPipeRef,
							     [self refCons][i].buffer,
							     kBytesPerInternalBuffer,
							     bufferReceived,
							     &[self refCons][i]);
		if (kr != kIOReturnSuccess) {
			statusMessage = @"Error";
			NSLog(@"Error scheduling asynchronous pipe read number %ld. (Code 0x%08d)", i, kr);
			break;
		}
	}
	
	// Process this thread's run loop... forever
	[[NSRunLoop currentRunLoop] run];
	
	// Release the thread's autorelease pool (should never get here)
	[pool release];
}
@end


///  EXTERNAL METHODS  /////////////////////////////////////////////////////////

@implementation USBDriver

// Method reminds developer that USB vendor and product IDs must be specified.
- (id) init {
	NSLog(@"Method not supported. Use initWithVendorID:productID:");
	return nil;
}

// Method registers four callback handlers: two for when an unconfigured device
// is added or removed and two for when a configured device is added or removed.
- (id) initWithConfiguredVendorID:(SInt32)configuredUsbVendor
	      configuredProductID:(SInt32)configuredUsbProduct
	     unconfiguredVendorID:(SInt32)unconfiguredUsbVendor
	    unconfiguredProductID:(SInt32)unconfiguredUsbProduct
{
	CFMutableDictionaryRef   configuredMatchingDict;
	CFMutableDictionaryRef unconfiguredMatchingDict;
	
	IONotificationPortRef notifyPort;
	CFRunLoopSourceRef runLoopSource;
	kern_return_t kr;
	io_service_t usbDevice;
	
	io_iterator_t   configuredDeviceAddedIterator;
	io_iterator_t   configuredDeviceRemovedIterator;
	io_iterator_t unconfiguredDeviceAddedIterator;
	io_iterator_t unconfiguredDeviceRemovedIterator;
	
	
	self = [super init];
	
	if (self) {
		// Create array for filled buffers
		filledBuffers = [[NSMutableArray alloc] init];
		
		// Create two dictionaries, one for matching unconfigured
		// devices and one for matching configured ones
		  configuredMatchingDict = IOServiceMatching(kIOUSBDeviceClassName);
		unconfiguredMatchingDict = IOServiceMatching(kIOUSBDeviceClassName);
		
		// Set the vendor and product IDs of the configured device for
		// which to listen.
		CFDictionarySetValue(configuredMatchingDict,
				     CFSTR(kUSBVendorID),
				     CFNumberCreate(kCFAllocatorDefault,
						    kCFNumberSInt32Type,
						    &configuredUsbVendor));
		
		CFDictionarySetValue(configuredMatchingDict,
				     CFSTR(kUSBProductID),
				     CFNumberCreate(kCFAllocatorDefault,
						    kCFNumberSInt32Type,
						    &configuredUsbProduct));
		
		// Set the vendor and product IDs of the unconfigured device for
		// which to listen.
		CFDictionarySetValue(unconfiguredMatchingDict,
				     CFSTR(kUSBVendorID),
				     CFNumberCreate(kCFAllocatorDefault,
						    kCFNumberSInt32Type,
						    &unconfiguredUsbVendor));
		
		CFDictionarySetValue(unconfiguredMatchingDict,
				     CFSTR(kUSBProductID),
				     CFNumberCreate(kCFAllocatorDefault,
						    kCFNumberSInt32Type,
						    &unconfiguredUsbProduct));
		
		// Create port for receiving I/O Kit notifications
		notifyPort = IONotificationPortCreate(kIOMasterPortDefault);
		
		if (notifyPort) {
			
			// Get runloop source for port
			runLoopSource =
				IONotificationPortGetRunLoopSource(notifyPort);

			// Add source to current runloop
			CFRunLoopAddSource([[NSRunLoop currentRunLoop] getCFRunLoop],
					   runLoopSource,
					   kCFRunLoopDefaultMode);
			
			// Matching dictionaries will be used twice each, so add
			// one to the retain counts
			  configuredMatchingDict = (CFMutableDictionaryRef)CFRetain(configuredMatchingDict);
			unconfiguredMatchingDict = (CFMutableDictionaryRef)CFRetain(unconfiguredMatchingDict);
			
			// Add notification for when a matching configured device is added.
			kr = IOServiceAddMatchingNotification(notifyPort,
							      kIOFirstMatchNotification,
							      configuredMatchingDict,
							      configuredDeviceAdded,
							      (void *)self,
							      &configuredDeviceAddedIterator);
			
			if (kr != kIOReturnSuccess) {
				NSLog(@"Error occurred while attempting to add notification for when a configured device is added.");
			}
				
			// Add notification for when a matching configured device is removed.
			kr = IOServiceAddMatchingNotification(notifyPort,
							      kIOTerminatedNotification,
							      configuredMatchingDict,
							      configuredDeviceRemoved,
							      (void *)self,
							      &configuredDeviceRemovedIterator);
			
			if (kr != kIOReturnSuccess) {
				NSLog(@"Error occurred while attempting to add notification for when a configured device is removed.");
			}
			
			// Add notification for when a matching unconfigured device is added.
			kr = IOServiceAddMatchingNotification(notifyPort,
							      kIOFirstMatchNotification,
							      unconfiguredMatchingDict,
							      unconfiguredDeviceAdded,
							      (void *)self,
							      &unconfiguredDeviceAddedIterator);
			
			if (kr != kIOReturnSuccess) {
				NSLog(@"Error occurred while attempting to add notification for when an unconfigured device is added.");
			}
			
			// Add notification for when a matching unconfigured device is removed.
			kr = IOServiceAddMatchingNotification(notifyPort,
							      kIOTerminatedNotification,
							      unconfiguredMatchingDict,
							      unconfiguredDeviceRemoved,
							      (void *)self,
							      &unconfiguredDeviceRemovedIterator);
			
			if (kr != kIOReturnSuccess) {
				NSLog(@"Error occurred while attempting to add notification for when an unconfigured device is removed.");
			}
				
			// Arm notifications and handle existing devices
			do {
				configuredDeviceAdded((void *)self,
						      configuredDeviceAddedIterator);
			} while ((usbDevice = IOIteratorNext(configuredDeviceAddedIterator)));
			
			do {
				configuredDeviceRemoved((void *)self,
							configuredDeviceRemovedIterator);
			} while ((usbDevice = IOIteratorNext(configuredDeviceRemovedIterator)));
			
			do {
				unconfiguredDeviceAdded((void *)self,
							unconfiguredDeviceAddedIterator);
			} while ((usbDevice = IOIteratorNext(unconfiguredDeviceAddedIterator)));
			
			do {
				unconfiguredDeviceRemoved((void *)self,
							  unconfiguredDeviceRemovedIterator);
			} while ((usbDevice = IOIteratorNext(unconfiguredDeviceRemovedIterator)));
			
			// Set default status message
			statusMessage = @"Not connected";

		} else {
			statusMessage = @"Error";
		}
	}
	
	return self;
}


// Clients should use this method to request a buffer of data from the device
- (NSData *)buffer
{
	NSData *buffer = nil;
	
	// Verify that at least one buffer object exists in the queue.
	if ([[self filledBuffers] count] > 0) {
		// Get pointer to buffer object at the head of the queue.
		buffer = [[self filledBuffers] objectAtIndex:0];
		
		// Retain so won't autorelease when removed from queue.
		[buffer retain];
		
		// Remove the buffer object from the queue.
		[[self filledBuffers] removeObjectAtIndex:0];
	}
	
	// Return to the client a pointer to the dequeued buffer object
	return buffer;
}

- (void)dealloc
{
	[filledBuffers dealloc];
	free(bufferPool);
	
	[super dealloc];
}

- (void)setUsbInterfaceInterface:(IOUSBInterfaceInterface **)newUsbInterfaceInterface
{
	usbInterfaceInterface = newUsbInterfaceInterface;
}
- (IOUSBInterfaceInterface **)usbInterfaceInterface
{
	return usbInterfaceInterface;
}
- (void)setBufferPool:(void *)newBufferPool
{
	bufferPool = newBufferPool;
}
- (void *)bufferPool
{
	return bufferPool;
}
- (void)setRefCons:(referenceContext *)newRefCons
{
	refCons = newRefCons;
}
- (referenceContext *)refCons {
	return refCons;
}
@synthesize filledBuffers;
@synthesize statusMessage;
@end


///  PRIVATE C FUNCTIONS  //////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// FUNCTION
//	myAtoi
//
// DESCRIPTION
//	Like atoi(), but only converts first 'len' characters. Additionally
//	recognized any base up to base 16. Digits beyond '9' are represented
//	with upper or lower case, starting with 'A' being 10, 'B' being 11,
//	and so on.
//
// ARGUMENTS
//	s	- pointer to source string
//	base	- number base
//	len	- number of characters to convert
//
// RETURN
//	Corresponding integer, or negative integer on conversion error.
//
////////////////////////////////////////////////////////////////////////////////

static int myAtoi (char *s, int base, int len)
{
	int	i;
	int	val;
	
	val = 0;
	
	for (i = 0; i < len; i++) {
		
		val *= base;
		
		if ('0' <= s[i] && s[i] <= '9') {
			val += s[i] - '0';
		} else if ('A' <= s[i] && s[i] <= 'F') {
			val += 10 + s[i] - 'A';
		} else if ('a' <= s[i] && s[i] <= 'f') {
			val += 10 + s[i] - 'a';
		} else {
			return -1;
		}
	}
	
	return val;
}


////////////////////////////////////////////////////////////////////////////////
//
// FUNCTION
//	mcuWrite
//
// DESCRIPTION
//	Writes a buffer of data to microcontroller's on-chip memory space.
//	Maximum of 40 bytes per buffer.
//
// ARGUMENTS
//	usbDeviceInterface	Pointer to device specific interface
//	src			Source memory pointer
//	address			MCU address to write to
//	size			Number of bytes to write
//
// RETURN
//	Kernel I/O Kit return code
//
////////////////////////////////////////////////////////////////////////////////

static IOReturn mcuWrite (IOUSBDeviceInterface	**usbDeviceInterface,
			  UInt8			 *src,
			  UInt16		  address,
			  UInt16		  size
) {
	kern_return_t		kr;
	IOUSBDevRequest		request;

	
	// Initialize request
	request.bmRequestType = USBmakebmRequestType(kUSBOut,
						     kUSBVendor,
						     kUSBDevice);
	request.bRequest      = kMCUVendorRequest;
	request.wValue        = address;
	request.wIndex        = 0;
	request.wLength       = size;
	request.pData         = src;
	
	// Issue the request
	kr = (*usbDeviceInterface)->DeviceRequest(usbDeviceInterface,
						  &request);

	return kr;
}


////////////////////////////////////////////////////////////////////////////////
//
// FUNCTION
//	configureFPGA
//
// DESCRIPTION
//      Opens file with specified 'filename', reads bitstream from file one
//      block at a time, and writes the data to the on-board FPGA.
//
//      User message 'fpga configuration in progress...' is printed, followed
//      by either a 'success' or 'failed', depending on whether the fpga
//      has been successfully configured, or an error occured. Configuration
//      typically takes several seconds to complete.
//
// ARGUMENTS
//      iref            - USB device interface reference pointer
//      filename        - pointer to filename of bitstream file
//
// RETURN
//      Zero on success, negative integer on error.
//
////////////////////////////////////////////////////////////////////////////////

static int configureFPGA (IOUSBInterfaceInterface **iref)
{
	UInt8		 buf[kEndpoint1Size];	// buffer pointer
	FILE		*fp;			// file reference
	IOReturn	 kr;			// return value container
	UInt32		 n;			// number of bytes
	NSString	*filename;


	// Locate resource file containing firmware
	filename = [[NSBundle mainBundle] pathForResource:@"bitstream" ofType:@"bit"];
	
	// Open resource file
	if (!(fp = fopen([filename cStringUsingEncoding:NSASCIIStringEncoding], "rb"))) {
		NSLog(@"configureFPGA(): fopen() failed");
		return -1;
	}
				
	// Write configuration bit stream one buffer at a time
	while (!feof (fp)) {

		// Read buffer from file
		n = fread (buf, sizeof(UInt8), kEndpoint1Size, fp);
			
		// Write buffer to device
		kr = (*iref)->WritePipe (iref,
					 kCtrlOutputPipeRef,
					 buf,
					 n);
			
		// Verify that write was successful
		if (kr != kIOReturnSuccess) {
			NSLog (@"configureFPGA(): WritePipeTO(): failed\n");
			return -1;
		}
			
		// Read feedback signal
		n = kEndpoint1Size;
		kr = (*iref)->ReadPipe (iref,
					kCtrlInputPipeRef,
					buf,
					&n);
			
		// Verify that read was successful
		if (kr != kIOReturnSuccess) {
			NSLog (@"configureFPGA(): ReadPipeTO(): failed\n");
			return -1;
		}

		// Is DONE high?
		if (buf[0] == 0) {
			return 0;
		}
					
		// Is INIT_B low?
		if (buf[1] == 0) {
			NSLog (@"configureFPGA(): Error\n");
			return -1;
		}
	}
	
	fclose (fp);

        return -1;
}


////////////////////////////////////////////////////////////////////////////////
//
// FUNCTION
//	bufferReceived
//
// DESCRIPTION
//	This function is a callback handler, called automatically when an
//	asychronous read request is filled. The read requests, initially
//	scheduled when the device was added, are resumbitted by the callback
//	once the callback has copied the data into a data object, ready to be
//	handed-off to the driver client.
//
// ARGUMENTS
//
//
// RETURN
//	None.
//
////////////////////////////////////////////////////////////////////////////////

static void bufferReceived(void *refCon, IOReturn result, void *arg0)
{
	void			 *bytes			= ((referenceContext *)refCon)->buffer;
	USBDriver		 *usbDriverInstance	= ((referenceContext *)refCon)->driver;
	IOUSBInterfaceInterface	**usbInterfaceInterface	= [usbDriverInstance usbInterfaceInterface];

	
	// Check number of queued object as a check against otherwise unchecked
	// growth should client dequeue objects too slowly
	if ([[usbDriverInstance filledBuffers] count] < kNumberExternalBuffers) {

		// Add data object to "ready for client" queue
		[[usbDriverInstance filledBuffers] addObject:[NSData dataWithBytes:bytes
									    length:(NSInteger)arg0]];
	}
	
	// Recycle buffer in new asynchronous read request
	(*usbInterfaceInterface)->ReadPipeAsync(usbInterfaceInterface,
						kDataInputPipeRef,
						bytes,
						kBytesPerInternalBuffer,
						bufferReceived,
						refCon);
}


////////////////////////////////////////////////////////////////////////////////
//
// FUNCTION
//	unconfiguredDeviceAdded
//
// DESCRIPTION
//	Uploads firmware to the Cypress EZ-USB FX2LP microcontroller. After
//	the upload, the device renumerates as a configured device. The
//	microcontroller is held in reset during the upload process.
//
//	Note that after renumerating, the configuredDeviceAdded function will
//	be called, in theory.
//
// ARGUMENTS
//	refCon	- Pointer to the user-specified reference context. In this case
//		  should be a pointer to the class instance.
//	iter	- Core Foundation iterator object describing matching devices.
//
// RETURN
//	None.
//
////////////////////////////////////////////////////////////////////////////////

static void unconfiguredDeviceAdded(void *refCon, io_iterator_t iter)
{
	int			  addr;
	IOCFPlugInInterface	**cfPlugInInterface	= NULL;
	int			  checksum;
	UInt8			  data[80];
	NSString		 *filename;
	FILE			 *fp;
	int			  i;
	kern_return_t		  kr;
	int			  len;
	char			  s[80];
	HRESULT			  status;
	SInt32			  theScore;
	int			  type;
	io_service_t		  usbDevice;
	IOUSBDeviceInterface	**usbDeviceInterface	= NULL;
	UInt8			  value;
	USBDriver		 *usbDriverInstance;

	// Set status message
	usbDriverInstance = (USBDriver *)refCon;
	[usbDriverInstance setStatusMessage:@"Configuring..."];
	
	while ((usbDevice = IOIteratorNext(iter))) {
		
		// Create an intermediate "plug-in" interface
		kr = IOCreatePlugInInterfaceForService(usbDevice,
						       kIOUSBDeviceUserClientTypeID, 
						       kIOCFPlugInInterfaceID, 
						       &cfPlugInInterface, 
						       &theScore);
		if (kr != kIOReturnSuccess) {
			NSLog(@"unconfiguredDeviceAdded(): IOCreatePlugInInterfaceForService() failed: Code 0x%08x", kr);
			break;
		}
		
		// Get a device specific interface via "plug-in"
		status = (*cfPlugInInterface)->QueryInterface(cfPlugInInterface,
							      CFUUIDGetUUIDBytes(kIOUSBDeviceInterfaceID),
							      (LPVOID *)&usbDeviceInterface);
		if (FAILED(status)) {
			NSLog(@"unconfiguredDeviceAdded(): QueryInterface() failed: Code 0x%08d", status);
			break;
		}
		
		// Release intermediate "plug-in" interface
		kr = IODestroyPlugInInterface(cfPlugInInterface);
		if (kr != kIOReturnSuccess) {
			NSLog(@"unconfiguredDeviceAdded(): IODestroyPlugInInterface() failed: Code 0x%08x", kr);
			break;
		}
		
		// Open the USB device via its device specific interface
		kr = (*usbDeviceInterface)->USBDeviceOpen(usbDeviceInterface);
		if (kr != kIOReturnSuccess) {
			NSLog(@"unconfiguredDeviceAdded(): USBDeviceOpen() failed: Code 0x%08x", kr);
			break;
		}
		
		// Assert MCU reset
		value = 0x01;
		kr = mcuWrite(usbDeviceInterface, &value, kMCU_CPUCS, sizeof(value));
		if (kr != kIOReturnSuccess) {
			NSLog(@"unconfiguredDeviceAdded(): mcuWrite() failed: Code 0x%08x", kr);
			break;
		}
		
		// Locate resource file containing firmware
		filename = [[NSBundle mainBundle] pathForResource:@"firmware" ofType:@"ihx"];
		
		// Open resource file
		fp = fopen([filename cStringUsingEncoding:NSASCIIStringEncoding], "r");
		if (fp == NULL) {
			NSLog(@"unconfiguredDeviceAdded(): fopen() failed");
			break;
		}
		
		// Upload firmware from resource file to microcontroller
		while (fgets(s, sizeof(s), fp)) {
			if (s[0] != ':') {
				NSLog (@"Resource file containing MCU firmware is corrupt");
				break;
			}
			
			// Read record length, destination address, and type
			len = myAtoi(s+1, 16, 2);
			addr = myAtoi(s+3, 16, 4);
			type = myAtoi(s+7, 16, 2);
			
			// Validate record checksum
			for (i = 0, checksum = 0; i < len + 4; i++) {
				checksum += myAtoi (s + 1 + 2*i, 16, 2);
			}
			if ((checksum & 0xff) !=
			    ((~(myAtoi(s + 9 + 2*len, 16, 2)) + 1) & 0xff)) {
				NSLog(@"Resource file containing MCU firmware failed checksum");
				break;
			}
			
			// Read record data
			for (i = 0; i < len; i++) {
				data[i] = myAtoi(s + 9 + 2*i, 16, 2);
			}
			
			// Write record data to MCU memory
			if (type == 0) {
				kr = mcuWrite(usbDeviceInterface, data, addr, len);
				if (kr != kIOReturnSuccess) {
					NSLog(@"mcuWrite() failed (code 0x%08x)", kr);
				}
			}
		}
		
		// Close resource file
		fclose(fp);
		
		// De-assert MCU reset
		value = 0x00;
		kr = mcuWrite(usbDeviceInterface, &value, kMCU_CPUCS, sizeof(value));
		if (kr != kIOReturnSuccess) {
			NSLog(@"MCUWrite() failed (code 0x%08x)", kr);
		}
		
		// Close the detected USB device via its device specific interface
		kr = (*usbDeviceInterface)->USBDeviceClose(usbDeviceInterface);
		if (kr != kIOReturnSuccess) {
			NSLog(@"USBDeviceClose() failed (code 0x%08x)", kr);
		}
		
		// Release device specific interface
		(*usbDeviceInterface)->Release(usbDeviceInterface);
	}
}


////////////////////////////////////////////////////////////////////////////////
//
// FUNCTION
//	unconfiguredDeviceRemoved
//
// DESCRIPTION
//	Does nothing at the moment.
//
// ARGUMENTS
//	refCon	- Pointer to the user-specified reference context. In this case
//		  should be a pointer to the class instance.
//	iter	- Core Foundation iterator object describing matching devices.
//
// RETURN
//	None.
//
////////////////////////////////////////////////////////////////////////////////

static void unconfiguredDeviceRemoved(void *refCon, io_iterator_t iter)
{
	return;
}


////////////////////////////////////////////////////////////////////////////////
//
// FUNCTION
//	configuredDeviceAdded
//
// DESCRIPTION
//	A callback handler. Called when one or more "matching devices" are
//	added -- a matching device is one that has had firmware uploaded and has
//	renumerated.
//
//	This handler iterates through the matching device, checking if each is
//	already claimed by another process. If not, the device is opened, and
//	the current alternate interface setting is read to determine if the
//	FPGA has been configured. The FPGA is then configured if necessary, and
//	a series of asynchronous bulk reads are scheduled.
//
//	The results of the reads are processed by a different callback handler.
//
// ARGUMENTS
//	refCon	- Pointer to the user-specified reference context. In this case
//		  should be a pointer to the class instance.
//	iter	- Core Foundation iterator object describing matching devices.
//
// RETURN
//	None.
//
////////////////////////////////////////////////////////////////////////////////

static void configuredDeviceAdded(void *refCon, io_iterator_t iter)
{
	USBDriver				 *usbDriverInstance;
	kern_return_t				  kr;
	io_service_t				  usbDevice;
	io_service_t				  usbInterface;
	SInt32					  theScore;
	IOCFPlugInInterface			**cfPlugInInterface;
	HRESULT					   herr;
	IOUSBDeviceInterface			**usbDeviceInterface;
	IOUSBInterfaceInterface			**usbInterfaceInterface;
	io_iterator_t				  interfaceIterator;
	IOUSBFindInterfaceRequest		  interfaceRequest;
	IOUSBConfigurationDescriptorPtr		  configDescriptor;
	UInt8					  altSetting;

	
	usbDriverInstance = (USBDriver *)refCon;
	
	// Set status message
	[usbDriverInstance setStatusMessage:@"Configuring..."];
	
	while ((usbDevice = IOIteratorNext(iter))) {
		
		// Process a device. Loop runs only once. Exists to enable
		// use of 'break' statements to abort remaining operations and
		// move on to next device.
		do {
			
			// Create intermediate plug-in interface
			if (// Assignments
			    kr = IOCreatePlugInInterfaceForService (
				usbDevice,
				kIOUSBDeviceUserClientTypeID,
				kIOCFPlugInInterfaceID,
				&cfPlugInInterface,
				&theScore),
			    
			    // Test condition
			    kr != kIOReturnSuccess)
			{
				[usbDriverInstance setStatusMessage:@"Cannot connect. See console for error."];
				NSLog (@"Error creating plug-in for service. (Code 0x%08x)", kr);
				break;
			}
			
			
			// Get device specific interface via intermediate plug-in
			if (// Assignments
			    herr = (*cfPlugInInterface)->QueryInterface (
				cfPlugInInterface,
				CFUUIDGetUUIDBytes (kIOUSBDeviceInterfaceID),
				(LPVOID *)&usbDeviceInterface),
			    
			    // Test condition
			    FAILED (herr))
			{
				[usbDriverInstance setStatusMessage:@"Cannot connect. See console for error."];
				NSLog (@"Error querying interface via plug-in. (Code 0x%08d)", herr);
				break;
			}
			
			
			// Release intermediate plug-in
			if (// Assignments
			    kr = IODestroyPlugInInterface (cfPlugInInterface),
			    
			    // Test condition
			    kr != kIOReturnSuccess)
			{
				[usbDriverInstance setStatusMessage:@"Cannot connect. See console for error."];
				NSLog (@"Error releasing intermediate plug-in. (Code 0x%08x)", kr);
				break;
			}
			
			
			// Open USB device
			if (// Assignments
			    kr = (*usbDeviceInterface)->USBDeviceOpen(usbDeviceInterface),
			    
			    // Test condition 1
			    kr == kIOReturnExclusiveAccess)
			{
				[usbDriverInstance setStatusMessage:@"Cannot connect. Device is in use."];
				break;
			} else
			if (// Test condition 2
			    kr != kIOReturnSuccess) {
				[usbDriverInstance setStatusMessage:@"Cannot connect. See console for error."];
				NSLog (@"Error opening USB device. (Code 0x%08x)", kr);
				break;
			}
			
			
			// Have exclusive device access. Get configuration.
			if (// Assignments
			    kr = (*usbDeviceInterface)->GetConfigurationDescriptorPtr (
				usbDeviceInterface,
				0,
				&configDescriptor),
			    
			    // Test condition
			    kr != kIOReturnSuccess)
			{
				[usbDriverInstance setStatusMessage:@"Cannot connect. See console for error."];
				NSLog (@"Error getting configuration. (Code 0x%08x)", kr);
				break;
			}
			
			
			// Set configuration
			if (// Assignments
			    kr = (*usbDeviceInterface)->SetConfiguration (
				usbDeviceInterface,
				configDescriptor->bConfigurationValue),
			    
			    // Test condition
			    kr != kIOReturnSuccess)
			{
				[usbDriverInstance setStatusMessage:@"Cannot connect. See console for error."];
				NSLog (@"Error setting configuration. (Code 0x%08x)", kr);
				break;
			}
			
			
			// Create interface iterator for USB device
			if (// Assignments
			    interfaceRequest.bInterfaceClass    = kIOUSBFindInterfaceDontCare,
			    interfaceRequest.bInterfaceSubClass = kIOUSBFindInterfaceDontCare,
			    interfaceRequest.bInterfaceProtocol = kIOUSBFindInterfaceDontCare,
			    interfaceRequest.bAlternateSetting  = kIOUSBFindInterfaceDontCare,
			
			    kr = (*usbDeviceInterface)->CreateInterfaceIterator (
				usbDeviceInterface,
				&interfaceRequest,
				&interfaceIterator),
			    
			    // Test condition
			    kr != kIOReturnSuccess)
			{
				[usbDriverInstance setStatusMessage:@"Cannot connect. See console for error."];
				NSLog (@"Error creating interface iterator. (Code 0x%08x)", kr);
				break;
			}
			
			
			// Iterate across matching interfaces
			while ((usbInterface = IOIteratorNext(interfaceIterator))) {
				
				// Loop runs only once. Exists for breaks.
				do {
			
					// Create intermediate plug-in interface
					if (// Assignments
					    kr = IOCreatePlugInInterfaceForService (
						usbInterface,
						kIOUSBInterfaceUserClientTypeID,
						kIOCFPlugInInterfaceID, 
						&cfPlugInInterface,
						&theScore),
					    
					    // Test condition
					    kr != kIOReturnSuccess)
					{
						[usbDriverInstance setStatusMessage:@"Cannot connect. See console for error."];
						NSLog (@"Error creating intermediate interface plug-in. (Code 0x%08x)", kr);
						break;
					}
					
					
					// Get a USB interface specific interface via intermediate plug-in
					if (// Assignments
					    herr = (*cfPlugInInterface)->QueryInterface (
						cfPlugInInterface,
						CFUUIDGetUUIDBytes (kIOUSBInterfaceInterfaceID),
						(LPVOID *)&usbInterfaceInterface),
					    
					    // Test condition
					    FAILED (herr))
					{
						[usbDriverInstance setStatusMessage:@"Cannot connect. See console for error."];
						NSLog(@"Error querying interface via plug-in. (Code 0x%08d)", herr);
						break;
					}
					
					
					// Release intermediate plug-in
					if (// Assignments
					    kr = IODestroyPlugInInterface(cfPlugInInterface),
					    
					    // Test condition
					    kr != kIOReturnSuccess)
					{
						[usbDriverInstance setStatusMessage:@"Cannot connect. See console for error."];
						NSLog(@"Error releasing intermediate plug-in. (Code 0x%08x)", kr);
						break;
					}
					
					
					// Open USB device's interface interface via USB interface specific interface
					if (// Assignments
					    kr = (*usbInterfaceInterface)->USBInterfaceOpen (usbInterfaceInterface),
					    
					    // Test condition
					    kr != kIOReturnSuccess)
					{
						[usbDriverInstance setStatusMessage:@"Cannot connect. See console for error."];
						NSLog(@"Error opening USB device's interface. (Code 0x%08x)", kr);
						break;
					}
					
					// Check current alternate interface setting. Since default setting is zero, a
					// non-zero setting implies the FPGA has already been configured.
					kr = (*usbInterfaceInterface)->GetAlternateSetting (usbInterfaceInterface,
											    &altSetting);
					
					NSLog(@"Alternate setting: %i\n", altSetting);
					
					if (!altSetting) {
					
						// Save off interface interface to class instance for use outside this function
						// by class instance. Then change to alternate setting 0.
						if (// Assignments
						    [usbDriverInstance setUsbInterfaceInterface:usbInterfaceInterface],
						    kr = (*usbInterfaceInterface)->SetAlternateInterface (
							usbInterfaceInterface,
							0),
						    
						    // Test condition
						    kr != kIOReturnSuccess)
						{
							[usbDriverInstance setStatusMessage:@"Cannot connect. See console for error."];
							NSLog (@"Error setting alternate interface to 0. (Code 0x%08x)", kr);
							break;
						}
						
						
						// Configure FPGA
						configureFPGA (usbInterfaceInterface);
						
						// Change to alt. interface 1
						if (// Assignments
						    kr = (*usbInterfaceInterface)->SetAlternateInterface (
							usbInterfaceInterface,
							1),
						    
						    // Test condition
						    kr != kIOReturnSuccess)
						{
							[usbDriverInstance setStatusMessage:@"Cannot connect. See console for error."];
							NSLog (@"Error setting alternate interface to 1. (Code 0x%08x)", kr);
							break;
						}
					}

					// Check current alternate interface setting. Since default setting is zero, a
					// non-zero setting implies the FPGA has already been configured.
					kr = (*usbInterfaceInterface)->GetAlternateSetting (usbInterfaceInterface,
											    &altSetting);
					NSLog(@"Alternate setting 2: %i\n", altSetting);

					
					// Allocate memory for buffer and context pools
					if (// Assignments
					    [usbDriverInstance setBufferPool:malloc(kBytesPerInternalBuffer *kNumberInternalBuffers)],
					    [usbDriverInstance    setRefCons:malloc(sizeof(referenceContext)*kNumberInternalBuffers)],
					
					    // Test condition
					    ![usbDriverInstance bufferPool] || ![usbDriverInstance refCons])
					{
						[usbDriverInstance setStatusMessage:@"Cannot connect. See console for error."];
						NSLog(@"Error allocating memory for internal buffer pool.");
						break;
					}
					
					// Start separate thread for asynchronous reads. Allows reads to
					// continue while primary GUI thread is blocking on a user event,
					// such as mouse down on a menu.
					[NSThread detachNewThreadSelector:@selector(reader:)
								 toTarget:usbDriverInstance
							       withObject:nil];
					
					// Success! Data is now flowing! In theory :)
					[usbDriverInstance setStatusMessage:@"Connected"];
					
				} while (0);
					
			} // while for interfaces
			
		} while (0); // do

		
		// Release current device object from iterator
		kr = IOObjectRelease (usbDevice);
		if (kr != kIOReturnSuccess) {
			NSLog(@"Error releasing usbDevice object. (Code 0x%08x)", kr);
		}
	}
}


////////////////////////////////////////////////////////////////////////////////
//
// FUNCTION
//	configuredDeviceRemoved
//
// DESCRIPTION
//	Does nothing at the moment.
//
// ARGUMENTS
//	refCon	- Pointer to the user-specified reference context. In this case
//		  should be a pointer to the class instance.
//	iter	- Core Foundation iterator object describing matching devices.
//
// RETURN
//	None.
//
////////////////////////////////////////////////////////////////////////////////

static void configuredDeviceRemoved(void *refCon, io_iterator_t iter)
{
	kern_return_t kr;
	io_service_t usbDevice;
	
	while ((usbDevice = IOIteratorNext(iter))) {
		
		kr = IOObjectRelease(usbDevice);
		
		if (kr != kIOReturnSuccess) {
			NSLog(@"Error releasing usbDevice object. (Code 0x%08x)", kr);
		}
	}
}
