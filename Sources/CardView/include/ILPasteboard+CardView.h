#if SWIFT_PACKAGE
#import "KitBridge.h"
#else
#import <KitBridge/KitBridge.h>
#endif


@interface ILPasteboard (CardView)

/// @returns a clone of this pasteboard with a new unique name
- (ILPasteboard*) clone;

/// @returns a clone of the items on this pasteboard
- (NSArray*) clonedItems;

@end

#if IL_APP_KIT
// MARK: -

@interface ILPasteboardItem (CardView)

- (ILPasteboardItem*) clone;

@end
#endif
