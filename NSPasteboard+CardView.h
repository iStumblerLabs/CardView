#import <Cocoa/Cocoa.h>

@interface NSPasteboard (CardView)

/*! @returns a clone of this pasteboard with a new unique name */
- (NSPasteboard*) clone;

/*! @returns a clone of the items on this pasteboard */
- (NSArray*) clonedItems;

@end

#pragma mark -

@interface NSPasteboardItem (CardView)

- (NSPasteboardItem*) clone;

@end

/** Copyright (c) 2014-2016, Alf Watt (alf@istumbler.net). All rights reserved.
    Redistribution and use permitted under MIT License in README.md. **/
