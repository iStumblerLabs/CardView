#import "CardTextFormatters.h"

static CGFloat unit_scale = 0.9;

@implementation CardTextFormatter
              
+ (NSDictionary*) unitsAttrs:(NSDictionary*) attrs {
    NSMutableDictionary* unitsAttrs = [attrs mutableCopy];
    ILFont* fullSize = attrs[NSFontAttributeName];
    ILFont* halfSize = [ILFont fontWithName:[fullSize fontName] size:([fullSize pointSize] * unit_scale)];
    unitsAttrs[NSForegroundColorAttributeName] = [ILColor grayColor];
    unitsAttrs[NSFontAttributeName] = halfSize;
    return unitsAttrs;
}

+ (NSDictionary*) cardinalAttrs:(NSDictionary*) attrs {
    NSMutableDictionary* cardinalAttrs = [attrs mutableCopy];
    cardinalAttrs[NSForegroundColorAttributeName] = [ILColor grayColor];
    return cardinalAttrs;
}

+ (NSDictionary*) monospaceAttrs:(NSDictionary*) attrs {
    NSMutableDictionary* monoAttrs = [attrs mutableCopy];
    ILFont* attrsFont = attrs[NSFontAttributeName];
    ILFont* monoFont = [ILFont userFixedPitchFontOfSize:[attrsFont pointSize]];
    monoAttrs[NSFontAttributeName] = monoFont;
    return monoAttrs;
}

// MARK: -

- (NSAttributedString*) attributedStringForObjectValue:(id)object withDefaultAttributes:(NSDictionary*) defaultAttrs {
    NSString* formattedString = [self stringForObjectValue:object];
    return [NSAttributedString.alloc initWithString:formattedString attributes:defaultAttrs];
}

@end

// MARK: - Boolean Formatter

@implementation CardBooleanFormatter

- (NSString*) stringForObjectValue:(id)obj {
    NSString* string = @"-";
    if ([obj isKindOfClass:NSNumber.class]) {
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

// MARK: - Data Formatter

@implementation CardDataFormatter

- (NSString*) stringForObjectValue:(id)obj {
    NSString* sizeString = [obj description];
    if ([obj isKindOfClass:NSData.class]) {
        sizeString = [NSString stringWithFormat:@"%lu Bytes", (unsigned long)[obj length]];
    }

    return sizeString;
}

@end

// MARK: -

@implementation CardArrayFormatter

- (NSString*) stringForObjectValue:(id)obj {
    NSString* arrayString = [obj description];
    if ([obj isKindOfClass:NSArray.class]) {
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

// MARK: - URL Formatter

@implementation CardURLFormatter

+ (CardURLFormatter*) formatterWithLinkColor:(ILColor*) color {
    CardURLFormatter* urlFormatter = CardURLFormatter.new;
    urlFormatter.linkColor = color;
    return urlFormatter;
}

// MARK: -

- (NSString*) stringForObjectValue:(id)obj {
    NSString* stringValue = [obj description];
    if ([obj isKindOfClass:NSURL.class]) {
        stringValue = [(NSURL*)obj absoluteString];
    }
    return stringValue;
}

- (NSAttributedString*) attributedStringForObjectValue:(id)obj withDefaultAttributes:(NSDictionary<NSString *,id> *)attrs {
    NSAttributedString* urlString = nil;
    if ([obj isKindOfClass:NSURL.class]) {
        NSMutableDictionary* linkAttrs = [attrs mutableCopy];
        linkAttrs[NSLinkAttributeName] = (NSURL*)obj;
        linkAttrs[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
        if (self.linkColor) {
            [linkAttrs setObject:self.linkColor forKey:NSForegroundColorAttributeName];
        }

        urlString = [NSAttributedString.alloc initWithString:[self stringForObjectValue:obj] attributes:linkAttrs];
    }
    return urlString;
}

@end

// MARK: - Date Formatter

@implementation CardDateFormatter

/*! @discussion singleton NSDateFormatter for the users's current locale */
+ (CardDateFormatter*) cardDateFormat {
    static CardDateFormatter* cardFormat = nil;
    if (!cardFormat) {
        cardFormat = CardDateFormatter.new;
        cardFormat.locale = NSLocale.autoupdatingCurrentLocale;
        cardFormat.doesRelativeDateFormatting = YES;
        cardFormat.dateStyle = NSDateFormatterMediumStyle;
        cardFormat.timeStyle = NSDateFormatterMediumStyle;
    }
    return cardFormat;
}

// MARK: -

- (NSAttributedString*) attributedStringForObjectValue:(id)object withDefaultAttributes:(NSDictionary*) defaultAttrs {
    NSString* formattedString = [self stringForObjectValue:object];
    return [NSAttributedString.alloc initWithString:formattedString attributes:defaultAttrs];
}

@end

// MARK: - Units Formatter

@implementation CardUnitsFormatter

+ (CardUnitsFormatter*) formatterForUnits:(NSString*) units withMultiplier:(CGFloat) multiplier {
    CardUnitsFormatter* unitsFormat = CardUnitsFormatter.new;
    unitsFormat.units = units;
    unitsFormat.multiplier = @(multiplier);
    unitsFormat.groupingSeparator = NSLocalizedStringFromTableInBundle(@",", nil, [NSBundle bundleForClass:self.class], @"Grouping Separator");
    unitsFormat.usesGroupingSeparator = YES;

    return unitsFormat;
}

- (instancetype) init {
    if (self = [super init]) {
        self.formatterBehavior = NSNumberFormatterBehavior10_4;
        self.numberStyle = NSNumberFormatterDecimalStyle;
        self.minimumIntegerDigits = 1;
        self.maximumIntegerDigits = 99;
        self.minimumFractionDigits = 0;
        self.maximumFractionDigits = 9;
    }
    return self;
}

- (NSAttributedString*) attributedStringForObjectValue:(id) anObject withDefaultAttributes:(NSDictionary*) attrs {
    NSMutableAttributedString* formatted = nil;
    if ([anObject isKindOfClass:NSNumber.class]) {
        formatted = [NSMutableAttributedString new];
        NSString* valueString = [self stringForObjectValue:anObject];
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

// MARK: -

@implementation CardBytesFormatter

+ (CardBytesFormatter*) cardBytesFormatter {
    return CardBytesFormatter.new;
}

// https://en.wikipedia.org/wiki/Kibibyte

/* TODO MiB * MB modes
static unsigned long long const KiB = 1024; // 2^10
static unsigned long long const MiB = KiB * KiB; // 2^20
static unsigned long long const GiB = MiB * KiB; // 2^30
static unsigned long long const Tib = GiB * KiB; // 2^40
static unsigned long long const PiB = TiB * KiB; // 2^50
static unsigned long long const EiB = PiB * KiB; // 2^60
static unsigned long long const ZiB = EiB * KiB; // 2^70
static unsigned long long const YiB = UiB * KiB; // 2^80
*/

static unsigned long long const KB = 1000;
static unsigned long long const MB = (KB * KB);
static unsigned long long const GB = (MB * KB);
static unsigned long long const TB = (GB * KB);
static unsigned long long const PB = (TB * KB);
static unsigned long long const EB = (PB * KB);
// static unsigned long long const ZB = (EB * KB);
// static unsigned long long const YB = (ZB * KB);

- (NSAttributedString*) attributedStringForObjectValue:(id) anObject withDefaultAttributes:(NSDictionary*) attrs {
    unsigned long long fileSize = [anObject unsignedLongLongValue]; // NSUInteger is 32 bits on smaller systems
    CGFloat scaledSize = (CGFloat)fileSize;

    if (fileSize < KB) { // display Bytes
        self.units = NSLocalizedStringFromTableInBundle(@"Bytes", nil, [NSBundle bundleForClass:self.class], nil);
    }
    else if (fileSize < MB) { // display kB
        scaledSize = fileSize / (CGFloat)KB;
        self.minimumFractionDigits = 1;
        self.maximumFractionDigits = 2;
        self.units = NSLocalizedStringFromTableInBundle(@"kB", nil, [NSBundle bundleForClass:self.class], nil); // opinions differ
    }
    else if ( fileSize < GB) { // display MB
        scaledSize = fileSize / (CGFloat)MB;
        self.minimumFractionDigits = 1;
        self.maximumFractionDigits = 2;
        self.units = NSLocalizedStringFromTableInBundle(@"MB", nil, [NSBundle bundleForClass:self.class], nil);
    }
    else if ( fileSize < TB) { // display GB
        scaledSize = fileSize / (CGFloat)GB;
        self.minimumFractionDigits = 1;
        self.maximumFractionDigits = 2;
        self.units = NSLocalizedStringFromTableInBundle(@"GB", nil, [NSBundle bundleForClass:self.class], nil);
    }
    else if ( fileSize < PB) { // display TB
        scaledSize = fileSize / (CGFloat)TB;
        self.minimumFractionDigits = 1;
        self.maximumFractionDigits = 2;
        self.units = NSLocalizedStringFromTableInBundle(@"TB", nil, [NSBundle bundleForClass:self.class], nil);
    }
    else if ( fileSize < EB) { // display PB
        scaledSize = fileSize / (CGFloat)PB;
        self.minimumFractionDigits = 1;
        self.maximumFractionDigits = 2;
        self.units = NSLocalizedStringFromTableInBundle(@"PB", nil, [NSBundle bundleForClass:self.class], nil);
    }
    else { // display EB
        scaledSize = fileSize / (CGFloat)EB;
        self.minimumFractionDigits = 1;
        self.maximumFractionDigits = 2;
        self.units = NSLocalizedStringFromTableInBundle(@"EB", nil, [NSBundle bundleForClass:self.class], nil);
    }

    return [super attributedStringForObjectValue:@(scaledSize) withDefaultAttributes:attrs];
}

@end

// MARK: -

/*! CardListFormatter formats arrays with commas between the elements */
@implementation CardListFormatter

+ (CardListFormatter*) cardListFormatter {
    return CardListFormatter.new;
}

- (NSString*) stringForObjectValue:(id)obj {
    NSString* listString = [obj description];
    if ([obj isKindOfClass:NSArray.class]) {
        NSArray* attributeArray = (NSArray*)obj;
        listString = [attributeArray componentsJoinedByString:@", "];
    }

    return listString;
}

@end

// MARK: -

/*! PListFormatter formatts plists into various forms */
@implementation PListFormatter : CardTextFormatter

+ (PListFormatter*) pListFormatter {
    return PListFormatter.new;
}

- (NSString*) stringForObjectValue:(id)obj {
    NSString* plistString = [obj description];
    return plistString;
}

@end

// MARK: -

/*! PListJSONFormatter formatts plists into various forms */
@implementation PListJSONFormatter : CardTextFormatter

+ (PListJSONFormatter*) pListJSONFormatter {
    return PListJSONFormatter.new;
}

- (NSString*) stringForObjectValue:(id)obj {
    NSString* plistJSONString = nil;

    NSError *error;
    NSData *jsonData = [NSJSONSerialization
        dataWithJSONObject:obj
        options:NSJSONWritingPrettyPrinted
        error:&error];
    plistJSONString = [[NSString alloc]
        initWithData:jsonData
        encoding:NSUTF8StringEncoding];

    return plistJSONString;
}


@end

// MARK: -

/*! https://daringfireball.net/projects/markdown/syntax.text */
@implementation PListMarkdownFormatter : CardTextFormatter

+ (PListMarkdownFormatter*) pListMarkdownFormatter {
    return PListMarkdownFormatter.new;
}

#pragma mark -

- (NSString*) stringForObjectValue:(id)obj indent:(const unsigned) level {
    NSMutableString* objectMarkdown = NSMutableString.new;

    unsigned indent = level;
    while (indent-- > 0) {
        [objectMarkdown appendString:@"  "]; // two spaces
    }

    // NSLog(@"level: %u indent: **%@**", level, objectMarkdown);

    if ([obj isKindOfClass:NSString.class]) {
        [objectMarkdown appendString:obj];
    }
    else if ([obj isKindOfClass:NSNumber.class]) {
        [objectMarkdown appendString:[obj stringValue]];
    }
    else if ([obj isKindOfClass:NSArray.class]) {
        NSArray* array = (NSArray*)obj;
        unsigned index = 1;
        for (id item in array) {
            [objectMarkdown appendFormat:@"%ui. ", index++];
            [objectMarkdown appendString:[self stringForObjectValue:item indent:(level + 1)]];
        }
    }
    else if ([obj isKindOfClass:NSDictionary.class]) {
        NSDictionary* dictionary = (NSDictionary*)obj;
        for (NSString* key in [dictionary allKeys]) {
            id value = [dictionary objectForKey:key];

            [objectMarkdown appendString:@"* *"];
            [objectMarkdown appendString:key];
            [objectMarkdown appendString:@"* : "];
            if ([value isKindOfClass:NSString.class]) {
                [objectMarkdown appendString:value];
                [objectMarkdown appendString:@"\n"];
            }
            else if ([value isKindOfClass:NSNumber.class]) {
                [objectMarkdown appendString:[value stringValue]];
                [objectMarkdown appendString:@"\n"];
            }
            else { // we need to go deeper
                [objectMarkdown appendString:@"\n"];
                NSString* valueMarkdown = [self stringForObjectValue:value indent:(level + 1)];
                // NSLog(@"valueMarkdown %@", valueMarkdown);
                [objectMarkdown appendString:valueMarkdown];
            }
        }
        [objectMarkdown appendString:@"\n"];
    }
    else {
        [objectMarkdown appendString:[obj description]]; // *shrug*
    }

    // [objectMarkdown appendString:@"\n"];

    return objectMarkdown;
}

- (NSString*) stringForObjectValue:(id)obj {
    NSString* markdownString = [self stringForObjectValue:obj indent:0];
    // NSLog(@"markdownString %@", markdownString);
    return markdownString;
}

@end

