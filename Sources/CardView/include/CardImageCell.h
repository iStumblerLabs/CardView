#if SWIFT_PACKAGE
@import KitBridge;
#else
#import <KitBridge/KitBridge.h>
#endif

#if IL_APP_KIT
@interface CardImageCell : NSTextAttachmentCell {
    NSImageCell* image_cell;
}

+ (CardImageCell*) cellWithImage:(NSImage*) cell_image;

- (id) initWithImage:(NSImage*) cell_image;

@end
#endif
