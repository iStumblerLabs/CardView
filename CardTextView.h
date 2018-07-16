#import <KitBridge/KitBridge.h>

/*!
    @class CartTextView
    @abstract Implements an Address Book Card style text view
    @discussion subclass of ILTextView with support for columns and styled text on macOS and iOS
*/
@interface CardTextView : ILTextView <ILViews>
@property(nonatomic, assign) CGFloat fontSize;
@property(nonatomic, retain) NSArray<NSNumber*>* columns;

#pragma mark - Formatter Registry

+ (void) registerFormatter:(NSFormatter*) formatter forClass:(Class) clzz;
+ (NSFormatter*) registeredFormatterForClass:(Class) clzz;

#pragma mark -

- (void) clearCard;

#pragma mark - Attachments

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

- (NSAttributedString*) appendFormatted:(id) object withAttributes:(NSDictionary*) attributes;

#pragma mark - Resizeable Styles

- (NSAttributedString*) appendHeaderString:(NSString*) string;
- (NSAttributedString*) appendSubheaderString:(NSString*) string;
- (NSAttributedString*) appendCenteredString:(NSString*) string;
- (NSAttributedString*) appendLabelString:(NSString*) string;
- (NSAttributedString*) appendGrayString:(NSString*) string;
- (NSAttributedString*) appendValueString:(NSString*) string;
- (NSAttributedString*) appendKeywordString:(NSString*) string;
- (NSAttributedString*) appendMonospaceString:(NSString*) string;
- (NSAttributedString*) appendLinkTo:(NSString*) url withText:(NSString*) label;
- (NSAttributedString*) appendValueFormatted:(id) object;

#pragma mark - Non-Resizeable Styles

- (NSAttributedString*) appendHorizontalRule;
- (NSAttributedString*) appendHorizontalRuleWithColor:(ILColor*) color width:(CGFloat) width;
- (NSAttributedString*) appendImage:(ILImage*) image;
- (NSAttributedString*) appendImage:(ILImage*) image withAttributes:(NSDictionary*) attributes;
- (NSAttributedString*) appendContentString:(NSString*) string;
- (NSAttributedString*) appendContentFormatted:(id) object;
- (NSAttributedString*) append:(id) object withFormatter:(NSFormatter*) formatter;
- (NSAttributedString*) append:(id) object withFormatter:(NSFormatter*) formatter andAttributes:(NSDictionary*) attributes;
- (NSAttributedString*) appendNewline;
- (NSAttributedString*) appendTab;

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

/** Copyright (c) 2014-2017, Alf Watt (alf@istumbler.net). All rights reserved.
    Redistribution and use permitted under MIT License in README.md. **/
