#import "include/CardTextView.h"

#if IL_APP_KIT
#import "include/CardRuleCell.h"
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

+ (NSAttributedString*) formatted:(id) object withAttributes:(NSDictionary*) attributes {
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
    [self.textStorage setAttributedString:[NSAS.alloc initWithString:@""]];
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

- (NSAttributedString*) appendStyled:(CardTextStyle) style string:(NSString*)string {
    return [self.textStorage append:string textStyle:style size:self.fontSize style:self.topStyle];
}

- (NSAttributedString*) appendHeader:(NSString*)string {
    return [self appendStyled:CardHeaderStyle string:string];
}

- (NSAttributedString*) appendSubhead:(NSString*)string {
    return [self appendStyled:CardSubheaderStyle string:string];
}

- (NSAttributedString*) appendCentered:(NSString*) string {
    return [self appendStyled:CardCenteredStyle string:string];
}

- (NSAttributedString*) appendLabel:(NSString*) string {
    return [self appendStyled:CardLabelStyle string:string];
}

- (NSAttributedString*) appendGray:(NSString*) string {
    return [self appendStyled:CardGrayStyle string:string];
}

- (NSAttributedString*) append:(NSString*) string {
    return [self appendStyled:CardPlainStyle string:string];
}

- (NSAttributedString*) appendMonospace:(NSString*)string {
    return [self appendStyled:CardMonospaceStyle string:string];
}

- (NSAttributedString*) appendLink:(NSString*) url text:(NSString*) label {
    return [self.textStorage appendLink:url text:label size:self.fontSize style:self.topStyle];
}

// MARK: - Rules

- (NSAttributedString*) appendRule {
    return [self.textStorage appendRule:self.topStyle];
}

- (NSAttributedString*) appendRuleWithAccentColor {
    return [self.textStorage appendRuleWithAccentColor:self.topStyle];
}

- (NSAttributedString*) appendRuleWithColor:(ILColor*) color width:(CGFloat) width {
    return [self.textStorage appendRuleWithColor:color width:width style:self.topStyle];
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

// MARK: - Formatted Objects

- (NSAttributedString*) appendFormatted:(id) object {
    NSDictionary* contentAttrs = [self.textStorage.class textStyle:CardPlainStyle fontSize:self.fontSize graphStyle:self.topStyle];
    return [self appendFormatted:object withAttributes:contentAttrs];
}

- (NSAttributedString*) appendFormatted:(id) object withAttributes:(NSDictionary*) attributes {
    NSAttributedString* formatted = [self.class formatted:object withAttributes:attributes];
    [self.textStorage appendAttributedString:formatted];
    return formatted;
}


- (NSAttributedString*) append:(id) object withFormatter:(NSFormatter*) formatter {
    NSDictionary* valueAttrs = [self.textStorage.class textStyle:CardPlainStyle fontSize:self.fontSize graphStyle:self.topStyle];
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
    // iterate through the text storage and find the first promise with this uuid
    BOOL first = YES;
    
    for (NSString* rangeString in [self.textStorage rangesForAttribute:CardTextPromiseUUIDAttributeName value:promise.UUIDString].reverseObjectEnumerator) {
        NSRange range = NSRangeFromString(rangeString);
        if (first) {
            // now tag the promisedString with the promise so it can be replaced with the next fulfillment
            NSMutableAttributedString* mutablePromise = promisedString.mutableCopy;
            [mutablePromise addAttributes:@{CardTextPromiseUUIDAttributeName: promise.UUIDString}
                                    range:NSMakeRange(0, mutablePromise.length)];
            [self.textStorage replaceCharactersInRange:range withAttributedString:mutablePromise];
            first = NO;
        }
        else {
            // scrub any existing ranges for this promise to handle cases where
            // the promisedString has multiple attribute runs for styling
            // remove ranges in reverse to prevent out of range errors
            [self.textStorage replaceCharactersInRange:range withString:@""];
        }
    }
}

- (void) fulfillPromise:(NSUUID*) promise withFormatted:(id) object {
    NSDictionary* attrs = [self.textStorage.class textStyle:CardPlainStyle fontSize:self.fontSize graphStyle:self.topStyle];
    [self fulfillPromise:promise withString:[self.class formatted:object withAttributes:attrs]];
}

// MARK: - NSResponder

- (BOOL) acceptsFirstResponder {
    return YES;
}

@end
