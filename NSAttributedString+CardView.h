#import <Cocoa/Cocoa.h>

#define NSAS NSAttributedString

@interface NSAttributedString (CardView)

+ (NSAttributedString*) attributedString:(NSString*) string;
+ (NSAttributedString*) attributedString:(NSString*) string withFont:(NSFont*) font;
+ (NSAttributedString*) attributedString:(NSString*) string withLink:(NSURL*) url;
+ (NSAttributedString*) attributedString:(NSString*) string withAttributes:(NSDictionary*) attrs;
+ (NSAttributedString*) attributedStringWithAttachmentCell:(id<NSTextAttachmentCell>) attach;

@end

#define NSMAS NSMutableAttributedString

@interface NSMutableAttributedString (CardView)

+ (NSMutableAttributedString*) mutableAttributedString:(NSString*) stirng;

@end

/* Copyright (c) 2014-2016, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license in README.md. */
