#import <KitBridge/KitBridge.h>

@interface ILPasteboard (CardView)

/*! @returns a clone of this pasteboard with a new unique name */
- (ILPasteboard*) clone;

/*! @returns a clone of the items on this pasteboard */
- (NSArray*) clonedItems;

@end

#if IL_APP_KIT
#pragma mark -

@interface ILPasteboardItem (CardView)

- (ILPasteboardItem*) clone;

@end

#endif
