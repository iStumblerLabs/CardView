#import <KitBridge/KitBridge.h>

@interface CardTextFormatter : NSFormatter

/// String attributes for units, based on the attributes provided
+ (NSDictionary*) unitsAttrs:(NSDictionary*) attrs;

/// String attributes for cardinal units, based on the attributes provided
+ (NSDictionary*) cardinalAttrs:(NSDictionary*) attrs;

/// String attributes for monospaced text, based on the attributes provided
+ (NSDictionary*) monospaceAttrs:(NSDictionary*) attrs;

@end

// MARK: -

/// CardBooleanFormatter formats numeric values into boolean value strings: "Yes" or "No"
@interface CardBooleanFormatter : CardTextFormatter
@end

// MARK: -

/// CardDataFormatter formats data values into string with byte count: "420 Bytes"
@interface CardDataFormatter : CardTextFormatter
@end

// MARK: -

@interface CardArrayFormatter : CardTextFormatter
@end

// MARK: -

@interface CardURLFormatter : CardTextFormatter
@property(nonatomic, retain) ILColor* linkColor;

+ (CardURLFormatter*) formatterWithLinkColor:(ILColor*) color;

@end

// MARK: -

/// CardDateFormatter formats dates into the users preferred medium date and long time format
@interface CardDateFormatter : NSDateFormatter

+ (CardDateFormatter*) cardDateFormat;

@end

// MARK: -

/// CardUnitsFormatter formats number vales with units in grey text
@interface CardUnitsFormatter : NSNumberFormatter

/// unit name string to add using the unit style after the number
@property(nonatomic, retain) NSString* units;

/// prefix unit name to add before the number using the unit style
@property(nonatomic, retain) NSString* prefix;

@end

// MARK: -

/// CardBytesFormatter formats byte sizes
@interface CardBytesFormatter : CardUnitsFormatter

+ (CardBytesFormatter*) cardBytesFormatter;

@end

// MARK: -

/// CardListFormatter formats arrays with commas between the elements
@interface CardListFormatter : CardArrayFormatter

+ (CardListFormatter*) cardListFormatter;

@end

// MARK: -

/// PListFormatter formatts plists into various forms
@interface PListFormatter : CardTextFormatter

+ (PListFormatter*) pListFormatter;

@end

// MARK: -

/// PListJSONFormatter formatts plists into various forms
@interface PListJSONFormatter : CardTextFormatter

+ (PListJSONFormatter*) pListJSONFormatter;

@end

// MARK: -

/// PListMarkdownFormatter formatts plists into various forms
@interface PListMarkdownFormatter : CardTextFormatter

+ (PListMarkdownFormatter*) pListMarkdownFormatter;

@end

// MARK: - Number Formatters

/// Format a NSNumber as a fractional value using the continued fraction method
/// https://en.wikipedia.org/wiki/Continued_fraction
@interface CardFractionFormatter: CardUnitsFormatter

@end
