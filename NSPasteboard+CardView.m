//
//  NSPasteboard+CardView.m
//  CardView
//
//  Created by alf on 7/24/14.
//
//

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
    for( NSPasteboardItem* item in self.pasteboardItems)
    {
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
    for( NSString* type in self.types)
    {
        [clone setData:[self dataForType:type] forType:type];
    }
    return clone;
}

@end