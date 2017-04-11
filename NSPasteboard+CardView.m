#import "NSPasteboard+CardView.h"

@implementation NSPasteboard (CardView)

- (NSPasteboard*) clone
{
    NSPasteboard* clone = [NSPasteboard pasteboardWithUniqueName];
    [clone writeObjects:[self clonedItems]];
    return clone;
}

- (NSArray*) clonedItems
{
    NSMutableArray* clonedItems = [NSMutableArray array];
    for (NSPasteboardItem* item in self.pasteboardItems) {
        [clonedItems addObject:[item clone]];
    }
    return clonedItems;
}

@end

#pragma mark -

@implementation NSPasteboardItem (CardView)

- (NSPasteboardItem*) clone
{
    NSPasteboardItem* clone = [NSPasteboardItem new];
    for (NSString* type in self.types) {
        NSData* data = [self dataForType:type];
        if (data) {
            [clone setData:data forType:type];
        }
    }
    return clone;
}

@end

/** Copyright (c) 2014-2017, Alf Watt (alf@istumbler.net). All rights reserved.
    Redistribution and use permitted under MIT License in README.md. **/
