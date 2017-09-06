#import <KitBridge/KitBridge.h>

/*!
    @class
    @abstract    Draws a seperator in an CardView
    @discussion  http://www.cocoadev.com/index.pl?AddressBookCardView
*/

@interface CardSeparatorCell : NSTextAttachmentCell
@property(nonatomic,retain) ILColor* separator_color;
@property(nonatomic,assign) CGFloat separator_width;

+ (NSAttributedString*) separator;
+ (NSAttributedString*) separatorWithColor:(ILColor*) color;
+ (NSAttributedString*) separatorWithColor:(ILColor*) color width:(CGFloat) width;

- (id) initWithColor:(ILColor*) color width:(CGFloat) width;

@end

/** Copyright (c) 2014-2017, Alf Watt (alf@istumbler.net). All rights reserved.
    Redistribution and use permitted under MIT License in README.md. **/
