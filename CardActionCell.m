#import "CardActionCell.h"


@implementation CardActionCell

+ (CardActionCell*) proxyWithActionCell:(NSActionCell*) cell
{
    return [[CardActionCell alloc] initWithActionCell:cell];
}

- (id) initWithActionCell:(NSActionCell*) cell
{
    if (self) {
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
    if (cell != action_cell) {
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

- (void) setAttachment:(NSTextAttachment*)anAttachment
{
    if (attachment != anAttachment) {
        attachment = anAttachment;
    }
}

- (NSPoint) cellBaselineOffset
{
    return baseline_offset;
}

- (void) setCellBaselineOffset:(NSPoint)offset
{
    baseline_offset = offset;
}

- (NSRect) cellFrameForTextContainer:(NSTextContainer*)container proposedLineFragment:(NSRect)proposed glyphPosition:(NSPoint)position characterIndex:(NSUInteger)index
{
    return proposed;
}

- (void) drawWithFrame:(NSRect)frame inView:(NSView*)view characterIndex:(NSUInteger)index
{
    [action_cell drawWithFrame:frame inView:view];
}

- (void) drawWithFrame:(NSRect)frame inView:(NSView*)view characterIndex:(NSUInteger)index layoutManager:(NSLayoutManager*)layout
{
    [action_cell drawWithFrame:frame inView:view];
}

- (void) highlight:(BOOL)flag withFrame:(NSRect)frame inView:(NSView *)view
{
    [action_cell highlight:flag withFrame:frame inView:view];
}

- (BOOL) wantsToTrackMouse
{
    return YES;
}

- (BOOL) wantsToTrackMouseForEvent:(NSEvent*)event inRect:(NSRect)frame ofView:(NSView*)view atCharacterIndex:(NSUInteger)index
{
    return YES;
}

- (BOOL) trackMouse:(NSEvent*)event inRect:(NSRect)frame ofView:(NSView*)view atCharacterIndex:(NSUInteger)index untilMouseUp:(BOOL)flag
{
    return [[self actionCell] trackMouse:event inRect:frame ofView:view untilMouseUp:flag];
}

- (BOOL) trackMouse:(NSEvent*)event inRect:(NSRect)frame ofView:(NSView*)view untilMouseUp:(BOOL)flag
{
    return [[self actionCell] trackMouse:event inRect:frame ofView:view untilMouseUp:flag];
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

/** Copyright (c) 2014-2016, Alf Watt (alf@istumbler.net). All rights reserved.
    Redistribution and use permitted under MIT License in README.md. **/
