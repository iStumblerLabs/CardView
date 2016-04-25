#import <Cocoa/Cocoa.h>


enum NSRectCorner
{
    NSTopLeft = 0,
    NSTopRight = 1,
    NSBottomLeft = 2,
    NSBottomRight = 3
};

@interface CardTextContainer : NSTextContainer
{
    NSSize cutout;
// TODO    NSRectCorner corner;
}

- (id) initWithContainerSize:(NSSize) container_size
                  cutoutSize:(NSSize) cutout_size;
// TODO                cutoutCorner:(NSRectCorner) cutout_corner;

- (NSSize) cutoutSize;
- (void) setCutoutSize:(NSSize) cutout_size;

/* TODO
- (NSRectCorner) cutoutCorner;
- (void) setCutoutCorner:(NSRectCorner) cutout_corner;
*/

@end

/* Copyright (c) 2014-2016, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license in README.md. */
