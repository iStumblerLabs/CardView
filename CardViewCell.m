#import "CardViewCell.h"

@implementation CardViewCell

+ (instancetype) cellWithView:(NSView*) view {
    return [CardViewCell.alloc initWithView:view];
}

// MARK: -

- (instancetype) initWithView:(NSView*) view {
    if ((self = super.init)) {
        self.cellView = view;
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
    NSSize viewSize = self.cellView.frame.size;
    float width = size.width -= (2.0 * textContainer.lineFragmentPadding);
    float height = viewSize.height * (width / viewSize.width);
    NSSize preview = NSMakeSize(width, height);
    frag.size.width = preview.width;
    frag.size.height = fminf(viewSize.height, preview.height);
    return frag;
}

- (void) drawWithFrame:(NSRect) frame inView:(NSView*) aView {
    // TODO? add our view to the new framing view?
    [self.cellView setFrame:frame];
    [self.cellView drawRect:frame];
}

@end
