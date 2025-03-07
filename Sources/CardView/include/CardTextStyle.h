#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol CardTextStyle <NSObject>

// MARK: - Attributes

- (NSDictionary*) attributesForSize:(CGFloat) fontSize style:(NSParagraphStyle*) style;
- (NSDictionary*) centeredAttributesForSize:(CGFloat) fontSize style:(NSParagraphStyle*) style;
- (NSDictionary*) labelAttributesForSize:(CGFloat) fontSize style:(NSParagraphStyle*) style;
- (NSDictionary*) grayAttributesForSize:(CGFloat) fontSize style:(NSParagraphStyle*) style;
- (NSDictionary*) valueAttributesForSize:(CGFloat) fontSize style:(NSParagraphStyle*) style;
- (NSDictionary*) keywordAttributesForSize:(CGFloat) fontSize style:(NSParagraphStyle*) style;
- (NSDictionary*) contentAttributesForSize:(CGFloat) fontSize style:(NSParagraphStyle*) style;

// MARK: - Styles

- (NSAttributedString*) appendHeaderString:(NSString*) string size:(CGFloat) fontSize style:(NSParagraphStyle*) style;
- (NSAttributedString*) appendSubheaderString:(NSString*) string size:(CGFloat) fontSize style:(NSParagraphStyle*) style;
- (NSAttributedString*) appendCenteredString:(NSString*) string size:(CGFloat) fontSize style:(NSParagraphStyle*) style;
- (NSAttributedString*) appendLabelString:(NSString*) string size:(CGFloat) fontSize style:(NSParagraphStyle*) style;
- (NSAttributedString*) appendGrayString:(NSString*) string size:(CGFloat) fontSize style:(NSParagraphStyle*) style;
- (NSAttributedString*) appendValueString:(NSString*) string size:(CGFloat) fontSize style:(NSParagraphStyle*) style;
- (NSAttributedString*) appendKeywordString:(NSString*) string size:(CGFloat) fontSize style:(NSParagraphStyle*) style;
- (NSAttributedString*) appendMonospaceString:(NSString*) string size:(CGFloat) fontSize style:(NSParagraphStyle*) style;
- (NSAttributedString*) appendLinkTo:(NSString*) url withText:(NSString*) label size:(CGFloat) fontSize style:(NSParagraphStyle*) style;
- (NSAttributedString*) appendString:(NSString*) string size:(CGFloat) fontSize style:(NSParagraphStyle*) style;

// MARK: - Rules & Spacing

- (NSAttributedString*) appendHorizontalRule:(NSParagraphStyle*) style;
- (NSAttributedString*) appendHorizontalRuleWithAccentColor:(NSParagraphStyle*) style;
- (NSAttributedString*) appendHorizontalRuleWithColor:(ILColor*) color width:(CGFloat) width style:(NSParagraphStyle*) style;
- (NSAttributedString*) appendNewline:(CGFloat) size style:(NSParagraphStyle*) style;
- (NSAttributedString*) appendTab:(CGFloat) size style:(NSParagraphStyle*) style;

// MARK: - Images

- (NSAttributedString*) appendImage:(ILImage*) image size:(CGFloat) fontSize style:(NSParagraphStyle*) style;
- (NSAttributedString*) appendImage:(ILImage*) image withAttributes:(NSDictionary*) attributes;

@end

NS_ASSUME_NONNULL_END
