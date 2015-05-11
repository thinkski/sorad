////////////////////////////////////////////////////////////////////////////////
//
//  SpectrogramViewGL.m
//
//  A view class that displays a waterfall color spectrogram.
//
//  Copyright 2010 Chris Hiszpanski. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "SpectrogramViewGL.h"

@interface SpectrogramViewGL(Private)
- (void)animate:(id)anObject;
@end

@implementation SpectrogramViewGL(Private)
- (void)animate:(id)anObject
{
	@autoreleasepool {
	
		while (YES) {
			[self setNeedsDisplay:YES];
			[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:kRefreshPeriod]];
		}
	
    // Should never get here
	}
	[NSThread exit];
}
@end

@implementation SpectrogramViewGL

@synthesize dataSource;

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        // Prepare an OpenGL context
        NSOpenGLContext *openGLContext = [self openGLContext];
        [openGLContext makeCurrentContext];
        
        // Configure the view: enabled anti-aliasing, disable 3D
        glShadeModel(GL_FLAT);
        glDisable(GL_DEPTH_TEST);
        glDisable(GL_LINE_SMOOTH);
        glDisable(GL_BLEND);
        
		// Start animation.
        // Use separate thread so UI usage does not halt animation.
		[NSThread detachNewThreadSelector:@selector(animate:)
                                 toTarget:self
                               withObject:nil];
    }
    
    return self;
}

- (void)reshape
{
	NSRect rect = [self bounds];
	glViewport(0, 0, rect.size.width, rect.size.height);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glMatrixMode(GL_MODELVIEW);
}

- (void)drawRect:(NSRect)rect
{
    GLdouble             x, dx, dy;
    NSData              *data;
    double              *intensities;
    int                  n;
    
    @autoreleasepool {
    
    // Clear the background
        glClearColor (0.0, 0.0, 0.0, 0.0);
        glClear(GL_COLOR_BUFFER_BIT);
        
        // Request data object pointer from data source and retain
        data = [[self dataSource] traceData:self index:0 viewWidth:ceil(rect.size.width)];
        
        if (data) {
            
            intensities = (double *)[data bytes];
            
            // Compute step size based on number of verticies
            dx = 2.0 / (([data length] / sizeof(double))-1);
            dy = 2.0 / rect.size.height;
            
            // Scroll existing pixels
            glReadBuffer(GL_FRONT);
            glDrawBuffer(GL_BACK);
            glBlitFramebuffer(0, 1,                                                 // Source lower left corner
                              rect.size.width, rect.size.height,                    // Source upper right corner
                              0, 0,                                                 // Destination lower left corner
                              rect.size.width, rect.size.height-1,                  // Destination upper right corner
                              GL_COLOR_BUFFER_BIT,
                              GL_NEAREST);
            
            // Draw new row of pixels
            glBegin(GL_QUAD_STRIP);
            
                // Place "anchor" verticies
                glVertex2d(-1.0, 1.0);
                glVertex2d(-1.0, 1.0-dy);
            
                // Place "ladder" verticies
                for (n = 0, x = -1.0 + dx; n < ([data length]/sizeof(double)); n++, x += dx) {
                    if (intensities[n] < 0) {
                        glColor3d(0, 0, 0);
                    } else
                    if (0 <= intensities[n] && intensities[n] < 0.25) {
                        glColor3d(0, 0, 4*intensities[n]);
                    } else
                    if (0.25 <= intensities[n] && intensities[n] < 0.50) {
                        glColor3d(4*(intensities[n]-0.25), 0, 1.0-4*(intensities[n]-0.25));
                    } else
                    if (0.50 <= intensities[n] && intensities[n] < 0.75) {
                        glColor3d(1.0, 4*(intensities[n]-0.50), 0);
                    } else
                    if (0.75 <= intensities[n] && intensities[n] < 1.00) {
                        glColor3d(1.0, 1.0, 4*(intensities[n]-0.75));                    
                    } else {
                        glColor3d(1.0, 1.0, 1.0);
                    }             
                    glVertex2d(x, 1.0);
                    glVertex2d(x, 1.0-dy);
                }
            
            glEnd();
            
        }
        
        // Flush back buffer to front (double buffering should be enabled in IB)
        [[self openGLContext] flushBuffer];
    
    }
}

@end
