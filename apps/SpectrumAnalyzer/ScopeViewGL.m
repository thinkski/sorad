//////////////////////////////////////////////////////////////////////////////
//
//  ScopeViewGL.m
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

#import "ScopeViewGL.h"


#define	kRefreshPeriod		(1.0/24.0)	// in seconds
#define	kNumberOfDivisions	10


@interface ScopeViewGL(Private)
- (void)animate:(id)anObject;
@end

@implementation ScopeViewGL(Private)
- (void)animate:(id)anObject
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	while (YES) {
		[self setNeedsDisplay:YES];
		[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:kRefreshPeriod]];
	}
	
	[NSThread exit];
}
@end

@implementation ScopeViewGL
@synthesize dataSource;

// Method for initializing view
- (id)initWithCoder:(NSCoder *)c
{
	int i;


	self = [super initWithCoder:c];
	
	if (self) {

		// Prepare an OpenGL context
		NSOpenGLContext *openGLContext = [self openGLContext];
		[openGLContext makeCurrentContext];
		
		// Configure the view: enable anti-aliasing, disable 3D
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		glDisable(GL_DEPTH_TEST);
		glEnable(GL_LINE_SMOOTH);
		glEnable(GL_BLEND);
		
		// Set line width to a single pixel
		glLineWidth(1);
		
		// Prepare a GL list that draws background grid
		gridList = glGenLists(1);
		if (gridList != 0) {
			glNewList(gridList, GL_COMPILE);

			// Saves anti-aliasing state, amongst others
			glPushAttrib(GL_ENABLE_BIT);
			
			// Disable anti-aliasing for the grid
			glDisable(GL_LINE_SMOOTH);
			glDisable(GL_BLEND);
			
			// Set grid color to gray
			glColor3f(0.25, 0.25, 0.25);

			// Draw grid
			glBegin(GL_LINES);
			for (i = 0; i < kNumberOfDivisions; i++) {
				glVertex2f(-1.0 + (2.0 / kNumberOfDivisions) * i, -1.0);
				glVertex2f(-1.0 + (2.0 / kNumberOfDivisions) * i,  1.0);
				glVertex2f(-1.0, -1.0 + (2.0 / kNumberOfDivisions) * i);
				glVertex2f( 1.0, -1.0 + (2.0 / kNumberOfDivisions) * i);
			}
			glEnd();
			
			// Restores anti-aliasing state, amongst others
			glPopAttrib();
			
			glEndList();
		}
		
		// Activate animation
		[NSThread detachNewThreadSelector:@selector(animate:) toTarget:self withObject:nil];
	}
	
	return self;
}

// This method is automatically called when the view resizes
- (void)reshape
{
	NSRect rect = [self bounds];
	glViewport(0, 0, rect.size.width, rect.size.height);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glMatrixMode(GL_MODELVIEW);
}

// Method for painting view. Should not be called manually -- will be called
// automatically when necessary
- (void)drawRect:(NSRect)rect
{
	int i, n;
	NSData *trData;
	GLdouble x, dx;
	double *traceVertex;
	NSAutoreleasePool *pool;
	
	
	pool = [[NSAutoreleasePool alloc] init];
	
	// Clear the background
	glClearColor (0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
	// Set the view point
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	// Draw grid
	glCallList(gridList);
	
	// Draw traces
	for (i = 0; i < [[self dataSource] traceCount:self]; i++) {

		// Set trace color
		glColor3f([[[self dataSource] traceColor:self index:i] redComponent],
			  [[[self dataSource] traceColor:self index:i] greenComponent],
			  [[[self dataSource] traceColor:self index:i] blueComponent]);
		
		// Request data object pointer from data source and retain
		trData = [[self dataSource] traceData:self index:i viewWidth:ceil(rect.size.width)];
		
		if (trData) {
			[trData retain];
			
			// Precompute pointer to vertex byte buffer
			traceVertex = (double *)[trData bytes];
			
			// Compute step size based on number of verticies
			dx = 2.0 / (([trData length] / sizeof(double))-1);
			
			// Draw trace
			glBegin(GL_LINES);
			for (n = 0, x = -1.0; n < ([trData length]/sizeof(double))-1; n++, x += dx) {
				glVertex2d(x, traceVertex[n]);
				glVertex2d(x + dx, traceVertex[n+1]);
			}
			glEnd();
			
			// Trace data read into OpenGL framework. Release for deallocation.
			//[trData release];
		}
	}

	// Flush back buffer to front (double buffering should be enabled in
	// Interface Builder)
	[[self openGLContext] flushBuffer];
}
@end