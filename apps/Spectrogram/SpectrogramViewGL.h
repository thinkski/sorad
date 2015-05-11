//////////////////////////////////////////////////////////////////////////////
//
//  SpectrogramViewGL.h
//
//  A view class that displays a waterfall color spectrogram.
//
//  Copyright 2010 Chris Hiszpanski. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////

#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>

// 30 frames per second
#define	kRefreshPeriod (1.0/30.0)

@interface SpectrogramViewGL : NSOpenGLView {
	IBOutlet id dataSource;
}
@property (strong, readwrite) id dataSource;
@end

@interface NSObject(SpectrogramViewGLDataSource)
// Data source method for querying the data for a specific trace. Data should
// be a byte buffer of floating-point values.
- (NSData *)traceData:(SpectrogramViewGL *)aSpectrogramViewGL
                index:(NSInteger)aIndex
            viewWidth:(NSInteger)width;
@end