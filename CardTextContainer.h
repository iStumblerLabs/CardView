#import <Cocoa/Cocoa.h>

@interface CardTextContainer : NSTextContainer
{
    NSSize cutout;
}

- (id) initWithContainerSize:(NSSize)containerSize cutoutSize:(NSSize)cutoutSize;

- (NSSize) cutoutSize;
- (void) setCutoutSize:(NSSize)cutoutSize;

@end

/** Copyright (c) 2014-2016, Alf Watt (alf@istumbler.net). All rights reserved.
    Redistribution and use permitted under MIT License in README.md. **/
