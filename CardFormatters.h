#import <KitBridge/KitBridge.h>

@interface CardFormatters : NSFormatter

/// String attributes for units, based on the attributes provided
+ (NSDictionary*) unitsAttrs:(NSDictionary*) attrs;

/// String attributes for cardinal units, based on the attributes provided
+ (NSDictionary*) cardinalAttrs:(NSDictionary*) attrs;

/// String attributes for monospaced text, based on the attributes provided
+ (NSDictionary*) monospaceAttrs:(NSDictionary*) attrs;

@end

// MARK: -

/// Format Array values into comma seperated lists
@interface CardArrayFormatter : CardFormatters
@end

// MARK: -

/// CardDataFormatter formats data values into string with byte count: "420 Bytes"
@interface CardDataFormatter : CardFormatters

@end

// MARK: -

/// CardListFormatter formats arrays with commas between the elements
@interface CardListFormatter : CardArrayFormatter
@end

// MARK: -

@interface CardURLFormatter : CardFormatters

/// URL Link color
@property(nonatomic, retain) ILColor* linkColor;

/// Create a CardURLFormatter with the specified color
+ (instancetype) formatterWithLinkColor:(ILColor*) color;

@end

// MARK: -

/// PListFormatter formatts plists into various forms
@interface PListFormatter : CardFormatters
@end

// MARK: -

/// PListJSONFormatter formatts plists into various forms
@interface PListJSONFormatter : CardFormatters
@end

// MARK: -

/// PListMarkdownFormatter formatts plists into various forms
@interface PListMarkdownFormatter : CardFormatters
@end

// MARK: - Date Formatters

/// CardDateFormatter formats dates into the users preferred medium date and long time format
@interface CardDateFormatter : NSDateFormatter

+ (instancetype) localDateFormatter;

@end

// MARK: - Units Formatter

/// CardUnitsFormatter formats number vales with units in grey text
@interface CardUnitsFormatter : NSNumberFormatter

/// unit name string to add using the unit style after the number
@property(nonatomic, retain) NSString* units;

/// prefix unit name to add before the number using the unit style
@property(nonatomic, retain) NSString* prefix;

@end

// MARK: - Number Formatters

/// CardBooleanFormatter formats numeric values into boolean value strings: "Yes" or "No"
@interface CardBooleanFormatter : NSNumberFormatter
@end

// MARK: -

/// CardBytesFormatter formats byte sizes
@interface CardBytesFormatter : CardUnitsFormatter
@end

// MARK: -

/// Format a NSNumber as a fractional value using the continued fraction method
/// https://en.wikipedia.org/wiki/Continued_fraction
@interface CardFractionFormatter: CardUnitsFormatter
@end

// MARK: -

@interface CardTimecodeFormatter : NSNumberFormatter
/// display seconds as decimal value if true, frames of frameInterval if false
@property(nonatomic,assign) BOOL decimalSeconds;
/// display unit seperators 00h 00m 00s 00f if true, colon seperators 00:00:00:00
@property(nonatomic,assign) BOOL unitSeperators;
/// interval for frame calculations, defaults to (1 / 24)
@property(nonatomic,assign) double frameInterval;
@end

