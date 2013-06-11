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

#import	<Accelerate/Accelerate.h>
#import <Cocoa/Cocoa.h>

#import "SpectrogramViewGL.h"
#import "USBDriver.h"

// Available FFT windows. Make sure that order matches order of menu items in
// Interface Builder.
typedef enum {
	FFT_WINDOW_RECT = 0,
	FFT_WINDOW_BLKMAN,
	FFT_WINDOW_HAMM,
	FFT_WINDOW_HANN
} WindowType;

@interface AppController : NSObject {
	IBOutlet NSWindow	*mainWindow;
	
	USBDriver		*usbDriver;
	FFTSetupD		 fftSetupD;

	// Vectors
	DSPDoubleSplitComplex	 splitVector;
	double			*windowVector;
	double			*peaksVector;
	
	// Parameters
	NSInteger		 numPoints;
	WindowType		 windowType;
	bool			 peaksEnabled;
	double			 referenceLevel;
	double			 decibelsPerDivision;
	double			 previousReferenceLevelKnobValue;
}

// Actions for available from user interface
- (IBAction)changeDecibelsPerDivision:(id)sender;
- (IBAction)changeNumPoints:(id)sender;
- (IBAction)changePeaksState:(id)sender;
- (IBAction)changeReferenceLevel:(id)sender;
- (IBAction)changeWindowType:(id)sender;

// Instance methods
- (void)setNumPoints:(NSInteger)newNumPoints;
- (void)setWindowType:(WindowType)newWindowType;

// Data source methods called by connected view
- (NSData *)traceData:(SpectrogramViewGL *)aSpectrogramViewGL index:(NSInteger)aIndex viewWidth:(NSInteger)width;
@end