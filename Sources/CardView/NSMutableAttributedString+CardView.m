#import <KitBridge/KitBridge.h>

#if IL_APP_KIT
#import "CardImageCell.h"
#import "CardSeparatorCell.h"
#endif

#import "NSMutableAttributedString+CardView.h"

@implementation NSMutableAttributedString (CardView)

// MARK: - Attributes

- (NSDictionary*) attributesForSize:(CGFloat)fontSize style:(NSParagraphStyle*) style {
    ILFont* tagFont = [ILFont systemFontOfSize:fontSize];
    return @{ NSParagraphStyleAttributeName: style,
              NSFontAttributeName: tagFont,
              NSForegroundColorAttributeName: ILColor.textColor };
}

- (NSDictionary*) headerAttributesForSize:(CGFloat)fontSize tabStops:(NSArray*)tabStops  style:(NSParagraphStyle*) style {
    ILFont* tag_font = [ILFont boldSystemFontOfSize:fontSize];
    return @{ NSParagraphStyleAttributeName: style,
              NSFontAttributeName: tag_font,
              NSForegroundColorAttributeName: ILColor.textColor };
}

- (NSDictionary*) centeredAttributesForSize:(CGFloat) fontSize style:(NSParagraphStyle*) baseStyle {
    ILFont* font = [ILFont systemFontOfSize:fontSize];
    NSMutableParagraphStyle* style = baseStyle.mutableCopy;
    style.alignment = NSTextAlignmentCenter;
    style.tabStops = @[]; // clear tabs
    return @{ NSParagraphStyleAttributeName: style,
              NSFontAttributeName: font,
              NSForegroundColorAttributeName: ILColor.textColor };
}

- (NSDictionary*) labelAttributesForSize:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    return @{ NSParagraphStyleAttributeName: style,
              NSFontAttributeName: [ILFont boldSystemFontOfSize:fontSize],
              NSForegroundColorAttributeName: ILColor.textColor };
}

- (NSDictionary*) grayAttributesForSize:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    return @{ NSParagraphStyleAttributeName: style,
              NSFontAttributeName: [ILFont systemFontOfSize:fontSize],
              NSForegroundColorAttributeName: ILColor.grayColor};
}

- (NSDictionary*) valueAttributesForSize:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    return @{ NSParagraphStyleAttributeName: style,
              NSFontAttributeName: [ILFont systemFontOfSize:fontSize],
              NSForegroundColorAttributeName: ILColor.textColor};
}

- (NSDictionary*) keywordAttributesForSize:(CGFloat) fontSize style: (NSParagraphStyle*) style {
    return @{ NSParagraphStyleAttributeName: style,
              NSFontAttributeName: [ILFont systemFontOfSize:fontSize],
              NSForegroundColorAttributeName: ILColor.textColor};
}

- (NSDictionary*) contentAttributesForSize:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    return @{ NSParagraphStyleAttributeName: style,
              NSFontAttributeName: [ILFont systemFontOfSize:fontSize],
              NSForegroundColorAttributeName: ILColor.textColor};
}

// MARK: - Resizable Styles

- (NSAttributedString*) appendHeaderString:(NSString*)string size:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    NSAttributedString* attrString = nil;

    if (string) {
        NSMutableDictionary* attrs = [self centeredAttributesForSize:fontSize style:style].mutableCopy;
        attrs[NSFontAttributeName] = [ILFont boldSystemFontOfSize:(fontSize * 1.2)];
        attrString = [NSAttributedString.alloc initWithString:string attributes:attrs];
        [self appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendSubheaderString:(NSString*)string size:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    NSAttributedString* attrString = nil;
    if (string) {
        NSMutableDictionary* attrs = [self attributesForSize:fontSize style:style].mutableCopy;
        attrs[NSFontAttributeName] = [ILFont boldSystemFontOfSize:[attrs[NSFontAttributeName] pointSize]];
        attrString = [NSAttributedString.alloc initWithString:string attributes:attrs];
        [self appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendCenteredString:(NSString*) string size:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    NSAttributedString* attrString = nil;
    if (string) {
        NSMutableDictionary* attrs = [self centeredAttributesForSize:fontSize style:style].mutableCopy;
        attrString = [NSAttributedString.alloc initWithString:string attributes:attrs];
        [self appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendLabelString:(NSString*) string size:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    NSAttributedString* attrString = nil;
    if (string) {
        NSDictionary* attrs = [self labelAttributesForSize:fontSize style:style];
        attrString = [NSAttributedString.alloc initWithString:string attributes:attrs];
        [self appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendGrayString:(NSString*) string size:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    NSAttributedString* attrString = nil;
    if (string) {
        NSDictionary* attrs = [self grayAttributesForSize:fontSize style:style];
        attrString = [NSAttributedString.alloc initWithString:string attributes:attrs];
        [self appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendValueString:(NSString*) string size:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    NSAttributedString* attrString = nil;
    if (string) {
        NSDictionary* attrs = [self valueAttributesForSize:fontSize style:style];
        attrString = [NSAttributedString.alloc initWithString:string attributes:attrs];
        [self appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendKeywordString:(NSString*) string size:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    NSAttributedString* attrString = nil;
    if (string) {
        NSDictionary* attrs = [self keywordAttributesForSize:fontSize style:style];
        attrString = [NSAttributedString.alloc initWithString:string attributes:attrs];
        [self appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendMonospaceString:(NSString*)string size:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    NSAttributedString* attrString = nil;
    if (string) {
        NSMutableDictionary* attrs = [self attributesForSize:fontSize style:style].mutableCopy;
        attrs[NSFontAttributeName] = [ILFont userFixedPitchFontOfSize:[attrs[NSFontAttributeName] pointSize]];
        attrString = [NSAttributedString.alloc initWithString:string attributes:attrs];
        [self appendAttributedString:attrString];
    }
    return attrString;
}

- (NSAttributedString*) appendLinkTo:(NSString*) url withText:(NSString*) label size:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    NSAttributedString* attrString = nil;
    if (url) {
        NSMutableDictionary* attrs = [self attributesForSize:fontSize style:style].mutableCopy;
        attrs[NSLinkAttributeName] = url;
        attrString = [NSAttributedString.alloc initWithString:(label ?: url) attributes:attrs];
        [self appendAttributedString:attrString];
    }
    return attrString;
}

// MARK: - Rules

- (NSAttributedString*) appendHorizontalRule:(NSParagraphStyle*) style {
    NSAttributedString* rule = [self appendHorizontalRuleWithColor:ILColor.disabledControlTextColor width:1 style:style];
    return rule;
}

- (NSAttributedString*) appendHorizontalRuleWithAccentColor:(NSParagraphStyle*) style {
    ILColor* color = ILColor.disabledControlTextColor;
#if IL_APP_KIT && MAC_OS_X_VERSION_10_14
    if (@available(macOS 10.14, *)) {
        color = NSColor.controlAccentColor;
    }
#endif
    NSAttributedString* rule = [self appendHorizontalRuleWithColor:color width:1 style:style];
    return rule;
}

- (NSAttributedString*) appendHorizontalRuleWithColor:(ILColor*) color width:(CGFloat) width style:(NSParagraphStyle*) style {
    NSAttributedString* attrString = nil;
#if IL_APP_KIT
    attrString = [CardSeparatorCell separatorWithColor:color width:width];
    [self appendNewline:ILFont.defaultFontSize style:style]; // each rule is it's own paragrah
    [self appendAttributedString:attrString];
    [self appendNewline:ILFont.defaultFontSize style:style]; // and clears the next line below it
#elif IL_UI_KIT
    // TODO: NSTextAttachment* attachment = [NSTextAttachment textAttachmentWithImage:nil];
#endif
    return attrString;
}

- (NSAttributedString*) appendNewline:(CGFloat) size style:(NSParagraphStyle*) style {
    NSAttributedString* newline = [self appendValueString:@"\n" size:size style:style];
    return newline;
}

- (NSAttributedString*) appendTab:(CGFloat) size style:(NSParagraphStyle*) style {
    NSAttributedString* newline = [self appendValueString:@"\t" size:size style:style];
    return newline;
}

// MARK: - Images

- (NSAttributedString*) appendImage:(ILImage*) image size:(CGFloat) fontSize style:(NSParagraphStyle*) style {
    return [self appendImage:image withAttributes:[self centeredAttributesForSize:fontSize style:style]];
}

- (NSAttributedString*) appendImage:(ILImage*) image withAttributes:(NSDictionary*) attributes {
    NSAttributedString* attrString = nil;
    if (image) {
#if IL_APP_KIT
        CardImageCell* attachment = [CardImageCell cellWithImage:image];
        attrString = [NSAttributedString attributedStringWithAttachmentCell:attachment];
#elif IL_UI_KIT
        NSTextAttachment* attachment = NSTextAttachment.new;
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

        [self appendAttributedString:attrString];
    }
    return attrString;
}

- (nonnull NSAttributedString *)appendString:(nonnull NSString *)string size:(CGFloat)fontSize style:(nonnull NSParagraphStyle *)style {
    return [self appendValueString:string size:fontSize style:style];
}

@end
