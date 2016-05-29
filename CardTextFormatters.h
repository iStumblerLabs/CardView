#import <Foundation/Foundation.h>

@interface CardTextFormatter : NSFormatter

+ (NSDictionary*) unitsAttrs:(NSDictionary*) attrs;
+ (NSDictionary*) cardinalAttrs:(NSDictionary*) attrs;
+ (NSDictionary*) monospaceAttrs:(NSDictionary*) attrs;

@end

#pragma mark -

/*! @class CardBooleanFormatter formats numeric values into boolean value strings: "Yes" or "No" */
@interface CardBooleanFormatter : CardTextFormatter
@end

#pragma mark -

/*! @class CardDataFormatter formats data values into string with byte count: "420 Bytes" */
@interface CardDataFormatter : CardTextFormatter
@end

#pragma mark -

@interface CardArrayFormatter : CardTextFormatter
@end

#pragma mark -

@interface CardURLFormatter : CardTextFormatter
@property(nonatomic, retain) NSColor* linkColor;

+ (CardURLFormatter*) formatterWithLinkColor:(NSColor*) color;

@end

#pragma mark -

/*! @class CardDateFormatter formats dates into the users preferred medium date and long time format */
@interface CardDateFormatter : NSDateFormatter

+ (CardDateFormatter*) cardDateFormat;

@end

#pragma mark -

/*! @class CardUnitsFormatter formats number vales with units in grey text */
@interface CardUnitsFormatter : NSNumberFormatter

/*! @discussion unit name string to add to the number */
@property(nonatomic, retain) NSString* units;

/*! @discussion creates a new formatter with the units and scaling provided
    e.g. if the source is meters, pass "Km" and 0.001 to get "1 Km" when the value is 1000 */
+ (CardUnitsFormatter*) formatterForUnits:(NSString*) units withMultiplier:(CGFloat) multiplier;

@end

#pragma mark -

/*! @class CardBytesFormatter formats byte sizes */
@interface CardBytesFormatter : CardUnitsFormatter

+ (CardBytesFormatter*) cardBytesFormatter;

@end

#pragma mark -

/*! @class CardListFormatter formats arrays with commas between the elements */
@interface CardListFormatter : CardArrayFormatter

+ (CardListFormatter*) cardListFormatter;

@end