#import <Cocoa/Cocoa.h>

@interface NSPasteboard (CardView)

- (NSPasteboard*) clone; // create a clone of this pasteboard with a unique name
- (NSArray*) clonedItems;

@end

#pragma mark -

@interface NSPasteboardItem (CardView)

- (NSPasteboardItem*) clone;

@end

/** Copyright (c) 2014-2016, Alf Watt (alf@istumbler.net). All rights reserved.
    Redistribution and use permitted under MIT License in README.md. **/
