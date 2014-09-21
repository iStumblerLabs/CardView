#import <Cocoa/Cocoa.h>


@interface CardActionCell : NSProxy <NSTextAttachmentCell>
{
    NSPoint baseline_offset;
    NSActionCell* action_cell;
    NSTextAttachment* attachment;
}

+ (CardActionCell*) proxyWithActionCell:(NSActionCell*) cell;

- (id) initWithActionCell:(NSActionCell*) cell;

- (NSActionCell*) actionCell;
- (void) setActionCell:(NSActionCell*) cell;

- (void) setCellBaselineOffset:(NSPoint) offset;

@end

/* Copyright (c) 2014, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license in license.txt. */
