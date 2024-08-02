#import <KitBridge/KitBridge.h>

@interface CardViewCell : NSTextAttachmentCell
@property(nonatomic,retain) ILView* cellView;

+ (instancetype) cellWithView:(NSView*) view;

// MARK: -

- (instancetype) initWithView:(NSView*) view;

@end
