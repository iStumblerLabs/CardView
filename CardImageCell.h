#import <Cocoa/Cocoa.h>

@interface CardImageCell : NSTextAttachmentCell
{
    NSImageCell* image_cell;
}

+ (CardImageCell*) cellWithImage:(NSImage*) cell_image;

- (id) initWithImage:(NSImage*) cell_image;

@end

/* Copyright (c) 2014-2015, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license in license.txt. */
