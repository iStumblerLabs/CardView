#import <Cocoa/Cocoa.h>

/*!
    @class CartTextView
    @abstract Implements an Address Book Card style text view
    @discussion  
*/
@interface CardTextView : NSTextView
@property(nonatomic, assign) CGFloat fontSize;
@property(nonatomic, retain) NSArray<NSNumber*>* columns;
@property(nonatomic, retain) NSParagraphStyle* contentStyle; // a plain style for full-width contents which won't be replaced

#pragma mark - Formatter Registry

+ (void) registerFormatter:(NSFormatter*) formatter forClass:(Class) clzz;
+ (NSFormatter*) registeredFormatterForClass:(Class) clzz;

#pragma mark -

- (NSTextAttachment*) clickedAttachment;

#pragma mark - Styles

- (NSParagraphStyle*) paragraphStyleForColumns:(NSArray*) columnWidths;

- (NSDictionary*) attributesForSize:(CGFloat) fontSize;
- (NSDictionary*) centeredAttributesForSize:(CGFloat) fontSize;
- (NSDictionary*) labelAttributesForSize:(CGFloat) fontSize;
- (NSDictionary*) grayAttributesForSize:(CGFloat) fontSize;
- (NSDictionary*) valueAttributesForSize:(CGFloat) fontSize;
- (NSDictionary*) keywordAttributesForSize:(CGFloat) fontSize;

#pragma mark - Appending

- (NSAttributedString*) appendHeaderString:(NSString*) string;
- (NSAttributedString*) appendSubheaderString:(NSString*) string;
- (NSAttributedString*) appendLabelString:(NSString*) string;
- (NSAttributedString*) appendGrayString:(NSString*) string;
- (NSAttributedString*) appendValueString:(NSString*) string;
- (NSAttributedString*) appendKeywordString:(NSString*) string;
- (NSAttributedString*) appendContentString:(NSString*) string;
- (NSAttributedString*) appendHorizontalRule;
- (NSAttributedString*) appendHorizontalRuleWithColor:(NSColor*) color width:(CGFloat) width;
- (NSAttributedString*) appendImage:(NSImage*) image;
- (NSAttributedString*) appendFormatted:(id) object;
- (NSAttributedString*) append:(id) object withFormatter:(NSFormatter*) formatter;
- (NSAttributedString*) appendNewline;

@end

#pragma mark -

/*! @protocol CardTextViewDelegate */
@protocol CardTextViewDelegate <NSObject>

- (void) card:(CardTextView*) card cut:(id) sender;
- (void) card:(CardTextView*) card copy:(id) sender;
- (void) card:(CardTextView*) card paste:(id) sender;
- (void) card:(CardTextView*) card pasteSearch:(id) sender;
- (void) card:(CardTextView*) card pasteRuler:(id) sender;
- (void) card:(CardTextView*) card pasteFont:(id) sender;
- (void) card:(CardTextView*) card delete:(id) sender;

@end

/** Copyright (c) 2014-2016, Alf Watt (alf@istumbler.net). All rights reserved.
    Redistribution and use permitted under MIT License in README.md. **/
