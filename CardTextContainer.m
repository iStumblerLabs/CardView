#import "CardTextContainer.h"


@implementation CardTextContainer

- (id) initWithContainerSize:(NSSize)containerSize cutoutSize:(NSSize)cutoutSize
{
    if ((self = [super initWithContainerSize:containerSize]))
        [self setCutoutSize:cutoutSize];
    return self;
}

- (NSSize) cutoutSize
{
    return cutout;
}

- (void) setCutoutSize:(NSSize)cutoutSize
{
    cutout = cutoutSize;
}

#pragma mark NSTextContainer Methods

- (BOOL) isSimpleRectangularTextContainer 
{
    return NO; 
}

- (BOOL) containsPoint:(NSPoint)point 
{
    if ( point.x <= cutout.width && point.y <= cutout.height) {
		return NO;
    }
	return YES;
}

- (NSRect) lineFragmentRectForProposedRect:(NSRect)proposed
                            sweepDirection:(NSLineSweepDirection)sweep
                         movementDirection:(NSLineMovementDirection)movement
                             remainingRect:(NSRect*)remaining
{
    if(NSMinY(proposed) < cutout.height) {
		proposed.origin.x = cutout.width;
    }
    
	return [super lineFragmentRectForProposedRect:proposed
                                   sweepDirection:sweep
                                movementDirection:movement
                                    remainingRect:remaining];
}


@end

/** Copyright (c) 2014-2016, Alf Watt (alf@istumbler.net). All rights reserved.
    Redistribution and use permitted under MIT License in README.md. **/
