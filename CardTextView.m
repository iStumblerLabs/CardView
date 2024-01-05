#import "CardTextView.h"

#if IL_APP_KIT
#import "CardSeparatorCell.h"
#import "CardImageCell.h"
#endif

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

#pragma mark - NSViews

- (void) initView
{
    self.columns = @[@(-0.33), @(5)]; // 40% right-aligned with a ten pt gutter
#if TARGET_OS_TV
    self.fontSize = 24;
#else
    self.fontSize = [ILFont smallSystemFontSize];
#endif
}

- (void) updateView
{
#if IL_APP_KIT
    [self setNeedsDisplay:YES];
#elif IL_UI_KIT
    [self setNeedsDisplay];
#endif
}

#pragma mark - ILView

- (id) initWithFrame:(CGRect)frame
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

#pragma mark -

- (void) clearCard
{
    [self.textStorage setAttributedString:[NSAS attributedString:@""]];
}

#pragma mark -

- (NSTextAttachment*) clickedAttachment
{
    NSTextAttachment* attachment = nil;
#if IL_APP_KIT
    CGPoint click = [self convertPoint:NSApp.currentEvent.locationInWindow fromView:nil];
            click.y -= self.textContainerInset.height;
            click.x -= self.textContainerInset.width;
    NSUInteger index = [self.layoutManager glyphIndexForPoint:click inTextContainer:[self textContainer]];
    attachment = [self.textStorage attribute:NSAttachmentAttributeName atIndex:index effectiveRange:nil];
#endif
    return attachment;
}

#pragma mark - Tabs

- (NSParagraphStyle*) paragraphStyleForColumns:(NSArray*)columnWidths
{
    NSMutableParagraphStyle* style = [NSMutableParagraphStyle new];
#if IL_APP_KIT
    NSMutableArray* stops = [NSMutableArray new];
    CGFloat columnEdge = 0;
    for (NSNumber* stop in columnWidths) {
        CGFloat stopValue = stop.doubleValue;
        NSTextTabType tabType = NSLeftTabStopType;
        if (stopValue < 0) { // it's a right tab
            tabType = NSRightTabStopType;
        }
        
        if ((stopValue > -1.0) && (stopValue < 1.0)) { // it's a fraction of the width of the frame
            stopValue = (self.frame.size.width * fabs(stopValue)); // be positive
        }
        else {
            stopValue = fabs(stopValue); // be positive
        }
        
        columnEdge += stopValue;
        [stops addObject:[NSTextTab.alloc initWithType:tabType location:columnEdge]];
    }
    // NSLog(@"tab stops: %@", stops);
    style.firstLineHeadIndent = 0;
    style.headIndent = columnEdge;
    [style setTabStops:stops];
#endif
    return style;
}

- (NSDictionary*) attributesForSize:(CGFloat)fontSize
{
    ILFont* tagFont = [ILFont systemFontOfSize:fontSize];
    return @{ CardTextReplaceableStyleAttributeName: @(YES),
              NSParagraphStyleAttributeName: [self paragraphStyleForColumns:self.columns],
              NSFontAttributeName: tagFont,
              NSForegroundColorAttributeName: ILColor.textColor};
}

- (NSDictionary*) headerAttributesForSize:(CGFloat)fontSize tabStops:(NSArray*)tabStops
{
    ILFont* tag_font = [ILFont boldSystemFontOfSize:fontSize];
    return @{ CardTextReplaceableStyleAttributeName: @(YES),
              NSParagraphStyleAttributeName: [self paragraphStyleForColumns:self.columns],
              NSFontAttributeName: tag_font,
              NSForegroundColorAttributeName: ILColor.textColor};
}

- (NSDictionary*) centeredAttributesForSize:(CGFloat) fontSize
{
    ILFont* font = [ILFont systemFontOfSize:fontSize];
    NSMutableParagraphStyle* style = NSMutableParagraphStyle.new;
    style.alignment = NSTextAlignmentCenter;
    style.tabStops = @[]; // clear tabs
    return @{ NSParagraphStyleAttributeName: style,
              NSFontAttributeName: font,
              NSForegroundColorAttributeName: ILColor.textColor};
}

- (NSDictionary*) labelAttributesForSize:(CGFloat) fontSize
{
    return @{ CardTextReplaceableStyleAttributeName: @(YES),
              NSParagraphStyleAttributeName: [self paragraphStyleForColumns:self.columns],
              NSFontAttributeName: [ILFont boldSystemFontOfSize:fontSize],
              NSForegroundColorAttributeName: ILColor.textColor};
}

- (NSDictionary*) grayAttributesForSize:(CGFloat) fontSize
{
    return @{ CardTextReplaceableStyleAttributeName: @(YES),
              NSParagraphStyleAttributeName: [self paragraphStyleForColumns:self.columns],
              NSFontAttributeName: [ILFont systemFontOfSize:fontSize],
              NSForegroundColorAttributeName: ILColor.grayColor};
}

- (NSDictionary*) valueAttributesForSize:(CGFloat) fontSize
{
    return @{ CardTextReplaceableStyleAttributeName: @(YES),
              NSParagraphStyleAttributeName: [self paragraphStyleForColumns:self.columns],
              NSFontAttributeName: [ILFont systemFontOfSize:fontSize],
              NSForegroundColorAttributeName: ILColor.textColor};
}

- (NSDictionary*) keywordAttributesForSize:(CGFloat) fontSize
{
    return @{ CardTextReplaceableStyleAttributeName: @(YES),
              NSParagraphStyleAttributeName: [self paragraphStyleForColumns:self.columns],
              NSFontAttributeName: [ILFont systemFontOfSize:fontSize],
              NSForegroundColorAttributeName: ILColor.textColor};
}

- (NSDictionary*) contentAttributesForSize:(CGFloat) fontSize
{
    return @{ NSParagraphStyleAttributeName: [NSParagraphStyle defaultParagraphStyle],
              NSFontAttributeName: [ILFont systemFontOfSize:fontSize],
              NSForegroundColorAttributeName: ILColor.textColor};
}


#pragma mark - Appending Strings

- (NSAttributedString*) appendHeaderString:(NSString*)string
{
    NSAS* attrString = nil;
    if (string) {
        NSMutableDictionary* attrs = [self centeredAttributesForSize:self.fontSize].mutableCopy;
        attrs[NSFontAttributeName] = [ILFont boldSystemFontOfSize:(self.fontSize * 1.2)];
        attrString = [NSAS.alloc initWithString:string attributes:attrs];
        [self.textStorage appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendSubheaderString:(NSString*)string
{
    NSAS* attrString = nil;
    if (string) {
        NSMutableDictionary* attrs = [self attributesForSize:self.fontSize].mutableCopy;
        attrs[NSFontAttributeName] = [ILFont boldSystemFontOfSize:[attrs[NSFontAttributeName] pointSize]];
        attrString = [NSAS.alloc initWithString:string attributes:attrs];
        [self.textStorage appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendCenteredString:(NSString*) string
{
    NSAS* attrString = nil;
    if (string) {
        NSMutableDictionary* attrs = [self centeredAttributesForSize:self.fontSize].mutableCopy;
        attrString = [NSAS.alloc initWithString:string attributes:attrs];
        [self.textStorage appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendLabelString:(NSString*) string
{
    NSAS* attrString = nil;
    if (string) {
        NSDictionary* attrs = [self labelAttributesForSize:self.fontSize];
        attrString = [NSAS.alloc initWithString:string attributes:attrs];
        [self.textStorage appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendGrayString:(NSString*) string
{
    NSAS* attrString = nil;
    if (string) {
        NSDictionary* attrs = [self grayAttributesForSize:self.fontSize];
        attrString = [NSAS.alloc initWithString:string attributes:attrs];
        [self.textStorage appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendValueString:(NSString*) string
{
    NSAS* attrString = nil;
    if (string) {
        NSDictionary* attrs = [self valueAttributesForSize:self.fontSize];
        attrString = [NSAS.alloc initWithString:string attributes:attrs];
        [self.textStorage appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendKeywordString:(NSString*) string
{
    NSAS* attrString = nil;
    if (string) {
        NSDictionary* attrs = [self keywordAttributesForSize:self.fontSize];
        attrString = [NSAS.alloc initWithString:string attributes:attrs];
        [self.textStorage appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendMonospaceString:(NSString*)string
{
    NSAS* attrString = nil;
    if (string) {
        NSMutableDictionary* attrs = [self attributesForSize:self.fontSize].mutableCopy;
        attrs[NSFontAttributeName] = [ILFont userFixedPitchFontOfSize:[attrs[NSFontAttributeName] pointSize]];
        attrString = [NSAS.alloc initWithString:string attributes:attrs];
        [self.textStorage appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendLinkTo:(NSString*) url withText:(NSString*) label
{
    NSAS* attrString = nil;
    if (url) {
        NSMutableDictionary* attrs = [self attributesForSize:self.fontSize].mutableCopy;
        attrs[NSLinkAttributeName] = url;
        attrString = [NSAS.alloc initWithString:(label ?: url) attributes:attrs];
        [self.textStorage appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendContentString:(NSString*) string
{
    NSAS* attrString = nil;
    if (string) {
        NSDictionary* attrs = [self contentAttributesForSize:self.fontSize];
        attrString = [NSAS.alloc initWithString:string attributes:attrs];
        [self.textStorage appendAttributedString:attrString];
    }
    return attrString;
}

#pragma mark - Rules

- (NSAttributedString*) appendHorizontalRule;
{
    NSAS* rule = [self appendHorizontalRuleWithColor:ILColor.disabledControlTextColor width:1];
    return rule;
}

- (NSAttributedString*) appendHorizontalRuleWithAccentColor;
{
    ILColor* color = ILColor.disabledControlTextColor;
#if IL_APP_KIT && MAC_OS_X_VERSION_10_14
    if (@available(macOS 10.14, *)) {
        color = NSColor.controlAccentColor;
    }
#endif
    NSAS* rule = [self appendHorizontalRuleWithColor:color width:1];
    return rule;
}

- (NSAttributedString*) appendHorizontalRuleWithColor:(ILColor*) color width:(CGFloat) width
{
    NSAttributedString* attrString = nil;
#if IL_APP_KIT
    attrString = [CardSeparatorCell separatorWithColor:color width:width];
    [self appendNewline]; // each rule is it's own paragrah
    [self.textStorage appendAttributedString:attrString];
    [self appendNewline]; // and clears the next line below it
#endif
    return attrString;
}

- (NSAttributedString*) appendImage:(ILImage*) image
{
    return [self appendImage:image withAttributes:[self centeredAttributesForSize:self.fontSize]];
}

- (NSAttributedString*) appendImage:(ILImage*) image withAttributes:(NSDictionary*) attributes
{
    NSAttributedString* attrString = nil;
    if (image) {
#if IL_APP_KIT
        CardImageCell* attachment = [CardImageCell cellWithImage:image];
        attrString = [NSAttributedString attributedStringWithAttachmentCell:attachment];
#elif IL_UI_KIT
        NSTextAttachment* attachment = [NSTextAttachment new];
        attachment.image = image;
        attachment.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        attrString = [NSAttributedString attributedStringWithAttachment:attachment];
#endif
        if (attributes) {
            NSMutableDictionary* attrs = attributes.mutableCopy;
            NSMutableAttributedString* styled = attrString.mutableCopy;

            attrs[NSAttachmentAttributeName] = [attrString attribute:NSAttachmentAttributeName atIndex:0 effectiveRange:nil];
            [styled setAttributes:attrs range:NSMakeRange(0, styled.length)];
            attrString = styled;
        }
        
        [[self textStorage] appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendFormatted:(id) object withAttributes:(NSDictionary*) attributes
{
    NSFormatter* formatter = [CardTextView registeredFormatterForClass:[object class]];
    NSAttributedString* formatted = nil;
    if (!object) {
        formatted = [NSAttributedString.alloc initWithString:@"-" attributes:attributes];
    }
    else if (formatter) {
        if ([formatter respondsToSelector:@selector(attributedStringForObjectValue:withDefaultAttributes:)]) {
            formatted = [formatter attributedStringForObjectValue:object withDefaultAttributes:attributes];
        }
        else {
            formatted = [NSAttributedString.alloc initWithString:[formatter stringForObjectValue:object] attributes:attributes];
        }
    }
    else {
        formatted = [NSAttributedString.alloc initWithString:[object description] attributes:attributes];
    }

    if (formatted) {
        [self.textStorage appendAttributedString:formatted];
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
    [self.textStorage appendAttributedString:attributed];
    return attributed;
}

- (NSAttributedString*) appendNewline
{
    NSAS* newline = [self appendValueString:@"\n"];
    return newline;
}

- (NSAttributedString*) appendTab
{
    NSAS* newline = [self appendValueString:@"\t"];
    return newline;
}

#pragma mark -

- (void) replaceParagraphStyle:(NSParagraphStyle*)newStyle
{
#if IL_APP_KIT
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
#endif
}

#if IL_APP_KIT
#pragma mark - NSMenuValidation

- (BOOL) validateMenuItem:(NSMenuItem*)menuItem
{
    BOOL isValid = YES;
    
    if (menuItem.action == @selector(cut:)
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
#endif

#pragma mark - NSResponder

- (void) cut:(id) sender
{
    if (self.selectedRange.location > 0) {
        [super copy:sender]; // don't modify the contents here
    }
    else if ([self.delegate respondsToSelector:@selector(card:cut:)]) {
        [(id<CardTextViewDelegate>)self.delegate card:self cut:sender];
    }
}

- (void) copy:(id) sender
{
    if (self.selectedRange.length > 0) {
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

#if IL_APP_KIT
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
#endif

@end
