#import "NSPasteboard+CardView.h"

@implementation ILPasteboard (CardView)

- (ILPasteboard*) clone
{
    ILPasteboard* clone = [ILPasteboard pasteboardWithUniqueName];
#if IL_APP_KIT
    [clone writeObjects:[self clonedItems]];
// TODO #elif IL_UI_KIT
#endif
    return clone;
}

- (NSArray*) clonedItems
{
    NSMutableArray* clonedItems = [NSMutableArray array];
#if IL_APP_KIT
    for (ILPasteboardItem* item in self.pasteboardItems) {
        [clonedItems addObject:[item clone]];
    }
// TODO #elif IL_UI_KIT
#endif
    return clonedItems;
}

@end

#if IL_APP_KIT
#pragma mark -

@implementation ILPasteboardItem (CardView)

- (ILPasteboardItem*) clone
{
    ILPasteboardItem* clone = [NSPasteboardItem new];
    for (NSString* type in self.types) {
        NSData* data = [self dataForType:type];
        if (data) {
            [clone setData:data forType:type];
        }
    }
    return clone;
}

@end
#endif

/** Copyright © 2014-2017, Alf Watt (alf@istumbler.net). All rights reserved.
    Redistribution and use permitted under MIT License in README.md. **/
