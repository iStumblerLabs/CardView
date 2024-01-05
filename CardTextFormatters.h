#import <KitBridge/KitBridge.h>

@interface CardTextFormatter : NSFormatter

+ (NSDictionary*) unitsAttrs:(NSDictionary*) attrs;
+ (NSDictionary*) cardinalAttrs:(NSDictionary*) attrs;
+ (NSDictionary*) monospaceAttrs:(NSDictionary*) attrs;

@end

// MARK: -

/*! @class CardBooleanFormatter formats numeric values into boolean value strings: "Yes" or "No" */
@interface CardBooleanFormatter : CardTextFormatter
@end

// MARK: -

/*! @class CardDataFormatter formats data values into string with byte count: "420 Bytes" */
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

/*! @class CardDateFormatter formats dates into the users preferred medium date and long time format */
@interface CardDateFormatter : NSDateFormatter

+ (CardDateFormatter*) cardDateFormat;

@end

// MARK: -

/*! @class CardUnitsFormatter formats number vales with units in grey text */
@interface CardUnitsFormatter : NSNumberFormatter

/*! @discussion unit name string to add to the number */
@property(nonatomic, retain) NSString* units;

/*! @discussion creates a new formatter with the units and scaling provided
    e.g. if the source is meters, pass "Km" and 0.001 to get "1 Km" when the value is 1000 */
+ (CardUnitsFormatter*) formatterForUnits:(NSString*) units withMultiplier:(CGFloat) multiplier;

@end

// MARK: -

/*! @class CardBytesFormatter formats byte sizes */
@interface CardBytesFormatter : CardUnitsFormatter

+ (CardBytesFormatter*) cardBytesFormatter;

@end

// MARK: -

/*! @class CardListFormatter formats arrays with commas between the elements */
@interface CardListFormatter : CardArrayFormatter

+ (CardListFormatter*) cardListFormatter;

@end

// MARK: -

/*! @class PListFormatter formatts plists into various forms */
@interface PListFormatter : CardTextFormatter

+ (PListFormatter*) pListFormatter;

@end

// MARK: -

/*! @class PListJSONFormatter formatts plists into various forms */
@interface PListJSONFormatter : CardTextFormatter

+ (PListJSONFormatter*) pListJSONFormatter;

@end

// MARK: -

/*! @class PListMarkdownFormatter formatts plists into various forms */
@interface PListMarkdownFormatter : CardTextFormatter

+ (PListMarkdownFormatter*) pListMarkdownFormatter;

@end
