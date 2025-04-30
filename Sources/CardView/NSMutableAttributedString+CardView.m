#import "include/NSMutableAttributedString+CardView.h"

#if IL_APP_KIT
#import "CardImageCell.h"
#import "CardRuleCell.h"
#endif

@implementation NSMutableAttributedString (CardView)

+ (NSDictionary*) textStyle:(CardTextStyle) textStyle fontSize:(CGFloat) fontSize graphStyle:(NSParagraphStyle*) graphStyle {
    NSMutableDictionary* style = NSMutableDictionary.new;

    // this is CardPlainStyle
    style[NSFontAttributeName] = [ILFont systemFontOfSize:fontSize];
    style[NSParagraphStyleAttributeName] = graphStyle;
    style[NSForegroundColorAttributeName] = ILColor.textColor;

    switch (textStyle) {
        case CardPlainStyle: {
            break;
        }
        case CardHeaderStyle: {
            style[NSFontAttributeName] = [ILFont boldSystemFontOfSize:(fontSize * 1.25)];
            break;
        }
        case CardSubheaderStyle: {
            style[NSFontAttributeName] = [ILFont boldSystemFontOfSize:(fontSize * 1.125)];
            break;
        }
        case CardCenteredStyle: {
            NSMutableParagraphStyle* centered = graphStyle.mutableCopy;
            centered.alignment = NSTextAlignmentCenter;
            centered.tabStops = @[]; // clear tabs
            style[NSParagraphStyleAttributeName] = centered;
            break;
        }
        case CardLabelStyle: {
            style[NSFontAttributeName] = [ILFont boldSystemFontOfSize:fontSize];
            break;
        }
        case CardGrayStyle: {
            style[NSForegroundColorAttributeName] = ILColor.grayColor;
            break;
        }
        case CardMonospaceStyle: {
            style[NSFontAttributeName] = [ILFont userFixedPitchFontOfSize:fontSize];
            break;
        }
        default:
            break;
    }

    return style;
}

// MARK: - Resizable Styles

- (nonnull NSAttributedString *)append:(nonnull NSString *)string size:(CGFloat)fontSize style:(nonnull NSParagraphStyle *)style {
    NSAttributedString* attrString = nil;
    if (string) {
        NSDictionary* attrs = [NSTextStorage textStyle:CardPlainStyle fontSize:fontSize graphStyle:style];
        attrString = [NSAttributedString.alloc initWithString:string attributes:attrs];
        [self appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) append:(NSString*) string textStyle:(CardTextStyle) textStyle size:(CGFloat) fontSize style:(NSParagraphStyle*) graphStyle {
    NSAttributedString* attrString = nil;

    if (string) {
        NSDictionary* attrs = [NSTextStorage textStyle:textStyle fontSize:fontSize graphStyle:graphStyle];
        attrString = [NSAttributedString.alloc initWithString:string attributes:attrs];
        [self appendAttributedString:attrString];
    }

    return attrString;
}

- (NSAttributedString*) appendHeader:(NSString*)string size:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    return [self append:string textStyle:CardHeaderStyle size:fontSize style:style];
}

- (NSAttributedString*) appendSubhead:(NSString*)string size:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    return [self append:string textStyle:CardSubheaderStyle size:fontSize style:style];
}

- (NSAttributedString*) appendCentered:(NSString*) string size:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    return [self append:string textStyle:CardCenteredStyle size:fontSize style:style];
}

- (NSAttributedString*) appendLabel:(NSString*) string size:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    return [self append:string textStyle:CardLabelStyle size:fontSize style:style];
}

- (NSAttributedString*) appendGray:(NSString*) string size:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    return [self append:string textStyle:CardGrayStyle size:fontSize style:style];
}

- (NSAttributedString*) appendMonospace:(NSString*)string size:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    return [self append:string textStyle:CardMonospaceStyle size:fontSize style:style];
}

- (NSAttributedString*) appendLink:(NSString*) url text:(NSString*) label size:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    NSAttributedString* attrString = nil;
    if (url) {
        NSMutableDictionary* attrs = [self.class textStyle:CardPlainStyle fontSize:fontSize graphStyle:style].mutableCopy;
        attrs[NSLinkAttributeName] = url;
        attrString = [NSAttributedString.alloc initWithString:(label ?: url) attributes:attrs];
        [self appendAttributedString:attrString];
    }
    return attrString;
}

// MARK: - Rules

- (NSAttributedString*) appendRule:(NSParagraphStyle*) style {
    NSAttributedString* rule = [self appendRuleWithColor:ILColor.disabledControlTextColor width:1 style:style];
    return rule;
}

- (NSAttributedString*) appendRuleWithAccentColor:(NSParagraphStyle*) style {
    ILColor* color = ILColor.disabledControlTextColor;
#if IL_APP_KIT && MAC_OS_X_VERSION_10_14
    if (@available(macOS 10.14, *)) {
        color = NSColor.controlAccentColor;
    }
#endif
    NSAttributedString* rule = [self appendRuleWithColor:color width:1 style:style];
    return rule;
}

- (NSAttributedString*) appendRuleWithColor:(ILColor*) color width:(CGFloat) width style:(NSParagraphStyle*) style {
    NSAttributedString* attrString = nil;
    [self appendNewline:ILFont.defaultFontSize style:style]; // each rule is it's own paragrah
#if IL_APP_KIT
    attrString = [CardRuleCell separatorWithColor:color width:width];
    [self appendAttributedString:attrString];
#elif IL_UI_KIT
    // TODO: NSTextAttachment* attachment = [NSTextAttachment textAttachmentWithImage:nil];
    attrString = [self appendGray:@"—" size:width style:style];
#endif
    [self appendNewline:ILFont.defaultFontSize style:style]; // and clears the next line below it
    return attrString;
}

- (NSAttributedString*) appendNewline:(CGFloat) size style:(NSParagraphStyle*) style {
    NSAttributedString* newline = [self append:@"\n" size:size style:style];
    return newline;
}

- (NSAttributedString*) appendTab:(CGFloat) size style:(NSParagraphStyle*) style {
    NSAttributedString* newline = [self append:@"\t" size:size style:style];
    return newline;
}

// MARK: - Images

- (NSAttributedString*) appendImage:(ILImage*) image size:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    return [self appendImage:image withAttributes:[self.class textStyle:CardCenteredStyle fontSize:fontSize graphStyle:style]];
}

- (NSAttributedString*) appendImage:(ILImage*) image withAttributes:(NSDictionary*) attributes {
    NSAttributedString* attrString = nil;
    if (image) {
        NSTextAttachment* attachment = NSTextAttachment.new;
        attachment.image = image;
        attachment.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        attrString = [NSAttributedString attributedStringWithAttachment:attachment];

        if (attributes) {
            NSMutableDictionary* attrs = attributes.mutableCopy;
            NSMutableAttributedString* styled = attrString.mutableCopy;

            attrs[NSAttachmentAttributeName] = [attrString attribute:NSAttachmentAttributeName atIndex:0 effectiveRange:nil];
            [styled setAttributes:attrs range:NSMakeRange(0, styled.length)];
            attrString = styled;
        }

        [self appendAttributedString:attrString];
    }
    return attrString;
}

@end
