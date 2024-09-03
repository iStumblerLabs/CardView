#if SWIFT_PACKAGE
#import "KitBridge.h"
#else
#import <KitBridge/KitBridge.h>
#endif


/// Implements an Address Book Card style text view
/// @discussion subclass of ILTextView with support for columns and styled text on macOS and iOS
@interface CardTextView : ILTextView <ILViewLifecycle>
@property(nonatomic, assign) CGFloat fontSize;
@property(nonatomic, retain) NSArray<NSNumber*>* columns;

// MARK: - Formatter Registry

/// Register a formatter do handle instances of the class provided
+ (void) registerFormatter:(NSFormatter*) formatter forClass:(Class) clzz;

/// Get the registered formatter for the
+ (NSFormatter*) registeredFormatterForClass:(Class) clzz;

// MARK: -

- (void) clearCard;

// MARK: - Attachments

- (NSTextAttachment*) clickedAttachment;

// MARK: - Styles

- (NSParagraphStyle*) paragraphStyleForColumns:(NSArray*) columnWidths;

- (NSDictionary*) attributesForSize:(CGFloat) fontSize;
- (NSDictionary*) centeredAttributesForSize:(CGFloat) fontSize;
- (NSDictionary*) labelAttributesForSize:(CGFloat) fontSize;
- (NSDictionary*) grayAttributesForSize:(CGFloat) fontSize;
- (NSDictionary*) valueAttributesForSize:(CGFloat) fontSize;
- (NSDictionary*) keywordAttributesForSize:(CGFloat) fontSize;

// MARK: - Appending

- (NSAttributedString*) appendFormatted:(id) object withAttributes:(NSDictionary*) attributes;

// MARK: - Resizable Styles

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

// MARK: - Non-Resizable Styles

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

// MARK: -

@protocol CardTextViewDelegate <NSObject>

- (void) card:(CardTextView*) card cut:(id) sender;
- (void) card:(CardTextView*) card copy:(id) sender;
- (void) card:(CardTextView*) card paste:(id) sender;
- (void) card:(CardTextView*) card pasteSearch:(id) sender;
- (void) card:(CardTextView*) card pasteRuler:(id) sender;
- (void) card:(CardTextView*) card pasteFont:(id) sender;
- (void) card:(CardTextView*) card delete:(id) sender;

@end
