#if SWIFT_PACKAGE
@import KitBridge;
#else
#import <KitBridge/KitBridge.h>
#endif

#if SWIFT_PACKAGE
#import "CardTextStyle.h"
#else
#import <CardView/CardTextStyle.h>
#endif

NS_ASSUME_NONNULL_BEGIN

/// constants for -appendImage:withAttributes:target:action:
extern NSString* const CardTextAttachmentActionName;
extern NSString* const CardTextAttacmentTargetName;

@interface NSMutableAttributedString (CardView) <CardTextStyle>

@end

NS_ASSUME_NONNULL_END
