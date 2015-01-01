#import "CardTextContainer.h"


@implementation CardTextContainer

- (id) initWithContainerSize:(NSSize) container_size cutoutSize:(NSSize) cutout_size
{
    if ((self = [super initWithContainerSize:container_size]))
        [self setCutoutSize:cutout_size];
    return self;
}

- (NSSize) cutoutSize
{
    return cutout;
}

- (void) setCutoutSize:(NSSize) cutout_size
{
    cutout = cutout_size;
}

/* TODO 
- (NSRectCorner) cutoutCorner
{
    return corner;
}

- (void) setCutoutCorner:(NSRectCorner) cutout_corner
{
    corner = cutout_corner;
}

*/

#pragma mark NSTextContainer Methods

- (BOOL) isSimpleRectangularTextContainer 
{
    return NO; 
}

- (BOOL) containsPoint:(NSPoint)point 
{
	if ( point.x <= cutout.width && point.y <= cutout.height) // TODO use corner
		return NO;
	return YES;
}

- (NSRect) lineFragmentRectForProposedRect:(NSRect) proposed
                            sweepDirection:(NSLineSweepDirection) sweep
                         movementDirection:(NSLineMovementDirection) movement
                             remainingRect:(NSRect*) remaining 
{
	if(NSMinY(proposed) < cutout.height) // TODO use corner
		proposed.origin.x = cutout.width; // TODO use corner
	return [super lineFragmentRectForProposedRect:proposed
                                   sweepDirection:sweep
                                movementDirection:movement
                                    remainingRect:remaining];
}


@end

/* Copyright (c) 2014-2015, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license in license.txt. */
