#import "NSAttributedString+CardView.h"


@implementation NSAttributedString (CardView)

+ (NSAttributedString*) attributedString:(NSString*) string
{
    return [[NSAttributedString alloc] initWithString:string];
}

+ (NSAttributedString*) attributedString:(NSString*) string withFont:(NSFont*) font
{
    NSDictionary* attrs = @{
        NSFontAttributeName: font,
        NSForegroundColorAttributeName: [ILColor textColor]
    };
    return [[NSAttributedString alloc] initWithString:string
                                            attributes:attrs];
}

+ (NSAttributedString*) attributedString:(NSString*)string withLink:(NSURL*) url
{
    NSDictionary* attrs = @{
        NSFontAttributeName: [ILFont systemFontOfSize:10.0],
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
        NSForegroundColorAttributeName: [ILColor textColor],
        NSLinkAttributeName: [url absoluteString]};
    return [[NSAttributedString alloc] initWithString:string
                                            attributes:attrs];
}

+ (NSAttributedString*) attributedString:(NSString*) string 
                          withAttributes:(NSDictionary*) attrs
{
    return [[NSAttributedString alloc] initWithString:string attributes:attrs];
}

#ifdef IL_APP_KIT
+ (NSAttributedString*) attributedStringWithAttachmentCell:(id<NSTextAttachmentCell>) attach
{
    NSTextAttachment* attachment = [NSTextAttachment new];
    [attachment setAttachmentCell:attach];
    return [NSAttributedString attributedStringWithAttachment:attachment];
}
#endif

@end

@implementation NSMutableAttributedString (CardView)

+ (NSMutableAttributedString*) mutableAttributedString:(NSString*) string
{
    return [[NSMutableAttributedString alloc] initWithString:string];
}

@end

/** Copyright © 2014-2017, Alf Watt (alf@istumbler.net). All rights reserved.
    Redistribution and use permitted under MIT License in README.md. **/
