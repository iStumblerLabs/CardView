#import <KitBridge/KitBridge.h>

#define NSAS NSAttributedString

@interface NSAttributedString (CardView)

+ (NSAttributedString*) attributedString:(NSString*) string;
+ (NSAttributedString*) attributedString:(NSString*) string withFont:(ILFont*) font;
+ (NSAttributedString*) attributedString:(NSString*) string withLink:(NSURL*) url;
+ (NSAttributedString*) attributedString:(NSString*) string withAttributes:(NSDictionary*) attrs;
#ifdef IL_APP_KIT
+ (NSAttributedString*) attributedStringWithAttachmentCell:(id<NSTextAttachmentCell>) attach;
#endif

@end

#define NSMAS NSMutableAttributedString

@interface NSMutableAttributedString (CardView)

+ (NSMutableAttributedString*) mutableAttributedString:(NSString*) stirng;

@end
