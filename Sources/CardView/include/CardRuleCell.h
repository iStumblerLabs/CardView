#if SWIFT_PACKAGE
@import KitBridge;
#else
#import <KitBridge/KitBridge.h>
#endif

#if IL_APP_KIT
/// Draws a separator in an CardView
/// http://www.cocoadev.com/index.pl?AddressBookCardView
@interface CardRuleCell : NSTextAttachmentCell
@property(nonatomic,retain) ILColor* separator_color;
@property(nonatomic,assign) CGFloat separator_width;

+ (NSAttributedString*) separator;
+ (NSAttributedString*) separatorWithColor:(ILColor*) color;
+ (NSAttributedString*) separatorWithColor:(ILColor*) color width:(CGFloat) width;

- (id) initWithColor:(ILColor*) color width:(CGFloat) width;

@end
#endif
