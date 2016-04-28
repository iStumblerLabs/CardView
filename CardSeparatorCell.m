#import "CardSeparatorCell.h"


@implementation CardSeparatorCell

+ (NSAttributedString*) separator 
{
    NSTextAttachment* divider = [NSTextAttachment new];
    [divider setAttachmentCell:[[CardSeparatorCell alloc] initWithColor:[NSColor grayColor] width:1]];
    return [NSAttributedString attributedStringWithAttachment:divider];
}

+ (NSAttributedString*) separatorWithColor:(NSColor*) color
{
    NSTextAttachment* divider = [NSTextAttachment new];
    [divider setAttachmentCell:[[CardSeparatorCell alloc] initWithColor:color width:1]];
    return [NSAttributedString attributedStringWithAttachment:divider];
}

+ (NSAttributedString*) separatorWithColor:(NSColor*) color width:(CGFloat) width
{
    CardSeparatorCell* cell = [[CardSeparatorCell alloc] initWithColor:color width:width];
    NSTextAttachment* divider = [NSTextAttachment new];
    [divider setAttachmentCell:cell];
    return [NSAttributedString attributedStringWithAttachment:divider];
}

#pragma mark -

- (id) initWithColor:(NSColor*) color width:(CGFloat) width
{
    if ((self = [super init])) {
        self.separator_color = color;
        self.separator_width = width;
    }
    return self;
}

#pragma mark - NSTextAttachmentCell

- (NSRect) cellFrameForTextContainer:(NSTextContainer*)textContainer proposedLineFragment:(NSRect)lineFrag glyphPosition:(NSPoint)position characterIndex:(NSUInteger)charIndex
{
	NSRect frag = [super cellFrameForTextContainer:textContainer proposedLineFragment:lineFrag glyphPosition:position characterIndex:charIndex];
	NSSize size = [textContainer containerSize];
	size.width -= 2.0*[textContainer lineFragmentPadding];
	
	frag.size.width = size.width - frag.origin.x;
    frag.size.height = self.separator_width+2;
	return frag;
}

- (void) drawWithFrame:(NSRect)frame inView:(NSView*)aView
{
    [NSGraphicsContext saveGraphicsState];
    [self.separator_color set];

    NSPoint start = NSMakePoint( frame.origin.x, frame.origin.y+(frame.size.height/2));
    NSPoint finish = NSMakePoint( frame.origin.x+frame.size.width, frame.origin.y+(frame.size.height/2));
    [NSBezierPath setDefaultLineWidth:self.separator_width];
	[NSBezierPath strokeLineFromPoint:start toPoint:finish];
    [NSGraphicsContext restoreGraphicsState];
}

@end

/** Copyright (c) 2014-2016, Alf Watt (alf@istumbler.net). All rights reserved.
    Redistribution and use permitted under MIT License in README.md. **/
