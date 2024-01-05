#import <KitBridge/KitBridge.h>

@interface CardImageCell : NSTextAttachmentCell
{
    NSImageCell* image_cell;
}

+ (CardImageCell*) cellWithImage:(NSImage*) cell_image;

- (id) initWithImage:(NSImage*) cell_image;

@end
