#import "CardTextFormatters.h"

static CGFloat unit_scale = 0.9;

@implementation CardTextFormatter
              
+ (NSDictionary*) unitsAttrs:(NSDictionary*) attrs
{
    NSMutableDictionary* unitsAttrs = [attrs mutableCopy];
    NSFont* fullSize = attrs[NSFontAttributeName];
    NSFont* halfSize = [NSFont fontWithName:[fullSize fontName] size:([fullSize pointSize] * unit_scale)];
    unitsAttrs[NSForegroundColorAttributeName] = [NSColor grayColor];
    unitsAttrs[NSFontAttributeName] = halfSize;
    return unitsAttrs;
}

+ (NSDictionary*) cardinalAttrs:(NSDictionary*) attrs
{
    NSMutableDictionary* cardinalAttrs = [attrs mutableCopy];
    cardinalAttrs[NSForegroundColorAttributeName] = [NSColor grayColor];
    return cardinalAttrs;
}

+ (NSDictionary*) monospaceAttrs:(NSDictionary*) attrs
{
    NSMutableDictionary* monoAttrs = [attrs mutableCopy];
    NSFont* attrsFont = attrs[NSFontAttributeName];
    NSFont* monoFont = [NSFont userFixedPitchFontOfSize:[attrsFont pointSize]];
    monoAttrs[NSFontAttributeName] = monoFont;
    return monoAttrs;
}

#pragma mark -

- (NSAttributedString*) attributedStringForObjectValue:(id)object withDefaultAttributes:(NSDictionary*) defaultAttrs
{
    NSString* formattedString = [self stringForObjectValue:object];
    return [[NSAttributedString alloc] initWithString:formattedString attributes:defaultAttrs];
}

@end

#pragma mark - Boolean Formatter

@implementation CardBooleanFormatter

- (NSString*) stringForObjectValue:(id)obj
{
    NSString* string = @"-";
    if ([obj isKindOfClass:[NSNumber class]]) {
        if ([(NSNumber*)obj boolValue]) {
            string = @"Yes";
        }
        else {
            string = @"No";
        }
    }

    return string;
}

@end

#pragma mark - Data Formatter

@implementation CardDataFormatter

- (NSString*) stringForObjectValue:(id)obj
{
    NSString* sizeString = [obj description];
    if ([obj isKindOfClass:[NSData class]]) {
        sizeString = [NSString stringWithFormat:@"%lu Bytes", (unsigned long)[obj length]];
    }

    return sizeString;
}

@end

#pragma mark - 

@implementation CardArrayFormatter

- (NSString*) stringForObjectValue:(id)obj
{
    NSString* arrayString = [obj description];
    if ([obj isKindOfClass:[NSArray class]]) {
        NSArray* attributeArray = (NSArray*)obj;
        BOOL first = YES;
        for( id valueItem in attributeArray) {
            if( first) {
                first = NO;
                arrayString = @"";
            }
            else {
                arrayString = [arrayString stringByAppendingString:@"\t\t"];
            }

            arrayString = [arrayString stringByAppendingString:[valueItem description]];
            if( valueItem != [attributeArray lastObject]) {
                arrayString = [arrayString stringByAppendingString:@"\n"];
            }
        }
    }

    return arrayString;
}

@end

#pragma mark - URL Formatter

@implementation CardURLFormatter

+ (CardURLFormatter*) formatterWithLinkColor:(NSColor*) color
{
    CardURLFormatter* urlFormatter = [CardURLFormatter new];
    urlFormatter.linkColor = color;
    return urlFormatter;
}

#pragma mark -

- (NSString*) stringForObjectValue:(id)obj
{
    NSString* stringValue = [obj description];
    if ([obj isKindOfClass:[NSURL class]]) {
        stringValue = [(NSURL*)obj absoluteString];
    }
    return stringValue;
}

- (NSAttributedString*) attributedStringForObjectValue:(id)obj withDefaultAttributes:(NSDictionary<NSString *,id> *)attrs
{
    NSAttributedString* urlString = nil;
    if ([obj isKindOfClass:[NSURL class]]) {
        NSMutableDictionary* linkAttrs = [attrs mutableCopy];
        linkAttrs[NSLinkAttributeName] = (NSURL*)obj;
        linkAttrs[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
        if (self.linkColor) {
            [linkAttrs setObject:self.linkColor forKey:NSForegroundColorAttributeName];
        }

        urlString = [[NSAttributedString alloc] initWithString:[self stringForObjectValue:obj] attributes:linkAttrs];
    }
    return urlString;
}

@end

#pragma mark - Date Formatter

@implementation CardDateFormatter

/*! @discussion singleton NSDateFormatter for the users's current locale */
+ (CardDateFormatter*) cardDateFormat
{
    static CardDateFormatter* cardFormat = nil;
    if (!cardFormat) {
        cardFormat = [CardDateFormatter new];
        cardFormat.locale = [NSLocale autoupdatingCurrentLocale];
        cardFormat.doesRelativeDateFormatting = YES;
        cardFormat.dateStyle = NSDateFormatterMediumStyle;
        cardFormat.timeStyle = NSDateFormatterMediumStyle;
    }
    return cardFormat;
}

#pragma mark -

- (NSAttributedString*) attributedStringForObjectValue:(id)object withDefaultAttributes:(NSDictionary*) defaultAttrs
{
    NSString* formattedString = [self stringForObjectValue:object];
    return [[NSAttributedString alloc] initWithString:formattedString attributes:defaultAttrs];
}

@end

#pragma mark - Units Formatter

@implementation CardUnitsFormatter

+ (CardUnitsFormatter*) formatterForUnits:(NSString*) units atScale:(CGFloat) scale
{
    CardUnitsFormatter* unitsFormat = [CardUnitsFormatter new];
    unitsFormat.units = units;
    unitsFormat.unitScale = scale;
    unitsFormat.groupingSeparator = NSLocalizedString(@",", @"Grouping Separator");
    unitsFormat.usesGroupingSeparator = YES;

    return unitsFormat;
}

- (NSAttributedString*) attributedStringForObjectValue:(id) anObject withDefaultAttributes:(NSDictionary*) attrs
{
    NSMutableAttributedString* formatted = nil;
    if ([anObject isKindOfClass:[NSNumber class]]) {
        formatted = [NSMutableAttributedString new];
        NSNumber* scaledValue = @([(NSNumber*)anObject doubleValue] * self.unitScale);
        NSString* valueString = [self stringForObjectValue:scaledValue];
        NSDictionary* unitsAttrs = [CardTextFormatter unitsAttrs:attrs];
        NSAttributedString* formattedValue = [[NSAttributedString alloc] initWithString:valueString attributes:attrs];
        [formatted appendAttributedString:formattedValue];
        if (self.units) {
            NSAttributedString* formattedUnits = [[NSAttributedString alloc] initWithString:self.units attributes:unitsAttrs];
            [formatted appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            [formatted appendAttributedString:formattedUnits];
        }
    }

    return formatted;
}

@end

#pragma mark -

/*! @class CardListFormatter formats arrays with commas between the elements */
@implementation CardListFormatter

+ (CardListFormatter*) cardListFormatter
{
    return [CardListFormatter new];
}

- (NSString*) stringForObjectValue:(id)obj
{
    NSString* listString = [obj description];
    if ([obj isKindOfClass:[NSArray class]]) {
        NSArray* attributeArray = (NSArray*)obj;
        listString = [attributeArray componentsJoinedByString:@", "];
    }

    return listString;
}

@end