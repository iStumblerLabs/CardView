#import "NSAttributedString+CardView.h"


@implementation NSAttributedString (CardView)

+ (NSAttributedString*) attributedString:(NSString*) string
{
    return [[NSAttributedString alloc] initWithString:string];
}

+ (NSAttributedString*) attributedString:(NSString*) string withFont:(NSFont*) font
{
    NSDictionary* attrs = @{NSFontAttributeName: font};
    return [[NSAttributedString alloc] initWithString:string
                                            attributes:attrs];
}

+ (NSAttributedString*) attributedString:(NSString*)string withLink:(NSURL*) url
{
    NSDictionary* attrs = @{NSFontAttributeName: [NSFont systemFontOfSize:10.0],
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
        NSForegroundColorAttributeName: [NSColor blueColor], // TODO get link color from safari
        NSLinkAttributeName: [url absoluteString]};
    return [[NSAttributedString alloc] initWithString:string
                                            attributes:attrs];
}

+ (NSAttributedString*) attributedString:(NSString*) string 
                          withAttributes:(NSDictionary*) attrs
{
    return [[NSAttributedString alloc] initWithString:string attributes:attrs];
}

+ (NSAttributedString*) attributedStringWithAttachmentCell:(id<NSTextAttachmentCell>) attach
{
    NSTextAttachment* attachment = [NSTextAttachment new];
    [attachment setAttachmentCell:attach];
    return [NSAttributedString attributedStringWithAttachment:attachment];
}

@end

@implementation NSMutableAttributedString (CardView)

+ (NSMutableAttributedString*) mutableAttributedString:(NSString*) string
{
    return [[NSMutableAttributedString alloc] initWithString:string];
}

@end

/* Copyright (c) 2014-2016, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license in README.md. */
