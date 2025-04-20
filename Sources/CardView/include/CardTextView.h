#if SWIFT_PACKAGE
@import KitBridge;
#import "CardTextStyle.h"
#else
#import <KitBridge/KitBridge.h>
#import <CardView/CardTextStyle.h>
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

/// Register a
/// @param formatter to handle instances of the
/// @param clazz provided
+ (void) registerFormatter:(NSFormatter*) formatter forClass:(Class) clazz;

/// @returns the registered `NSFormatter*` for the
/// @param clazz provided
+ (NSFormatter*) registeredFormatterForClass:(Class) clazz;

/// @returns an `NSAttributedString*` with the
/// @param object formatted using the registred formatter for it's class and the default
/// @param attributes provided
+ (NSAttributedString*) formatted:(id) object withAttributes:(NSDictionary*) attributes;

// MARK: -

- (void) clearCard;

// MARK: - Attachments

- (NSTextAttachment*) clickedAttachment;

// MARK: - Column Styles

/// @returns an NSParagraphStyle with the columns provided rendered as tabs
/// @param columnWidths see: `self.columns` for a description of the columnWidths array
- (NSParagraphStyle*) paragraphStyleForColumns:(NSArray*) columnWidths;

// MARK: - Style Stack

/// push a new style on to the stack, making it the top style
- (NSUInteger) pushStyle:(NSParagraphStyle*) currentStyle;

/// pop the top style off the stack
/// @returns the style that was last pushed onto the stack, or nil if the stack is empty
- (nullable NSParagraphStyle*) popStyle;

// MARK: - CardTextStyle

/// @returns attributed string with the style provided
- (NSAttributedString*) appendStyled:(CardTextStyle) style string:(NSString*)string;

/// Convenience method for appending a string with a style

- (NSAttributedString*) append:(NSString*) string;
- (NSAttributedString*) appendHeader:(NSString*) string;
- (NSAttributedString*) appendSubhead:(NSString*) string;
- (NSAttributedString*) appendCentered:(NSString*) string;
- (NSAttributedString*) appendLabel:(NSString*) string;
- (NSAttributedString*) appendGray:(NSString*) string;
- (NSAttributedString*) appendMonospace:(NSString*) string;
- (NSAttributedString*) appendLink:(NSString*) url text:(NSString*) label;

// MARK: - Rules

- (NSAttributedString*) appendRule;
- (NSAttributedString*) appendRuleWithAccentColor;
- (NSAttributedString*) appendRuleWithColor:(ILColor*) color width:(CGFloat) width;

// MARK: - Spacing

- (NSAttributedString*) appendNewline;
- (NSAttributedString*) appendTab;

// MARK: - Images

- (NSAttributedString*) appendImage:(ILImage*) image;
- (NSAttributedString*) appendImage:(ILImage*) image withAttributes:(NSDictionary*) attributes;

// MARK: - Formatted Objects

- (NSAttributedString*) appendFormatted:(id) object;
- (NSAttributedString*) append:(id) object withFormatter:(NSFormatter*) formatter;
- (NSAttributedString*) append:(id) object withFormatter:(NSFormatter*) formatter andAttributes:(NSDictionary*) attributes;

// MARK: - Promises

/// promise to append an attributed string later, an elipsis `…` with the
/// @param attributes provided will be appended to the card in it's place
/// @returns an `NSUUID` which represents the promise
- (NSUUID*) appendPromiseWithAttributes:(NSDictionary*) attributes;

/// fulfill a promise with the
/// @param string provided
///
/// can be used multiple time to set a "loading" or "progress" messages  this also allows building
/// styled NSMutableStrings in the background and appending them to the card when they are
/// ready. the string can be formatted using the `CardTextStyle` to match the style of the card
///
- (void) fulfillPromise:(NSUUID*) promise withString:(NSAttributedString*) string;

/// fulfill a
/// @param promise with the
/// @param object provided to be formatted
- (void) fulfillPromise:(NSUUID*) promise withFormatted:(id) object;

@end

NS_ASSUME_NONNULL_END
