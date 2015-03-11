#import <Cocoa/Cocoa.h>

/*!
    @class
    @abstract    Implements an Address Book Card style text view
    @discussion  
*/

@interface CardTextView : NSTextView
{
	NSRect baseFrame;
}
@property(nonatomic,assign) CGFloat tabStop;
@property(nonatomic,assign) CGFloat tabGutter;

+ (NSParagraphStyle*) cardViewTabsStyleForTabStop:(CGFloat) tabLocation gutterWidth:(CGFloat) gutterWidth;
+ (NSDictionary*) cardViewTabsHeaderAttributesForSize:(CGFloat) fontSize tabStops:(NSArray*) tabStops;
+ (NSDictionary*) cardViewTabsAttributesForSize:(CGFloat) fontSize tabStop:(CGFloat) tabStop gutterWidth:(CGFloat) gutterWidth; // MEH
+ (NSDictionary*) cardViewTabsAttributesForSize:(CGFloat) fontSize tabStops:(NSArray*) tabStops;
+ (NSDictionary*) cardViewCenteredAttributesForSize:(CGFloat) fontSize;
+ (NSDictionary*) cardViewLabelAttributesForSize:(CGFloat) fontSize;
+ (NSDictionary*) cardViewNoneAttributesForSize:(CGFloat) fontSize;
+ (NSDictionary*) cardViewValueAttributesForSize:(CGFloat) fontSize;
+ (NSDictionary*) cardViewKeywordAttributesForSize:(CGFloat) fontSize;

- (NSTextAttachment*) clickedAttachment;

#pragma mark - append methods

- (NSAttributedString*) appendTabString:(NSString*) string tabStop:(CGFloat) tabStop gutterWidth:(CGFloat) gutterWidth;
- (NSAttributedString*) appendTabString:(NSString*) string tabStops:(NSArray*) tabStops; // array of NSNumbers
- (NSAttributedString*) appendTabString:(NSString*) string;
- (NSAttributedString*) appendTabHeaderString:(NSString*) string tabStops:(NSArray*) tabStops;
- (NSAttributedString*) appendTabSubheaderString:(NSString*) string tabStops:(NSArray*) tabStops;
- (NSAttributedString*) appendLabelString:(NSString*) string;
- (NSAttributedString*) appendNoneString:(NSString*) string;
- (NSAttributedString*) appendValueString:(NSString*) string;
- (NSAttributedString*) appendKeywordString:(NSString*) string;
- (NSAttributedString*) appendHorizontalRule;
- (NSAttributedString*) appendHorizontalRuleWithColor:(NSColor*) color width:(CGFloat) width;
- (NSAttributedString*) appendImage:(NSImage*) image;
- (NSAttributedString*) appendNewline;

@end

#pragma mark -

@protocol CardTextViewDelegate <NSObject>

- (void) card:(CardTextView*) card cut:(id) sender;
- (void) card:(CardTextView*) card copy:(id) sender;
- (void) card:(CardTextView*) card paste:(id) sender;
- (void) card:(CardTextView*) card pasteSearch:(id) sender;
- (void) card:(CardTextView*) card pasteRuler:(id) sender;
- (void) card:(CardTextView*) card pasteFont:(id) sender;
- (void) card:(CardTextView*) card delete:(id) sender;

@end

/* Copyright (c) 2014-2015, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license in license.txt. */
