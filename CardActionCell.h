#import <KitBridge/KitBridge.h>


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
