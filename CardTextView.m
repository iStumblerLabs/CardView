#import "CardTextView.h"

#import "CardSeparatorCell.h"
#import "CardImageCell.h"
#import "NSAttributedString+CardView.h"

static NSMutableDictionary* formatterRegistry;

static NSString* const CardTextReplaceableStyleAttributeName = @"CardTextReplaceableStyleAttribute";

@implementation CardTextView

+ (void) initialize
{
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        formatterRegistry = [NSMutableDictionary new];
    });
}

+ (void) registerFormatter:(NSFormatter*) formatter forClass:(Class) clzz
{
    NSString* className = NSStringFromClass(clzz);
    formatterRegistry[className] = formatter;
}

+ (NSFormatter*) registeredFormatterForClass:(Class) clzz
{
    // FML Inheritance, good news is most inheretance hierarcies are short
    NSString* className = NSStringFromClass(clzz);
    NSFormatter* formatter = formatterRegistry[className];
    while( !formatter) { // search until superclass doesn't work any more
        if( (clzz = [clzz superclass])) {
            className = NSStringFromClass(clzz);
            formatter = formatterRegistry[className];
        }
        else break; // while
    }
    
    return formatter;
}

#pragma mark -

- (void) initView {
    self.columns = @[@(-0.33), @(5)]; // 40% right-aligned with a ten pt gutter
    self.fontSize = [NSFont smallSystemFontSize];
}

- (id) initWithFrame:(NSRect)frame 
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        [self initView];
    }
    return self;
}

- (NSTextAttachment*) clickedAttachment
{
    NSPoint click = [self convertPoint:[[NSApp currentEvent] locationInWindow] fromView:nil];
            click.y -= [self textContainerInset].height;
            click.x -= [self textContainerInset].width;
    NSUInteger index = [[self layoutManager] glyphIndexForPoint:click inTextContainer:[self textContainer]];
    NSTextAttachment* attachment = [[self textStorage] attribute:NSAttachmentAttributeName atIndex:index effectiveRange:nil];
    return attachment;
}

#pragma mark - Tabs

- (NSParagraphStyle*) paragraphStyleForColumns:(NSArray*)columnWidths
{
    NSMutableParagraphStyle* style = [NSMutableParagraphStyle new];

    NSMutableArray* stops = [NSMutableArray new];
    CGFloat columnEdge = 0;
    for (NSNumber* stop in columnWidths) {
        CGFloat stopValue = [stop doubleValue];
        NSTextTabType tabType = NSLeftTabStopType;
        if (stopValue < 0) { // it's a right tab
            tabType = NSRightTabStopType;
            stopValue = fabs(stopValue); // be positive
        }
        
        if (stopValue > 0 && stopValue < 1) { // it's a fraction of the width of the frame
            stopValue = (self.frame.size.width * stopValue);
        }
        
        columnEdge += stopValue;
        [stops addObject:[[NSTextTab alloc] initWithType:tabType location:columnEdge]];
    }
    style.firstLineHeadIndent = 0;
    style.headIndent = columnEdge;
    [style setTabStops:stops];
    return style;
}

- (NSDictionary*) attributesForSize:(CGFloat)fontSize
{
    NSFont* tagFont = [NSFont systemFontOfSize:fontSize];
    return @{ CardTextReplaceableStyleAttributeName: @(YES),
              NSParagraphStyleAttributeName: [self paragraphStyleForColumns:self.columns],
              NSFontAttributeName: tagFont};
}

- (NSDictionary*) headerAttributesForSize:(CGFloat)fontSize tabStops:(NSArray*)tabStops
{
    NSFont* tag_font = [NSFont boldSystemFontOfSize:fontSize];
    return @{ CardTextReplaceableStyleAttributeName: @(YES),
              NSParagraphStyleAttributeName: [self paragraphStyleForColumns:self.columns],
              NSFontAttributeName: tag_font};
}

- (NSDictionary*) centeredAttributesForSize:(CGFloat) fontSize
{
    NSFont* font = [NSFont systemFontOfSize:fontSize];
    NSMutableParagraphStyle* style = [NSMutableParagraphStyle new];
    style.alignment = NSTextAlignmentCenter;
    style.tabStops = @[]; // clear tabs
    return @{ NSParagraphStyleAttributeName: style,
              NSFontAttributeName: font};
}

- (NSDictionary*) labelAttributesForSize:(CGFloat) fontSize
{
    return @{ CardTextReplaceableStyleAttributeName: @(YES),
              NSParagraphStyleAttributeName: [self paragraphStyleForColumns:self.columns],
              NSFontAttributeName: [NSFont boldSystemFontOfSize:fontSize]};
}

- (NSDictionary*) grayAttributesForSize:(CGFloat) fontSize
{
    return @{ CardTextReplaceableStyleAttributeName: @(YES),
              NSParagraphStyleAttributeName: [self paragraphStyleForColumns:self.columns],
              NSFontAttributeName: [NSFont systemFontOfSize:fontSize],
              NSForegroundColorAttributeName: [NSColor grayColor]};
}

- (NSDictionary*) valueAttributesForSize:(CGFloat) fontSize
{
    return @{ CardTextReplaceableStyleAttributeName: @(YES),
              NSParagraphStyleAttributeName: [self paragraphStyleForColumns:self.columns],
              NSFontAttributeName: [NSFont systemFontOfSize:fontSize]};
}

- (NSDictionary*) keywordAttributesForSize:(CGFloat) fontSize
{
    return @{ CardTextReplaceableStyleAttributeName: @(YES),
              NSParagraphStyleAttributeName: [self paragraphStyleForColumns:self.columns],
              NSFontAttributeName: [NSFont systemFontOfSize:fontSize]};
}

- (NSDictionary*) contentAttributesForSize:(CGFloat) fontSize
{
    return @{ NSParagraphStyleAttributeName: [NSParagraphStyle defaultParagraphStyle],
              NSFontAttributeName: [NSFont systemFontOfSize:fontSize]};
}


#pragma mark - Appending Strings

- (NSAttributedString*) appendHeaderString:(NSString*)string
{
    NSAS* attrString = nil;
    if (string) {
        NSMutableDictionary* attrs = [[self centeredAttributesForSize:self.fontSize] mutableCopy];
        attrs[NSFontAttributeName] = [NSFont boldSystemFontOfSize:(self.fontSize * 1.2)];
        attrString = [[NSAS alloc] initWithString:string attributes:attrs];
        [[self textStorage] appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendSubheaderString:(NSString*)string
{
    NSAS* attrString = nil;
    if (string) {
        NSMutableDictionary* attrs = [[self attributesForSize:self.fontSize] mutableCopy];
        attrs[NSFontAttributeName] = [NSFont boldSystemFontOfSize:[attrs[NSFontAttributeName] pointSize]];
        attrString = [[NSAS alloc] initWithString:string attributes:attrs];
        [[self textStorage] appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendLabelString:(NSString*) string
{
    NSAS* attrString = nil;
    if (string) {
        NSDictionary* attrs = [self labelAttributesForSize:self.fontSize];
        attrString = [[NSAS alloc] initWithString:string attributes:attrs];
        [[self textStorage] appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendGrayString:(NSString*) string
{
    NSAS* attrString = nil;
    if (string) {
        NSDictionary* attrs = [self grayAttributesForSize:self.fontSize];
        attrString = [[NSAS alloc] initWithString:string attributes:attrs];
        [[self textStorage] appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendValueString:(NSString*) string
{
    NSAS* attrString = nil;
    if (string) {
        NSDictionary* attrs = [self valueAttributesForSize:self.fontSize];
        attrString = [[NSAS alloc] initWithString:string attributes:attrs];
        [[self textStorage] appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendKeywordString:(NSString*) string
{
    NSAS* attrString = nil;
    if (string) {
        NSDictionary* attrs = [self keywordAttributesForSize:self.fontSize];
        attrString = [[NSAS alloc] initWithString:string attributes:attrs];
        [[self textStorage] appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendMonospaceString:(NSString*)string
{
    NSAS* attrString = nil;
    if (string) {
        NSMutableDictionary* attrs = [[self attributesForSize:self.fontSize] mutableCopy];
        attrs[NSFontAttributeName] = [NSFont userFixedPitchFontOfSize:[attrs[NSFontAttributeName] pointSize]];
        attrString = [[NSAS alloc] initWithString:string attributes:attrs];
        [[self textStorage] appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendContentString:(NSString*) string
{
    NSAS* attrString = nil;
    if (string) {
        NSDictionary* attrs = [self contentAttributesForSize:self.fontSize];
        attrString = [[NSAS alloc] initWithString:string attributes:attrs];
        [[self textStorage] appendAttributedString:attrString];
    }
    return attrString;
}

#pragma mark - Rules

- (NSAttributedString*) appendHorizontalRule;
{
    NSAS* rule = [self appendHorizontalRuleWithColor:[NSColor grayColor] width:1];
    return rule;
}

- (NSAttributedString*) appendHorizontalRuleWithColor:(NSColor*) color width:(CGFloat) width
{
    NSAttributedString* attrString = [CardSeparatorCell separatorWithColor:color width:width];
    [self appendNewline]; // each rule is it's own paragrah
    [[self textStorage] appendAttributedString:attrString];
    [self appendNewline]; // and clears the next line below it
    return attrString;
}

- (NSAttributedString*) appendImage:(NSImage*) image
{
    NSAttributedString* attrString = nil;
    if (image) {
        CardImageCell* cell = [CardImageCell cellWithImage:image];
        attrString = [NSAttributedString attributedStringWithAttachmentCell:cell];
        [[self textStorage] appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendFormatted:(id) object withAttributes:(NSDictionary*) attributes
{
    NSFormatter* formatter = [CardTextView registeredFormatterForClass:[object class]];
    NSAttributedString* formatted = nil;
    if (!object) {
        formatted = [[NSAttributedString alloc] initWithString:@"-" attributes:attributes];
    }
    else if (formatter) {
        if ([formatter respondsToSelector:@selector(attributedStringForObjectValue:withDefaultAttributes:)]) {
            formatted = [formatter attributedStringForObjectValue:object withDefaultAttributes:attributes];
        }
        else {
            formatted = [[NSAttributedString alloc] initWithString:[formatter stringForObjectValue:object] attributes:attributes];
        }
    }
    else {
        formatted = [[NSAttributedString alloc] initWithString:[object description] attributes:attributes];
    }

    if (formatted) {
        [[self textStorage] appendAttributedString:formatted];
    }
    
    return formatted;
}

- (NSAttributedString*) appendValueFormatted:(id) object
{
    NSDictionary* valueAttrs = [self valueAttributesForSize:self.fontSize];
    return [self appendFormatted:object withAttributes:valueAttrs];
}

- (NSAttributedString*) appendContentFormatted:(id) object
{
    NSDictionary* contentAttrs = [self contentAttributesForSize:self.fontSize];
    return [self appendFormatted:object withAttributes:contentAttrs];
}

- (NSAttributedString*) append:(id) object withFormatter:(NSFormatter*) formatter
{
    NSDictionary* valueAttrs = [self valueAttributesForSize:self.fontSize];
    return [self append:object withFormatter:formatter andAttributes:valueAttrs];
}

- (NSAttributedString*) append:(id) object withFormatter:(NSFormatter*) formatter andAttributes:(NSDictionary*) attributes;
{
    NSAttributedString* attributed = [formatter attributedStringForObjectValue: object withDefaultAttributes:attributes];
    [[self textStorage] appendAttributedString:attributed];
    return attributed;
}

- (NSAttributedString*) appendNewline
{
    NSAS* newline = [self appendValueString:@"\n"];
    return newline;
}

- (void) replaceParagraphStyle:(NSParagraphStyle*)newStyle
{
    NSMAS* updatedString = [NSMAS new];
    for (NSTextStorage* storage in [[self textStorage] attributeRuns]) {
        NSDictionary* runAttrs = [storage attributesAtIndex:0 effectiveRange:nil];
        if (runAttrs[CardTextReplaceableStyleAttributeName]) {
            NSMutableDictionary* newAttrs = [runAttrs mutableCopy];
            [newAttrs setObject:newStyle forKey:NSParagraphStyleAttributeName];
            NSMAS* updatedRange = [[NSMAS alloc] initWithString:storage.string attributes:newAttrs];
            [updatedString appendAttributedString:updatedRange];
        }
        else {
            [updatedString appendAttributedString:storage];
        }
    }
    [self.textStorage setAttributedString:updatedString];
}

#pragma mark - NSMenuValidation

- (BOOL) validateMenuItem:(NSMenuItem*)menuItem
{
    BOOL isValid = YES;
    
    if( menuItem.action == @selector(cut:)
     || menuItem.action == @selector(copy:)
     || menuItem.action == @selector(paste:)
     || menuItem.action == @selector(pasteSearch:)
     || menuItem.action == @selector(pasteRuler:)
     || menuItem.action == @selector(pasteFont:)
     || menuItem.action == @selector(delete:)) {
        isValid = YES;
    }
    else {
        isValid = [super validateMenuItem:menuItem];
    }

//    NSLog(@"%@ validated: %@ %@", [self className], (isValid?@"YES":@"NO"), menuItem);
    return isValid;
}

#pragma mark - NSResponder

- (void) cut:(id) sender
{
    if ([self selectedRange].location > 0) {
        [super copy:sender]; // don't modify the contents here
    }
    else if ([self.delegate respondsToSelector:@selector(card:cut:)]) {
        [(id<CardTextViewDelegate>)self.delegate card:self cut:sender];
    }
}

- (void) copy:(id) sender
{
    if ([self selectedRange].length > 0) {
        [super copy:sender]; // do the superclass thing with the contents
    }
    else if ([self.delegate respondsToSelector:@selector(card:copy:)]) {
        [(id<CardTextViewDelegate>)self.delegate card:self copy:sender];
    }
}

- (void) paste:(id) sender
{
    if ([self.delegate respondsToSelector:@selector(card:paste:)]) {
        [(id<CardTextViewDelegate>)self.delegate card:self paste:sender];
    }
}

- (void) pasteSearch:(id) sender
{
    if ([self.delegate respondsToSelector:@selector(card:pasteSearch:)]) {
        [(id<CardTextViewDelegate>)self.delegate card:self pasteSearch:sender];
    }
}

- (void) pasteRuler:(id) sender
{
    if ([self.delegate respondsToSelector:@selector(card:pasteRuler:)]) {
        [(id<CardTextViewDelegate>)self.delegate card:self pasteRuler:sender];
    }
}

- (void) pasteFont:(id) sender
{
    if ([self.delegate respondsToSelector:@selector(card:pasteFont:)]) {
        [(id<CardTextViewDelegate>)self.delegate card:self pasteFont:sender];
    }
}

- (void) delete:(id) sender
{
    if ([self.delegate respondsToSelector:@selector(card:delete:)]) {
        [(id<CardTextViewDelegate>)self.delegate card:self delete:sender];
    }
}

#pragma mark - NSView

- (void) viewDidHide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super viewDidHide];
}

- (void) viewDidUnhide
{
    NSParagraphStyle* style = [self paragraphStyleForColumns:self.columns];
    [self performSelector:@selector(replaceParagraphStyle:) withObject:style afterDelay:0.1];
    [super viewDidUnhide];
}

- (void) setFrame:(NSRect) frameRect
{
    [super setFrame:frameRect];

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSParagraphStyle* style = [self paragraphStyleForColumns:self.columns];
    [self performSelector:@selector(replaceParagraphStyle:) withObject:style afterDelay:0.1];
/*
    NSSize insets = [self textContainerInset];
    NSSize frame = frameRect.size;
    [[self textContainer] setContainerSize:NSMakeSize(frame.width-(insets.width*2),
                                                      frame.height-(insets.height*2))];
*/
}

@end

/** Copyright (c) 2014-2017, Alf Watt (alf@istumbler.net). All rights reserved.
    Redistribution and use permitted under MIT License in README.md. **/
