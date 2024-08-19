#if SWIFT_PACKAGE
#import "KitBridge.h"
#else
#import <KitBridge/KitBridge.h>
#endif


#if IL_APP_KIT
/// An NSTextAttachmentCell for displaying a button in a CardTextView
@interface CardActionCell : NSProxy <NSTextAttachmentCell> {
    NSPoint baseline_offset;
    NSActionCell* action_cell;
    NSTextAttachment* attachment;
}

+ (CardActionCell*) proxyWithActionCell:(NSActionCell*) cell;

- (id) initWithActionCell:(NSActionCell*) cell;

- (NSActionCell*) actionCell;
- (void) setActionCell:(NSActionCell*) cell;

- (void) setCellBaselineOffset:(NSPoint) offset;

@end
#endif
