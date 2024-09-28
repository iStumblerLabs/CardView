#if SWIFT_PACKAGE
#import "KitBridge.h"
#else
#import <KitBridge/KitBridge.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface CardFormatters : NSFormatter

/// String attributes for units, based on the attributes provided
+ (NSDictionary*) unitsAttrs:(NSDictionary*) attrs;

/// String attributes for cardinal units, based on the attributes provided
+ (NSDictionary*) cardinalAttrs:(NSDictionary*) attrs;

/// String attributes for monospaced text, based on the attributes provided
+ (NSDictionary*) monospaceAttrs:(NSDictionary*) attrs;

@end

// MARK: -

/// Format Array values into comma separated lists
@interface CardArrayFormatter : CardFormatters

/// formatter to use for each item in the array
@property(nonatomic,retain,nullable) NSFormatter* itemFormatter;

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

/// PListFormatter formats plists into various forms
@interface PListFormatter : CardFormatters
@end

// MARK: -

/// PListJSONFormatter formats plists into various forms
@interface PListJSONFormatter : CardFormatters
@end

// MARK: -

/// PListMarkdownFormatter formats plists into various forms
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
/// display unit separators 00h 00m 00s 00f if true, colon separators 00:00:00:00
@property(nonatomic,assign) BOOL unitSeparators;
/// interval for frame calculations, defaults to (1 / 24)
@property(nonatomic,assign) double frameInterval;

@end

// MARK: -

/// NSValueTransformer which uses an NSFormatter to format the value.
/// This allows for using NSFormatters in Interface Builder and registering
/// them as NSValueTransformers
@interface CardFormattingTransformer : NSValueTransformer
@property(nonatomic,retain) NSFormatter* formatter;

/// wrap the formatter in a transformer and register it with the name provided
+ (void)setFormattingTransformer:(NSFormatter*) formatter forName:(NSString*) name;

@end

NS_ASSUME_NONNULL_END

