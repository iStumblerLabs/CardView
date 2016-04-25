#import <Cocoa/Cocoa.h>

/*!
    @class
    @abstract    Draws a seperator in an CardView
    @discussion  http://www.cocoadev.com/index.pl?AddressBookCardView
*/

@interface CardSeparatorCell : NSTextAttachmentCell
@property(nonatomic,retain) NSColor* separator_color;
@property(nonatomic,assign) CGFloat separator_width;

+ (NSAttributedString*) separator;
+ (NSAttributedString*) separatorWithColor:(NSColor*) color;
+ (NSAttributedString*) separatorWithColor:(NSColor*) color width:(CGFloat) width;

- (id) initWithColor:(NSColor*) color width:(CGFloat) width;

@end

/* Copyright (c) 2014-2016, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license in README.md. */
