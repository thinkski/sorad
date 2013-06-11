//////////////////////////////////////////////////////////////////////////////
//
//  ScopeViewGL.h
//
//
//  A view class that emulates the screen of an oscilloscope, with a grid in
//  in back and one or more traces in the front. The traces need not
//  necessarily represent a time series. For example, a trace may correspond
//  to a frequency spectrum.
//
//
//  Copyright (C) 2009 Chris Hiszpanski. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////

#import <Cocoa/Cocoa.h>
#import <GLUT/GLUT.h>

@interface ScopeViewGL : NSOpenGLView {
	IBOutlet id dataSource;
	GLuint gridList;
}
@property (retain, readwrite) id dataSource;
@end

@interface NSObject(ScopeViewGLDataSource)
// Data source method for querying the data for a specific trace. Data should
// be a byte buffer of floating-point values.
- (NSData *)traceData:(ScopeViewGL *)aScopeViewGL
		index:(NSInteger)aIndex
	    viewWidth:(NSInteger)width;

// Data source method for querying the number of visible traces
- (NSInteger)traceCount:(ScopeViewGL *)aScopeViewGL;

// Data source method for querying the color of a specific trace
- (NSColor *)traceColor:(ScopeViewGL *)aScopeViewGL
		  index:(NSInteger)aIndex;
@end
