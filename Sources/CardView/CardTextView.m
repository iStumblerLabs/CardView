#import "include/CardTextView.h"

#if IL_APP_KIT
#import "include/CardSeparatorCell.h"
#import "include/CardImageCell.h"
#endif
#import "include/NSMutableAttributedString+CardView.h"

#define NSAS NSAttributedString
#define NSMAS NSMutableAttributedString

static NSMutableDictionary* formatterRegistry;

static NSString* const CardTextPromiseUUIDAttributeName = @"CardTextPromiseUUIDAttributeName";

// MARK: -

@interface CardTextView ()

@property(nonatomic,retain) NSMutableArray<NSParagraphStyle*>* styleStackStorage;

@end

// MARK: -

@implementation CardTextView

+ (void) initialize {
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        formatterRegistry = NSMutableDictionary.new;
    });
}

+ (void) registerFormatter:(NSFormatter*) formatter forClass:(Class) clzz {
    NSString* className = NSStringFromClass(clzz);
    formatterRegistry[className] = formatter;
}

+ (NSFormatter*) registeredFormatterForClass:(Class) clzz {
    // FML Inheritance, good news is most inheretance hierarcies are short
    NSString* className = NSStringFromClass(clzz);
    NSFormatter* formatter = formatterRegistry[className];
    while (!formatter) { // search until superclass doesn't work any more
        if( (clzz = [clzz superclass])) {
            className = NSStringFromClass(clzz);
            formatter = formatterRegistry[className];
        }
        else break; // while
    }

    return formatter;
}

// MARK: - ILViewLifecycle

- (void) initView {
    self.styleStackStorage = NSMutableArray.new;
    self.columns = @[@(-0.33), @(5)]; // 40% right-aligned with a ten pt gutter
#if TARGET_OS_TV
    self.fontSize = 24;
#else
    self.fontSize = ILFont.systemFontSize;
#endif
}

- (void) updateView {
#if IL_APP_KIT
    self.needsDisplay = YES;
#elif IL_UI_KIT
    [self setNeedsDisplay];
#endif
}

// MARK: - ILView

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self initView];
    }
    return self;
}

// MARK: -

- (void) clearCard {
    [self.textStorage setAttributedString:[NSAS attributedString:@""]];
}

// MARK: -

- (NSTextAttachment*) clickedAttachment {
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

// MARK: - Style

- (NSParagraphStyle*) topStyle {
    NSParagraphStyle* topStyle = NSParagraphStyle.defaultParagraphStyle;
    if (self.styleStackStorage.count > 0) {
        topStyle = self.styleStackStorage.firstObject;
    }
    return topStyle;
}

- (NSUInteger) pushStyle:(NSParagraphStyle*) currentStyle {
    [self.styleStackStorage insertObject:currentStyle atIndex:0];
    return self.styleStackStorage.count;
}

- (NSParagraphStyle*) popStyle {
    NSParagraphStyle* topStyle = self.topStyle;
    [self.styleStackStorage removeObjectAtIndex:0];
    return topStyle;
}

- (NSParagraphStyle*) paragraphStyleForColumns:(NSArray*)columnWidths {
    NSMutableParagraphStyle* style = NSMutableParagraphStyle.new;
#if IL_APP_KIT
    NSMutableArray* stops = NSMutableArray.new;
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
    style.lineBreakMode = NSLineBreakByCharWrapping;
    style.firstLineHeadIndent = 0;
    style.headIndent = columnEdge;
    style.tabStops = stops;
#endif
    return style;
}

// MARK: - Resizable Styles

- (NSAttributedString*) appendHeaderString:(NSString*)string {
    return [self.textStorage appendHeaderString:string size:self.fontSize style:self.topStyle];
}

- (NSAttributedString*) appendSubheaderString:(NSString*)string {
    return [self.textStorage appendSubheaderString:string size:self.fontSize style:self.topStyle];
}

- (NSAttributedString*) appendCenteredString:(NSString*) string {
    return [self.textStorage appendCenteredString:string size:self.fontSize style:self.topStyle];
}

- (NSAttributedString*) appendLabelString:(NSString*) string {
    return [self.textStorage appendLabelString:string size:self.fontSize style:self.topStyle];
}

- (NSAttributedString*) appendGrayString:(NSString*) string {
    return [self.textStorage appendGrayString:string size:self.fontSize style:self.topStyle];
}

- (NSAttributedString*) appendValueString:(NSString*) string {
    return [self.textStorage appendValueString:string size:self.fontSize style:self.topStyle];
}

- (NSAttributedString*) appendValueFormatted:(id) object {
    NSDictionary* valueAttrs = [self.textStorage valueAttributesForSize:self.fontSize style:self.topStyle];
    return [self appendFormatted:object withAttributes:valueAttrs];
}

- (NSAttributedString*) appendKeywordString:(NSString*) string {
    return [self.textStorage appendKeywordString:string size:self.fontSize style:self.topStyle];
}

- (NSAttributedString*) appendMonospaceString:(NSString*)string {
    return [self.textStorage appendMonospaceString:string size:self.fontSize style:self.topStyle];
}

- (NSAttributedString*) appendLinkTo:(NSString*) url withText:(NSString*) label {
    return [self.textStorage appendLinkTo:url withText:label size:self.fontSize style:self.topStyle];
}

// MARK: - Rules

- (NSAttributedString*) appendHorizontalRule; {
    return [self.textStorage appendHorizontalRule:self.topStyle];
}

- (NSAttributedString*) appendHorizontalRuleWithAccentColor {
    return [self.textStorage appendHorizontalRuleWithAccentColor:self.topStyle];
}

- (NSAttributedString*) appendHorizontalRuleWithColor:(ILColor*) color width:(CGFloat) width {
    return [self.textStorage appendHorizontalRuleWithColor:color width:width style:self.topStyle];
}

- (NSAttributedString*) appendNewline {
    return [self.textStorage appendNewline:self.fontSize style:self.topStyle];
}

- (NSAttributedString*) appendTab {
    return [self.textStorage appendTab:self.fontSize style:self.topStyle];
}

// MARK: - Images

- (NSAttributedString*) appendImage:(ILImage*) image {
    return [self.textStorage appendImage:image size:self.fontSize style:self.topStyle];
}

- (NSAttributedString*) appendImage:(ILImage*) image withAttributes:(NSDictionary*) attributes {
    return [self.textStorage appendImage:image withAttributes:attributes];
}

// MARK: - Strings

- (NSAttributedString*) appendString:(NSString*) string {
    return [self.textStorage appendString:string size:self.fontSize style:self.topStyle];
}

// MARK: - Formatted Objects

- (NSAttributedString*) formatted:(id) object withAttributes:(NSDictionary*) attributes {
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

    return formatted;
}

- (NSAttributedString*) appendFormatted:(id) object {
    NSDictionary* contentAttrs = [self.textStorage contentAttributesForSize:self.fontSize style:self.topStyle];
    return [self appendFormatted:object withAttributes:contentAttrs];
}

- (NSAttributedString*) appendFormatted:(id) object withAttributes:(NSDictionary*) attributes {
    NSAttributedString* formatted = [self formatted:object withAttributes:attributes];
    [self.textStorage appendAttributedString:formatted];
    return formatted;
}


- (NSAttributedString*) append:(id) object withFormatter:(NSFormatter*) formatter {
    NSDictionary* valueAttrs = [self.textStorage valueAttributesForSize:self.fontSize style:self.topStyle];
    return [self append:object withFormatter:formatter andAttributes:valueAttrs];
}

- (NSAttributedString*) append:(id) object withFormatter:(NSFormatter*) formatter andAttributes:(NSDictionary*) attributes {
    NSAttributedString* attributed = [formatter attributedStringForObjectValue:object withDefaultAttributes:attributes];
    [self.textStorage appendAttributedString:attributed];
    return attributed;
}

// MARK: - Promises

- (NSUUID*) appendPromiseWithAttributes:(NSDictionary*) attributes {
    NSUUID* promise = NSUUID.new;
    NSMutableDictionary* promisedAttributes = attributes.mutableCopy;
    promisedAttributes[CardTextPromiseUUIDAttributeName] = promise.UUIDString;
    [self.textStorage appendAttributedString:[NSAS.alloc initWithString:@"…" attributes:promisedAttributes]];
    return promise;
}

- (void) fulfillPromise:(NSUUID*) promise withString:(NSAttributedString*) promisedString {
    for (NSTextStorage* storage in self.textStorage.attributeRuns) {
        NSDictionary* runAttrs = [storage attributesAtIndex:0 effectiveRange:nil];

        if (runAttrs[CardTextPromiseUUIDAttributeName] && [runAttrs[CardTextPromiseUUIDAttributeName] isEqualToString:promise.UUIDString]) {
            storage.attributedString = promisedString;
            break; // only fulfill the first promise
        }
    }
}

- (void) fulfillPromise:(NSUUID*) promise withFormatted:(id) object {
    NSAS* formatted = [self formatted:object withAttributes:[self.textStorage valueAttributesForSize:self.fontSize style:self.topStyle]];
    [self fulfillPromise:promise withString:formatted];
}

#if IL_APP_KIT
// MARK: - NSMenuValidation

- (BOOL) validateMenuItem:(NSMenuItem*)menuItem {
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

// MARK: - NSResponder

- (void) cut:(id) sender {
    if (self.selectedRange.location > 0) {
        [super copy:sender]; // don't modify the contents here
    }
    else if ([self.delegate respondsToSelector:@selector(card:cut:)]) {
        [(id<CardTextViewDelegate>)self.delegate card:self cut:sender];
    }
}

- (void) copy:(id) sender {
    if (self.selectedRange.length > 0) {
        [super copy:sender]; // do the superclass thing with the contents
    }
    else if ([self.delegate respondsToSelector:@selector(card:copy:)]) {
        [(id<CardTextViewDelegate>)self.delegate card:self copy:sender];
    }
}

- (void) paste:(id) sender {
    if ([self.delegate respondsToSelector:@selector(card:paste:)]) {
        [(id<CardTextViewDelegate>)self.delegate card:self paste:sender];
    }
}

- (void) pasteSearch:(id) sender {
    if ([self.delegate respondsToSelector:@selector(card:pasteSearch:)]) {
        [(id<CardTextViewDelegate>)self.delegate card:self pasteSearch:sender];
    }
}

- (void) pasteRuler:(id) sender {
    if ([self.delegate respondsToSelector:@selector(card:pasteRuler:)]) {
        [(id<CardTextViewDelegate>)self.delegate card:self pasteRuler:sender];
    }
}

- (void) pasteFont:(id) sender {
    if ([self.delegate respondsToSelector:@selector(card:pasteFont:)]) {
        [(id<CardTextViewDelegate>)self.delegate card:self pasteFont:sender];
    }
}

- (void) delete:(id) sender {
    if ([self.delegate respondsToSelector:@selector(card:delete:)]) {
        [(id<CardTextViewDelegate>)self.delegate card:self delete:sender];
    }
}

@end
