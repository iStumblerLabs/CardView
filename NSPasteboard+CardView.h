//
//  NSPasteboard+CardView.h
//  CardView
//
//  Created by alf on 7/24/14.
//
//

#import <Cocoa/Cocoa.h>

@interface NSPasteboard (CardView)

- (NSPasteboard*) clone; // create a clone of this pasteboard with a unique name
- (NSArray*) clonedItems;

@end

#pragma mark -

@interface NSPasteboardItem (CardView)

- (NSPasteboardItem*) clone;

@end
