#import "CardActionCell.h"


@implementation CardActionCell

+ (CardActionCell*) proxyWithActionCell:(NSActionCell*) cell
{
    return [[CardActionCell alloc] initWithActionCell:cell];
}

- (id) initWithActionCell:(NSActionCell*) cell
{
    if (self)
    {
        [self setActionCell:cell];
    }
    return self;
}

- (NSActionCell*) actionCell
{
    return action_cell;
}

- (void) setActionCell:(NSActionCell*) cell
{
    if (cell != action_cell)
    {
        action_cell = cell;
    }
}

#pragma mark - NSCell Methods


- (NSSize) cellSize
{
    return [action_cell cellSize];
}

- (void) drawWithFrame:(NSRect)cellFrame inView:(NSView*) aView
{
    [action_cell drawWithFrame:cellFrame inView:aView];
}

- (void)setControlSize:(NSControlSize) size
{
    [action_cell setControlSize:size];
}

- (NSControlSize) controlSize
{
    return [action_cell controlSize];
}

#pragma mark - NSTextAttachmentCell Methods

- (NSTextAttachment*) attachment
{
    return attachment;
}

- (void)setAttachment:(NSTextAttachment*) anAttachment
{
    if (attachment != anAttachment)
    {
        attachment = anAttachment;
    }
}

- (NSPoint) cellBaselineOffset
{
    return baseline_offset;
}

- (void) setCellBaselineOffset:(NSPoint) offset
{
    baseline_offset = offset;
}

- (NSRect) cellFrameForTextContainer:(NSTextContainer*) container
                proposedLineFragment:(NSRect) proposed
                       glyphPosition:(NSPoint) position
                      characterIndex:(NSUInteger) index
{
    return proposed;
}

- (void) drawWithFrame:(NSRect) cellFrame inView:(NSView*) aView characterIndex:(NSUInteger)charIndex
{
    [action_cell drawWithFrame:cellFrame inView:aView];
}

- (void) drawWithFrame:(NSRect) cellFrame inView:(NSView*) controlView characterIndex:(NSUInteger) charIndex layoutManager:(NSLayoutManager*) layoutManager
{
    [action_cell drawWithFrame:cellFrame inView:controlView];
}

- (void)highlight:(BOOL)flag withFrame:(NSRect)cellFrame inView:(NSView *)aView
{
    [action_cell highlight:flag withFrame:cellFrame inView:aView];
}

- (BOOL) wantsToTrackMouse
{
    return YES;
}

- (BOOL) wantsToTrackMouseForEvent:(NSEvent*) theEvent 
                            inRect:(NSRect) cellFrame
                            ofView:(NSView*) controlView 
                  atCharacterIndex:(NSUInteger) charIndex
{
    return YES;
}

- (BOOL) trackMouse:(NSEvent*)theEvent 
             inRect:(NSRect)cellFrame 
             ofView:(NSView*) aTextView 
   atCharacterIndex:(NSUInteger)charIndex
       untilMouseUp:(BOOL)flag
{
    return [[self actionCell] trackMouse:theEvent
                                   inRect:cellFrame
                                   ofView:aTextView
                             untilMouseUp:flag];
}

- (BOOL) trackMouse:(NSEvent*) theEvent 
             inRect:(NSRect) cellFrame 
             ofView:(NSView*) aTextView 
       untilMouseUp:(BOOL) flag
{
    return [[self actionCell] trackMouse:theEvent
                                   inRect:cellFrame
                                   ofView:aTextView
                             untilMouseUp:flag];
}

#pragma mark NSProxy Methods

- (NSMethodSignature*) methodSignatureForSelector:(SEL) selector
{
    return [[self actionCell] methodSignatureForSelector:selector];
}

- (void) forwardInvocation:(NSInvocation*) invocation
{
//    NSLog(@"forwardInvocation:%@", invocation);
    [invocation setTarget:[self actionCell]];
    [invocation invoke];
}

@end

/* Copyright (c) 2014-2016, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license in README.md. */

