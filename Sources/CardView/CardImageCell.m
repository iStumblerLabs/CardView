#import "include/CardImageCell.h"

#if IL_APP_KIT
@implementation CardImageCell

+ (CardImageCell*) cellWithImage:(NSImage*) cell_image {
    return [CardImageCell.alloc initWithImage:cell_image];
}

// MARK: -

- (id) initWithImage:(NSImage*) cell_image {
    if ((self = super.init)) {
        image_cell = [NSImageCell.alloc initImageCell:cell_image];
        image_cell.imageScaling = NSImageScaleProportionallyUpOrDown;
    }
    return self;
}

// MARK: - NSTextFieldCell Methods

- (NSRect) cellFrameForTextContainer:(NSTextContainer*) textContainer
                proposedLineFragment:(NSRect) lineFrag
                       glyphPosition:(NSPoint)position
                      characterIndex:(NSUInteger)charIndex {
	NSRect frag = [super cellFrameForTextContainer:textContainer
							  proposedLineFragment:lineFrag
									 glyphPosition:position
									characterIndex:charIndex];
	NSSize size = textContainer.containerSize;
    NSSize image = image_cell.image.size;
    float width = size.width -= (2.0 * textContainer.lineFragmentPadding);
    float height = image.height * (width / image.width);
    NSSize preview = NSMakeSize(width, height);
	frag.size.width = preview.width;
    frag.size.height = fminf(image.height, preview.height);
	return frag;
}

- (void) drawWithFrame:(NSRect) frame inView:(NSView*) aView {
	[image_cell drawInteriorWithFrame:frame inView:aView];
}

@end
#endif
