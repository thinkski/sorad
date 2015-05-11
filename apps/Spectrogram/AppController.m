//////////////////////////////////////////////////////////////////////////////
//
//  AppController.h
//
//
//  Application controller for Spectrum Analyzer. The controller reads input
//  data from the USB driver (the model) and writes output to the scope view,
//  transforming it as mandated by user-selected parameters.
//
//  Mac OS X v10.4 or later required due to vDSP code.
//
//
//  Copyright (C) 2009 Alpha Devices LLC. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////

#import "AppController.h"

// Logarithm (base-2) of the maximum number of FFT points
#define	MAX_LOG2_NUM_POINTS	16


@implementation AppController

//  OVERRIDDEN METHODS  //////////////////////////////////////////////////////

- (id)init
{
	self = [super init];
	
	if (self) {
		// Initialize the USB driver
		usbDriver = [[USBDriver alloc] initWithConfiguredVendorID:0x6666
						      configuredProductID:0x0001
						     unconfiguredVendorID:0x04b4
						    unconfiguredProductID:0x8613];
		if (!usbDriver) {
			NSLog(@"Error initializing USB driver");
		}

		// Prepare to compute FFTs with 2^16 points and radix-2
		fftSetupD = vDSP_create_fftsetupD(MAX_LOG2_NUM_POINTS, FFT_RADIX2);
		if (!fftSetupD) {
			NSLog(@"Error creating FFT setup");
		}
		
		// Allocate memory for split FFT buffer
		splitVector.realp = (double *)malloc(sizeof(double)*(1<<MAX_LOG2_NUM_POINTS));
		splitVector.imagp = (double *)malloc(sizeof(double)*(1<<MAX_LOG2_NUM_POINTS));
		if (!splitVector.realp || !splitVector.imagp) {
			NSLog(@"Error allocating memory for FFT split buffer");
		}
		
		// Allocate memory for window
		windowVector = (double *)malloc(sizeof(double)*(1<<MAX_LOG2_NUM_POINTS));
		if (!windowVector) {
			NSLog(@"Error allocating memory for FFT window");
		}

		// Allocate memory for vector of FFT peaks
		peaksVector = (double *)malloc(sizeof(double)*(1<<MAX_LOG2_NUM_POINTS));
		if (!peaksVector) {
			NSLog(@"Error allocating memory for FFT peaks");
		}
		
		// Defaults
		numPoints = (1<<12);			// 4096-point FFT
		[self setWindowType:FFT_WINDOW_RECT];	// Rectangular window
		peaksEnabled = NO;			// Peak hold off
		decibelsPerDivision = 2.0;		// Match IB
		referenceLevel = -70;
		previousReferenceLevelKnobValue = 0;
		
		// Generate an event once per second to drain autorelease pool
		[NSEvent startPeriodicEventsAfterDelay:0 withPeriod:1];
	}
	
	return self;
}

- (void)dealloc
{
	// Stop generating events
	[NSEvent stopPeriodicEvents];
	
	// Deallocate peaks vector
	if (peaksVector) free(peaksVector);
	
	// Deallocate window
	if (windowVector) free(windowVector);
	
	// Deallocate FFT split buffer
	if (splitVector.realp) free(splitVector.realp);
	if (splitVector.imagp) free(splitVector.imagp);
	
	// Destroy FFT computation structure
	vDSP_destroy_fftsetupD(fftSetupD);
	
	// Deallocate USB driver
	
	// Parent class deallocations
}


//  ACTIONS  /////////////////////////////////////////////////////////////////

// Action for changing the number of dB per vertical division. Should be sent
// by an NS Menu.
- (IBAction)changeDecibelsPerDivision:(id)sender
{
	double	fillValue = negativeInfinity;
	
	
	// "Menu index to dB/div" look-up table. Make sure it matches entries
	// in Interface Builder.
	const float pointsLUT[] = {
		 0.2,
		 0.5,
		 1.0,
		 2.0,
		 5.0,
		10.0,
		20.0
	};
	
	if ([sender respondsToSelector:@selector(indexOfSelectedItem)]) {
		decibelsPerDivision = pointsLUT[[sender indexOfSelectedItem]];
	}
	
	// Re-initialize peak holds -- window change may have altered response
	if (peaksVector)
		vDSP_vfillD(&fillValue, peaksVector, 1, numPoints);
}

// Action for changing the number of FFT points. Should be sent by an NSMenu.
- (IBAction)changeNumPoints:(id)sender
{
	// "Menu index to number of FFT points" look-up table. Make sure it
	// matches entries in Interface Builder.
	const NSInteger	pointsLUT[] = {
		1<<9,	// 512
		1<<10,	// 1024
		1<<11,	// 2048
		1<<12,	// 4096
		1<<13,	// 8192
		1<<14,	// 16384
		1<<15,	// 32768
		1<<16	// 65536
	};
	
	if ([sender respondsToSelector:@selector(indexOfSelectedItem)]) {
		[self setNumPoints:pointsLUT[[sender indexOfSelectedItem]]];
	}
}

// Action for enabling or disabling peaks mode. Should be sent by an NSButton.
- (IBAction)changePeaksState:(id)sender
{
	double	fillValue = negativeInfinity;
	
	if ([sender respondsToSelector:@selector(state)]) {
		if ([sender state]) {
			vDSP_vfillD(&fillValue, peaksVector, 1, numPoints);
			peaksEnabled = YES;
		} else {
			peaksEnabled = NO;
		}
	}
}

// Action for changing the reference level. Should be sent by a circular
// NSSlider. The difference between the slider's current and previous value is
// used.
- (IBAction)changeReferenceLevel:(id)sender
{
	float diff;
	
	diff = [sender floatValue] - previousReferenceLevelKnobValue;
	previousReferenceLevelKnobValue = [sender floatValue];
	
	// Check if circular slider wrapped from 10 to 0
	if (diff < -1) {
		diff = 1;	// Step right
	}
	
	// Check if circular slider wrapped from 0 to 10
	if (diff > 1) {
		diff = -1;	// Step left
	}
	
	// Change reference level by a tenth of a division
	referenceLevel += diff * decibelsPerDivision / 10;
}

// Action for changing the FFT window type. Should be sent by an NSMenu.
- (IBAction)changeWindowType:(id)sender
{
	if ([sender respondsToSelector:@selector(indexOfSelectedItem)]) {
		[self setWindowType:[sender indexOfSelectedItem]];
	}
}


//  METHODS  /////////////////////////////////////////////////////////////////

// Method updates the number of FFT points. Also re-generates the FFT window
// and re-initialized the peak holds vector.
- (void)setNumPoints:(NSInteger)newNumPoints
{
	// Update the number of FFT points instance variable
	numPoints = newNumPoints;
	
	// Re-generate window
	[self setWindowType:windowType];
}

// Method sets the FFT window type. Also re-initialized the peak holds vector.
- (void)setWindowType:(WindowType)newWindowType
{
	double	fillValue = negativeInfinity;
	
	
	// Re-generate window vector based on new selection
	switch (newWindowType) {
			// Blackman window (full window)
		case FFT_WINDOW_BLKMAN:
			vDSP_blkman_windowD(windowVector, numPoints, 0);
			break;
			
			// Hamming window (full window)
		case FFT_WINDOW_HAMM:
			vDSP_hamm_windowD(windowVector, numPoints, 0);
			break;
			
			// Hanning window (full window)
		case FFT_WINDOW_HANN:
			vDSP_hann_windowD(windowVector, numPoints, 0);
			break;
			
			// Rectangular and unrecognized cases
		default:
			break;
	}
	
	// Re-initialize peak holds -- window change may have altered response
	if (peaksVector)
		vDSP_vfillD(&fillValue, peaksVector, 1, numPoints);
	
	// Lastly, update the window type instance variable
	windowType = newWindowType;
}


//  DATA SOURCE  /////////////////////////////////////////////////////////////

// Request data from driver, transform it, and render a corresponding trace
- (NSData *)traceData:(SpectrogramViewGL *)aSpectrogramViewGL index:(NSInteger)aIndex viewWidth:(NSInteger)width
{
	int i;
	short	*hwBuffer;
	NSData	*hwData;
	NSData	*trData = nil;
	double	 zerodbm = 0.063245553203368; // 1 milliwatt reference
	double	 scaleFactor = numPoints;
	double	 dbScaleFactor = 5*decibelsPerDivision;
	double	 dbShiftFactor = -referenceLevel;
	
	double	 loThreshold	= -1.0;		// Lower trace clip 
	double	 hiThreshold	= +1.0;		// Upper trace clip
	
	
	// Request buffer object from driver
	hwData = [usbDriver buffer];
	
	// Verify that a buffer object was available
	if (hwData) {

		// Convert 8-bit signed samples provided by hardware into
		// real floating-point samples, split according to requirements
		// for in-place FFT computation.
		hwBuffer = (short *)[hwData bytes];
		for (i = 0; i < numPoints && i < [hwData length]/sizeof(short); i++) {
			splitVector.realp[i] = hwBuffer[i] / 32768.0;
		}
		
		// Apply window if not rectangular
		if (windowType) {
			vDSP_vmulD(splitVector.realp, 1, windowVector, 1, splitVector.realp, 1, numPoints);
		}
		
		// Convert from interleaved to split form expected by FFT computer
		vDSP_ctozD((DSPDoubleComplex *)splitVector.realp, 2, &splitVector, 1, numPoints);
		
		// Compute in-place real FFT
		vDSP_fft_zripD(fftSetupD, &splitVector, 1, log2(numPoints), FFT_FORWARD);
		
		// Compute in-place magnitudes
		vDSP_zvabsD(&splitVector, 1, splitVector.realp, 1, numPoints/2);
		
		// Normalize
		vDSP_vsdivD(splitVector.realp, 1, &scaleFactor, splitVector.realp, 1, numPoints/2);
		
		// Convert to decibels
		vDSP_vdbconD(splitVector.realp, 1, &zerodbm, splitVector.realp, 1, numPoints/2, 0);
		
		// Peak hold mode?
		if (peaksEnabled) {
			// Yes, compute vector maximums and then package bytes into data object
			vDSP_vmaxD(splitVector.realp, 1, peaksVector, 1, peaksVector, 1, numPoints/2);
			
			// Shift to match reference level setting
			vDSP_vsaddD(peaksVector, 1, &dbShiftFactor, splitVector.realp, 1, numPoints/2);		
		} else {
			// Shift to match reference level setting
			vDSP_vsaddD(splitVector.realp, 1, &dbShiftFactor, splitVector.realp, 1, numPoints/2);				
		}
		
		// Scale to match dB/div setting
		vDSP_vsdivD(splitVector.realp, 1, &dbScaleFactor, splitVector.realp, 1, numPoints/2);
		
		// Clip to view
		vDSP_vclipD(splitVector.realp, 1, &loThreshold, &hiThreshold, splitVector.realp, 1, numPoints/2);
		
		trData = [NSData dataWithBytesNoCopy:splitVector.realp length:sizeof(double)*numPoints/2 freeWhenDone:NO];

		// Release data object for deallocation
	}

	return trData;
}


///  DELEGATES  ////////////////////////////////////////////////////////////////

// When user clicks on application's icon in Dock, re-open application's window
// if closed and bring it to the front.
- (BOOL)applicationShouldHandleReopen:(NSApplication *)app
		    hasVisibleWindows:(BOOL)flag
{
	if (!flag) {
		[mainWindow makeKeyAndOrderFront:nil];
	}
	
	return YES;
}

@end