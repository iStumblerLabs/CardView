#import "include/CardFormatters.h"

static CGFloat unit_scale = 0.9;

@implementation CardFormatters

+ (NSDictionary*) unitsAttrs:(NSDictionary*) attrs {
    NSMutableDictionary* unitsAttrs = attrs.mutableCopy;
    ILFont* fullSize = attrs[NSFontAttributeName];
    ILFont* halfSize = [ILFont fontWithName:fullSize.fontName size:(fullSize.pointSize * unit_scale)];
    unitsAttrs[NSForegroundColorAttributeName] = ILColor.grayColor;
    unitsAttrs[NSFontAttributeName] = halfSize;
    return unitsAttrs;
}

+ (NSDictionary*) cardinalAttrs:(NSDictionary*) attrs {
    NSMutableDictionary* cardinalAttrs = attrs.mutableCopy;
    cardinalAttrs[NSForegroundColorAttributeName] = ILColor.grayColor;
    return cardinalAttrs;
}

+ (NSDictionary*) monospaceAttrs:(NSDictionary*) attrs {
    NSMutableDictionary* monoAttrs = attrs.mutableCopy;
    ILFont* attrsFont = attrs[NSFontAttributeName];
    ILFont* monoFont = [ILFont userFixedPitchFontOfSize:attrsFont.pointSize];
    monoAttrs[NSFontAttributeName] = monoFont;
    return monoAttrs;
}

- (NSAttributedString*) attributedStringForObjectValue:(id)object withDefaultAttributes:(NSDictionary*) defaultAttrs {
    NSString* formattedString = [self stringForObjectValue:object];
    return [NSAttributedString.alloc initWithString:formattedString attributes:defaultAttrs];
}

@end

// MARK: -

@implementation CardArrayFormatter

- (NSString*) stringForObjectValue:(id)obj {
    NSString* arrayString = nil;

    if ([obj isKindOfClass:NSArray.class]) {
        NSArray* valueArray = (NSArray*)obj;
        NSMutableArray* formattedStrings = NSMutableArray.new;

        for (id valueItem in valueArray) {
            if (self.itemFormatter) {
                [formattedStrings addObject:[self.itemFormatter stringForObjectValue:valueItem]];
            }
            else {
                [formattedStrings addObject:[valueItem description]];
            }
        }

        arrayString = [formattedStrings componentsJoinedByString:@", "];
    }
    else if (self.itemFormatter) {
        arrayString = [self.itemFormatter stringForObjectValue:obj];
    }
    else {
        arrayString = [obj description];
    }

    return arrayString;
}

- (NSAttributedString*) attributedStringForObjectValue:(id)obj withDefaultAttributes:(NSDictionary<NSString *,id> *)attrs {
    NSAttributedString* arrayString = nil;
    if ([obj isKindOfClass:NSArray.class]) {
        NSArray* attributeArray = (NSArray*)obj;
        NSMutableAttributedString* formattedString = NSMutableAttributedString.new;

        BOOL first = YES;
        for (id valueItem in attributeArray) {
            NSAttributedString* formattedItem = nil;
            if (!first) {
                [formattedString appendAttributedString:
                 [NSAttributedString.alloc initWithString:@", " attributes:[CardFormatters unitsAttrs:attrs]]];
            }

            if (self.itemFormatter) {
                if ([self.itemFormatter respondsToSelector:@selector(attributedStringForObjectValue:withDefaultAttributes:)]) {
                    formattedItem = [self.itemFormatter attributedStringForObjectValue:valueItem withDefaultAttributes:attrs];
                }
                else {
                    formattedItem = [NSAttributedString.alloc initWithString:[self.itemFormatter stringForObjectValue:valueItem] attributes:attrs];
                }
            }
            else {
                formattedItem = [NSAttributedString.alloc initWithString:[valueItem description] attributes:attrs];
            }

            if (first) {
                first = NO;
            }

            [formattedString appendAttributedString:formattedItem];
        }

        arrayString = formattedString;
    }

    return arrayString;
}

@end

// MARK: -

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

/*! CardListFormatter formats arrays with commas between the elements */
@implementation CardListFormatter

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

@implementation CardURLFormatter

+ (CardURLFormatter*) formatterWithLinkColor:(ILColor*) color {
    CardURLFormatter* urlFormatter = CardURLFormatter.new;
    urlFormatter.linkColor = color;
    return urlFormatter;
}

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

// MARK: -

/*! PListFormatter formatts plists into various forms */
@implementation PListFormatter

- (NSString*) stringForObjectValue:(id)obj {
    NSString* plistString = [obj description];
    return plistString;
}

@end

// MARK: -

/*! PListJSONFormatter formatts plists into various forms */
@implementation PListJSONFormatter

- (NSString*) stringForObjectValue:(id)obj {
    NSString* plistJSONString = nil;

    NSError *error;
    NSData *jsonData = [NSJSONSerialization
        dataWithJSONObject:obj
        options:NSJSONWritingPrettyPrinted
        error:&error];
    plistJSONString = [NSString.alloc
        initWithData:jsonData
        encoding:NSUTF8StringEncoding];

    return plistJSONString;
}


@end

// MARK: -

/*! https://daringfireball.net/projects/markdown/syntax.text */
@implementation PListMarkdownFormatter

+ (PListMarkdownFormatter*) pListMarkdownFormatter {
    return PListMarkdownFormatter.new;
}

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

// MARK: - Date Formatter

@implementation CardDateFormatter

/*! @discussion singleton NSDateFormatter for the users's current locale */
+ (CardDateFormatter*) localDateFormatter {
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

- (NSAttributedString*) attributedStringForObjectValue:(id)object withDefaultAttributes:(NSDictionary*) defaultAttrs {
    NSString* formattedString = [self stringForObjectValue:object];
    return [NSAttributedString.alloc initWithString:formattedString attributes:defaultAttrs];
}

@end

// MARK: - Units Formatter

@implementation CardUnitsFormatter

- (instancetype) init {
    if ((self = super.init)) {
        self.numberStyle = NSNumberFormatterDecimalStyle;
        self.minimumIntegerDigits = 1;
        self.maximumIntegerDigits = 99;
        self.minimumFractionDigits = 0;
        self.maximumFractionDigits = 9;
        self.usesGroupingSeparator = YES;
    }
    return self;
}

- (NSAttributedString*) attributedStringForObjectValue:(id) anObject withDefaultAttributes:(NSDictionary*) attrs {
    NSMutableAttributedString* formatted = nil;
    if ([anObject isKindOfClass:NSNumber.class]) {
        formatted = NSMutableAttributedString.new;
        NSDictionary* unitsAttrs = [CardFormatters unitsAttrs:attrs];
        if (self.prefix) {
            NSAttributedString* formattedPrefix = [NSAttributedString.alloc initWithString:self.prefix attributes:unitsAttrs];
            [formatted appendAttributedString:formattedPrefix];
            [formatted appendAttributedString:[NSAttributedString.alloc initWithString:@" "]];
        }
        NSString* valueString = [self stringForObjectValue:anObject];
        NSAttributedString* formattedValue = [NSAttributedString.alloc initWithString:valueString attributes:attrs];
        [formatted appendAttributedString:formattedValue];
        if (self.units) {
            NSAttributedString* formattedUnits = [NSAttributedString.alloc initWithString:self.units attributes:unitsAttrs];
            [formatted appendAttributedString:[NSAttributedString.alloc initWithString:@" "]];
            [formatted appendAttributedString:formattedUnits];
        }
    }

    return formatted;
}

@end

// MARK: - Number Formatters

@implementation CardBooleanFormatter

- (NSString*) stringForObjectValue:(id)obj {
    NSString* string = @"-";
    if ([obj isKindOfClass:NSNumber.class]) {
        if ([(NSNumber*)obj boolValue]) {
            string = NSLocalizedString(@"Yes", @"Yes");
        }
        else {
            string = NSLocalizedString(@"No", @"No");
        }
    }

    return string;
}

- (NSAttributedString*) attributedStringForObjectValue:(id)object withDefaultAttributes:(NSDictionary*) defaultAttrs {
    NSString* formattedString = [self stringForObjectValue:object];
    return [NSAttributedString.alloc initWithString:formattedString attributes:defaultAttrs];
}

@end

// MARK: -

@implementation CardBytesFormatter

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
    else if (fileSize < GB) { // display MB
        scaledSize = fileSize / (CGFloat)MB;
        self.minimumFractionDigits = 1;
        self.maximumFractionDigits = 2;
        self.units = NSLocalizedStringFromTableInBundle(@"MB", nil, [NSBundle bundleForClass:self.class], nil);
    }
    else if (fileSize < TB) { // display GB
        scaledSize = fileSize / (CGFloat)GB;
        self.minimumFractionDigits = 1;
        self.maximumFractionDigits = 2;
        self.units = NSLocalizedStringFromTableInBundle(@"GB", nil, [NSBundle bundleForClass:self.class], nil);
    }
    else if (fileSize < PB) { // display TB
        scaledSize = fileSize / (CGFloat)TB;
        self.minimumFractionDigits = 1;
        self.maximumFractionDigits = 2;
        self.units = NSLocalizedStringFromTableInBundle(@"TB", nil, [NSBundle bundleForClass:self.class], nil);
    }
    else if (fileSize < EB) { // display PB
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

/// https://en.wikipedia.org/wiki/Continued_fraction
/// accuracy like 1.0e+4
void fractionDouble(double floating, double accuracy, long* numerator, long* denominator) {

    // generate a vector of fraction terms
    double floatPart = floating;
    long wholePart = floor(floatPart);
    long terms[64] = { 0.0 }; // TODO figure a better limit here
    long termIndex = 0;
    terms[termIndex++] = wholePart;

    floatPart -= wholePart;

    double multiple = 1;
    while (floatPart != 0.0 && (floatPart > -accuracy) && (multiple < accuracy)) {
        floatPart = 1.0 / floatPart;
        multiple = multiple * (floatPart + 1);
        wholePart = floor(floatPart);
        terms[termIndex++] = wholePart; // TODO check terms count
        floatPart -= wholePart;
    }

    // reduce terms into numerator and denominator, unwinding termIndex
    long num = 1;
    double den = terms[termIndex];

    while(--termIndex > 0) {
        double num2 = terms[termIndex];
        // swap numerator and denominator
        if (den >= 1.0) {
            num = floor(den);
        }
        den = num2;
    }

    // write the num and dem to the out parameters
    if (numerator != NULL) {
        *numerator = num;
    }

    if (denominator != NULL) {
        *denominator = floor(den);
    }
}

/// Format a NSNumber as a fractional value using the continued fraction method
@implementation CardFractionFormatter

+ (NSString*) fractionStringForNumber:(NSNumber *)number {
    long numerator = 0;
    long denominator = 0;
    fractionDouble(number.doubleValue, 1.0e+4, &numerator, &denominator);
    unichar fractionSlash = 0x2044;
    return [NSString stringWithFormat:@"%ld%C%ld", numerator, fractionSlash, denominator];
}

- (NSString*) stringForObjectValue:(id)obj {
    NSString* string = nil;

    if ([obj isKindOfClass:NSNumber.class]) {
        string = [CardFractionFormatter fractionStringForNumber:(NSNumber*)obj];
    }
    else {
        string = [obj description];
    }

    return string;
}

@end

// MARK: -

void timecode(double totalSeconds, double frameInterval, long* hours, long* minutes, long* seconds, long* frames, double* decimalSeconds) {
    double integralSeconds;
    double fractionalSeconds = modf(totalSeconds, &integralSeconds);
    long hoursCount = floor(integralSeconds / (60 * 60)); // 60 seconds x 60 minutes
    long minutesCount = floor((integralSeconds - (hoursCount * 60 * 60)) / 60); // 60 seconds
    if (frameInterval == 0.0) { // assume 24 FPS
        frameInterval = (1.0 / 24);
    }
    long frameCount = floor(fractionalSeconds / frameInterval); // need to convert decimal seconds to 24 FPS frames (1/24)

    // get the integer values we need
    if (hours) {
        *hours = hoursCount;
    }

    if (minutes) {
        *minutes = minutesCount;
    }

    if (seconds) {
        *seconds = (integralSeconds - (hoursCount * 60 * 60) - (minutesCount * 60)); // remove the hours and minutes seconds
    }

    if (frames) {
        *frames = frameCount;
    }

    if (decimalSeconds) {
        *decimalSeconds = (totalSeconds - (hoursCount * 60 * 60) - (minutesCount * 60));
    }
}

@implementation CardTimecodeFormatter

- (instancetype) init {
    if ((self = super.init)) {
        self.unitSeparators = YES;
        self.decimalSeconds = YES;
    }

    return self;
}

- (NSString*) stringForObjectValue:(id)obj {
    NSString* string = nil;
    if ([obj isKindOfClass:NSNumber.class]) {
        double totalSeconds = ((NSNumber*)obj).doubleValue;
        double decimalSeconds;
        long hours, minutes, seconds, frames;
        timecode(totalSeconds, self.frameInterval, &hours, &minutes, &seconds, &frames, &decimalSeconds);
        if (self.decimalSeconds) {
            string = [NSString stringWithFormat:(self.unitSeparators ? @"%02ldh %02ldm %2.4fs" : @"%02ld:%02ld:%2.4f"), hours, minutes, decimalSeconds];
        }
        else {
            string = [NSString stringWithFormat:(self.unitSeparators ? @"%02ldh %02ldm %02lds %02ldf" : @"%02ld:%02ld:%02ld:%02ld"), hours, minutes, seconds, frames];
        }
    }
    else {
        string = [obj description];
    }

    return string;
}

- (NSAttributedString*) attributedStringForObjectValue:(id)obj withDefaultAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs {
    NSMutableAttributedString* timecodeString = NSMutableAttributedString.new;
    if ([obj isKindOfClass:NSNumber.class]) {
        NSDictionary* seperatorAttrs = (self.unitSeparators ? [CardFormatters unitsAttrs:attrs] : [CardFormatters cardinalAttrs:attrs]);

        double totalSeconds = ((NSNumber*) obj).doubleValue;
        double decimalSeconds;
        long hours, minutes, seconds, frames;
        timecode(totalSeconds, self.frameInterval, &hours, &minutes, &seconds, &frames, &decimalSeconds);
        [timecodeString appendAttributedString:[NSAttributedString.alloc initWithString:[NSString stringWithFormat:@"%02ld", hours] attributes:attrs]];
        [timecodeString appendAttributedString:[NSAttributedString.alloc initWithString:(self.unitSeparators ? @"h " : @":") attributes:seperatorAttrs]];
        [timecodeString appendAttributedString:[NSAttributedString.alloc initWithString:[NSString stringWithFormat:@"%02ld", minutes] attributes:attrs]];
        [timecodeString appendAttributedString:[NSAttributedString.alloc initWithString:(self.unitSeparators ? @"m " : @":") attributes:seperatorAttrs]];
        if (self.decimalSeconds) {
            [timecodeString appendAttributedString:[NSAttributedString.alloc initWithString:[NSString stringWithFormat:@"%2.4f", decimalSeconds] attributes:attrs]];
            if (self.unitSeparators) {
                [timecodeString appendAttributedString:[NSAttributedString.alloc initWithString:@"s" attributes:seperatorAttrs]];
            }
        }
        else {
            [timecodeString appendAttributedString:[NSAttributedString.alloc initWithString:[NSString stringWithFormat:@"%02ld", seconds] attributes:attrs]];
            [timecodeString appendAttributedString:[NSAttributedString.alloc initWithString:(self.unitSeparators ? @"s " : @":") attributes:seperatorAttrs]];
            [timecodeString appendAttributedString:[NSAttributedString.alloc initWithString:[NSString stringWithFormat:@"%02ld", frames] attributes:attrs]];
            if (self.unitSeparators) {
                [timecodeString appendAttributedString:[NSAttributedString.alloc initWithString:@"f" attributes:seperatorAttrs]];
            }
        }
    }
    else {
        [timecodeString appendAttributedString:[NSAttributedString.alloc initWithString:[self stringForObjectValue:obj] attributes:attrs]];
    }

    return timecodeString;
}

@end

// MARK: -

@implementation CardFormattingTransformer : NSValueTransformer

+ (void)setFormattingTransformer:(nonnull NSFormatter *)formatter forName:(nonnull NSString *)name {
    CardFormattingTransformer* transformer = CardFormattingTransformer.new;
    transformer.formatter = formatter;
    [NSValueTransformer setValueTransformer:transformer forName:name];
}

// MARK: - NSValueTransformer

+ (BOOL)allowsReverseTransformation {
    return NO;
}

+ (Class)transformedValueClass {
    return NSObject.class; // if this needs to be different, subclass and register a new transformer
}

// MARK: -

- (id)transformedValue:(id)value {
    id transformed = nil;

    if (self.formatter) {
        if ([self.formatter respondsToSelector:@selector(attributedStringForObjectValue:withDefaultAttributes:)]) {
            transformed = [self.formatter attributedStringForObjectValue:value withDefaultAttributes:nil];
        }
        else {
            transformed = [self.formatter stringForObjectValue:value];
        }
    }
    else {
        transformed = [value description]; // fallback transform, might be better to return the value as is
    }

    return transformed;;
}

@end
