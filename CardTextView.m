#import "CardTextView.h"

#import "CardSeparatorCell.h"
#import "CardImageCell.h"
#import "NSAttributedString+CardView.h"

@implementation CardTextView

+ (NSParagraphStyle*) cardViewTabsStyleForTabStop:(CGFloat) tabLocation gutterWidth:(CGFloat) gutterWidth
{
    NSMutableParagraphStyle* style = [NSMutableParagraphStyle new];
    NSTextTab* right_stop = [[NSTextTab alloc] initWithType:NSRightTabStopType location:tabLocation];
    NSTextTab* left_stop = [[NSTextTab alloc] initWithType:NSLeftTabStopType location:tabLocation+gutterWidth];
    [style setTabStops:@[right_stop, left_stop]];
    return style;
}


+ (NSDictionary*) cardViewTabsAttributesForSize:(CGFloat) fontSize tabStop:(CGFloat) tabStop gutterWidth:(CGFloat) gutterWidth
{
    NSFont* tag_font = [NSFont boldSystemFontOfSize:fontSize];
    return @{ NSParagraphStyleAttributeName: [CardTextView cardViewTabsStyleForTabStop:tabStop gutterWidth:gutterWidth],
              NSFontAttributeName: tag_font};
}

+ (NSDictionary*) cardViewCenteredAttributesForSize:(CGFloat) fontSize
{
    NSFont* font = [NSFont systemFontOfSize:fontSize];
    NSMutableParagraphStyle* style = [NSMutableParagraphStyle new];
    [style setAlignment:NSCenterTextAlignment];
    return @{ NSParagraphStyleAttributeName: style,
              NSFontAttributeName: font};
}

+ (NSDictionary*) cardViewLabelAttributesForSize:(CGFloat) fontSize
{
    return @{ NSFontAttributeName: [NSFont boldSystemFontOfSize:fontSize]};
}

+ (NSDictionary*) cardViewNoneAttributesForSize:(CGFloat) fontSize
{
    return @{ NSFontAttributeName: [NSFont systemFontOfSize:fontSize],
              NSForegroundColorAttributeName: [NSColor grayColor]};
}

+ (NSDictionary*) cardViewValueAttributesForSize:(CGFloat) fontSize
{
    return @{ NSFontAttributeName: [NSFont systemFontOfSize:fontSize]};
}

+ (NSDictionary*) cardViewKeywordAttributesForSize:(CGFloat) fontSize
{
    return @{ NSFontAttributeName: [NSFont systemFontOfSize:fontSize]};
}

#pragma mark -

- (id) initWithFrame:(NSRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.tabStop = 100;
        self.tabGutter = 10;
    }
    return self;
}

- (NSTextAttachment*) clickedAttachment
{
    NSPoint click = [self convertPoint:[[NSApp currentEvent] locationInWindow] fromView:nil];
    click.y -= [self textContainerInset].height;
    click.x -= [self textContainerInset].width;
    NSUInteger index = [[self layoutManager] glyphIndexForPoint:click inTextContainer:[self textContainer]];
    return [[self textStorage] attribute:NSAttachmentAttributeName atIndex:index effectiveRange:nil];
}

#pragma mark - append methods

- (NSAttributedString*) appendTabString:(NSString*) string tabStop:(CGFloat) tabStop gutterWidth:(CGFloat) gutterWidth
{
    NSDictionary* attrs = [CardTextView cardViewTabsAttributesForSize:[NSFont smallSystemFontSize] tabStop:tabStop gutterWidth:gutterWidth];
    if( !string) string = @"-";
    NSAS* attrString = [[NSAS alloc] initWithString:string attributes:attrs];
    [[self textStorage] appendAttributedString:attrString];
    return attrString;
}

- (NSAttributedString*) appendTabString:(NSString*) string
{
    NSDictionary* attrs = [CardTextView cardViewTabsAttributesForSize:[NSFont smallSystemFontSize] tabStop:self.tabStop gutterWidth:self.tabGutter];
    if( !string) string = @"-";
    NSAS* attrString = [[NSAS alloc] initWithString:string attributes:attrs];
    [[self textStorage] appendAttributedString:attrString];
    return attrString;
}

- (NSAttributedString*) appendLabelString:(NSString*) string
{
    NSDictionary* attrs = [CardTextView cardViewLabelAttributesForSize:[NSFont smallSystemFontSize]];
    if( !string) string = @"-";
    NSAS* attrString = [[NSAS alloc] initWithString:string attributes:attrs];
    [[self textStorage] appendAttributedString:attrString];
    return attrString;
}

- (NSAttributedString*) appendNoneString:(NSString*) string
{
    NSDictionary* attrs = [CardTextView cardViewNoneAttributesForSize:[NSFont smallSystemFontSize]];
    if( !string) string = @"-";
    NSAS* attrString = [[NSAS alloc] initWithString:string attributes:attrs];
    [[self textStorage] appendAttributedString:attrString];
    return attrString;
}

- (NSAttributedString*) appendValueString:(NSString*) string
{
    NSDictionary* attrs = [CardTextView cardViewValueAttributesForSize:[NSFont smallSystemFontSize]];
    if( !string) string = @"-";
    NSAS* attrString = [[NSAS alloc] initWithString:string attributes:attrs];
    [[self textStorage] appendAttributedString:attrString];
    return attrString;
}

- (NSAttributedString*) appendKeywordString:(NSString*) string
{
    NSDictionary* attrs = [CardTextView cardViewKeywordAttributesForSize:[NSFont smallSystemFontSize]];
    if( !string) string = @"-";
    NSAS* attrString = [[NSAS alloc] initWithString:string attributes:attrs];
    [[self textStorage] appendAttributedString:attrString];
    return attrString;
}

- (NSAttributedString*) appendHorizontalRule;
{
    return [self appendHorizontalRuleWithColor:[NSColor grayColor] width:1];
}

- (NSAttributedString*) appendHorizontalRuleWithColor:(NSColor*) color width:(CGFloat) width
{
    NSAttributedString* attrString = [CardSeparatorCell separatorWithColor:color width:width];
    [[self textStorage] appendAttributedString:attrString];
    return attrString;
}

- (NSAttributedString*) appendImage:(NSImage*) image
{
    CardImageCell* cell = [CardImageCell cellWithImage:image];
    NSAttributedString* attrString = [NSAttributedString attributedStringWithAttachmentCell:cell];
    [[self textStorage] appendAttributedString:attrString];
    return attrString;
}

- (NSAttributedString*) appendNewline
{
    return [self appendValueString:@"\n"];
}

#pragma mark - NSMenuValidation

- (BOOL) validateMenuItem:(NSMenuItem *)menuItem
{
    BOOL isValid = YES;
    
    if( menuItem.action == @selector(cut:)
       || menuItem.action == @selector(copy:)
       || menuItem.action == @selector(paste:)
       || menuItem.action == @selector(pasteSearch:)
       || menuItem.action == @selector(pasteRuler:)
       || menuItem.action == @selector(pasteFont:)
       || menuItem.action == @selector(delete:))
        isValid = YES;
    else
        isValid = [super validateMenuItem:menuItem];
        
    NSLog(@"validated: %@ %@", (isValid?@"YES":@"NO"), menuItem);
    return isValid;
}

#pragma mark - NSResponder

- (void) cut:(id) sender
{
    if( [self selectedRange].location > 0)
        [super copy:sender]; // don't modify the contents here
    else if( [self.delegate respondsToSelector:@selector(card:cut:)])
        [(id<CardTextViewDelegate>)self.delegate card:self cut:sender];
}

- (void) copy:(id) sender
{
    if( [self selectedRange].length > 0)
        [super copy:sender]; // do the superclass thing with the contents
    else if( [self.delegate respondsToSelector:@selector(card:copy:)])
        [(id<CardTextViewDelegate>)self.delegate card:self copy:sender];
}

- (void) paste:(id) sender
{
    if( [self.delegate respondsToSelector:@selector(card:paste:)])
        [(id<CardTextViewDelegate>)self.delegate card:self paste:sender];
}

- (void) pasteSearch:(id) sender
{
    if( [self.delegate respondsToSelector:@selector(card:pasteSearch:)])
        [(id<CardTextViewDelegate>)self.delegate card:self pasteSearch:sender];
}

- (void) pasteRuler:(id) sender
{
    if( [self.delegate respondsToSelector:@selector(card:pasteRuler:)])
        [(id<CardTextViewDelegate>)self.delegate card:self pasteRuler:sender];
}

- (void) pasteFont:(id) sender
{
    if( [self.delegate respondsToSelector:@selector(card:pasteFont:)])
        [(id<CardTextViewDelegate>)self.delegate card:self pasteFont:sender];
}

- (void) delete:(id) sender
{
    if( [self.delegate respondsToSelector:@selector(card:delete:)])
        [(id<CardTextViewDelegate>)self.delegate card:self delete:sender];
}

/*
#pragma mark NSTextView Methods

- (NSPoint) textContainerOrigin
{
    return NSMakePoint(10,10);
}

#pragma mark NSView Methods

- (void) setFrame:(NSRect) frameRect
{
    NSSize insets = [self textContainerInset];
    NSSize frame = frameRect.size;
    [[self textContainer] setContainerSize:NSMakeSize(frame.width-(insets.width*2),
                                                      frame.height-(insets.height*2))];
    [super setFrame:frameRect];
}
*/

@end

/* Copyright (c) 2014-2015, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license in license.txt. */
