#if SWIFT_PACKAGE
#import "KitBridge.h"
#else
#import <KitBridge/KitBridge.h>
#endif

NS_ASSUME_NONNULL_BEGIN

/// Implements an Address Book Card style text view
/// subclass of ILTextView with support for columns and styled text on macOS and iOS
@interface CardTextView : ILTextView <ILViewLifecycle> // TODO: implment CardTextStyle as well as the convenience methods
@property(nonatomic, assign) CGFloat fontSize;

/// an array of numbers describing the colum layout for the card view
/// negative numbers are interpreted as right tabs
/// positive numbers are interpreted as left tabs
/// numbers between 1 & -1 are intepreted as fractional widths
/// e.g. columns `@[@(-0.33), @(5)]` would render a right tab 1/3 of the way
/// across the view, and a left tab five points to the right of that
@property(nonatomic, retain) NSArray<NSNumber*>* columns;

/// the top style on the style stack
/// if there are non styles on the  stack, return NSParagraphStyle.defaultParagraphStyle
@property(nonatomic,readonly) NSParagraphStyle* topStyle;

// MARK: - Formatter Registry

/// Register a `NSFormatter` to handle instances of the `Class` provided
+ (void) registerFormatter:(NSFormatter*) formatter forClass:(Class) clzz;

/// @returns the registered `NSFormatter` for the `Class` provided
+ (NSFormatter*) registeredFormatterForClass:(Class) clzz;

// MARK: -

- (void) clearCard;

// MARK: - Attachments

- (NSTextAttachment*) clickedAttachment;

// MARK: - Styles

/// push a new style on to the stack, making it the top style
- (NSUInteger) pushStyle:(NSParagraphStyle*) currentStyle;

/// pop the top style off the stack
/// @returns the style that was last pushed onto the stack, or nil if the stack is empty
- (nullable NSParagraphStyle*) popStyle;

/// @returns an NSParagraphStyle with the columns provided rendered as tabs
/// @param columnWidths see: `self.columns` for a description of the columnWidths array
- (NSParagraphStyle*) paragraphStyleForColumns:(NSArray*) columnWidths;

// MARK: - Resizable Styles

- (NSAttributedString*) appendHeaderString:(NSString*) string;
- (NSAttributedString*) appendSubheaderString:(NSString*) string;
- (NSAttributedString*) appendCenteredString:(NSString*) string;
- (NSAttributedString*) appendLabelString:(NSString*) string;
- (NSAttributedString*) appendGrayString:(NSString*) string;
- (NSAttributedString*) appendValueString:(NSString*) string;
- (NSAttributedString*) appendValueFormatted:(id) object;
- (NSAttributedString*) appendKeywordString:(NSString*) string;
- (NSAttributedString*) appendMonospaceString:(NSString*) string;
- (NSAttributedString*) appendLinkTo:(NSString*) url withText:(NSString*) label;

// MARK: - Rules & Spacing

- (NSAttributedString*) appendHorizontalRule;
- (NSAttributedString*) appendHorizontalRuleWithAccentColor;
- (NSAttributedString*) appendHorizontalRuleWithColor:(ILColor*) color width:(CGFloat) width;
- (NSAttributedString*) appendNewline;
- (NSAttributedString*) appendTab;

// MARK: - Images

- (NSAttributedString*) appendImage:(ILImage*) image;
- (NSAttributedString*) appendImage:(ILImage*) image withAttributes:(NSDictionary*) attributes;

// MARK: - Content Strings

- (NSAttributedString*) appendString:(NSString*) string;

// MARK: - Formatted Objects

/// @returns a formatted `NSAttributedString` for the `object` provided as formatted by a registered `NSFormatter` with the provided `attributes`
- (NSAttributedString*) formatted:(id) object withAttributes:(NSDictionary*) attributes;

- (NSAttributedString*) appendFormatted:(id) object;
- (NSAttributedString*) append:(id) object withFormatter:(NSFormatter*) formatter;
- (NSAttributedString*) append:(id) object withFormatter:(NSFormatter*) formatter andAttributes:(NSDictionary*) attributes;

// MARK: - Promises

/// promise to append an attributed string later
/// an elipsis `…` with the `attributes` provided will be appended to the card
/// @param attributes the attributes to apply to the string
/// @returns a `NSUUID` that represents the promise
- (NSUUID*) appendPromiseWithAttributes:(NSDictionary*) attributes;

/// fulfill a promise with the `string` provided, can be used multiple time to set a "loading" or "progress" messages
/// this also allows building styled NSMutableStrings in the background and appending them to the card when they
/// are ready. the string can be formatted using the `CardTextStyle` to match the style of the card
- (void) fulfillPromise:(NSUUID*) promise withString:(NSAttributedString*) string;

/// fulfill a promise with the `object` provided with an object to be formatted
- (void) fulfillPromise:(NSUUID*) promise withFormatted:(id) object;

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

NS_ASSUME_NONNULL_END
