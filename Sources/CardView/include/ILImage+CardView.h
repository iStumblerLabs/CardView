#import <Foundation/Foundation.h>


@interface ILImage (CardView)

/// Writes the image as a PNG to the file URL provided
/// http://stackoverflow.com/questions/17507170/how-to-save-png-file-from-nsimage-retina-issues
- (BOOL)writePNGToURL:(NSURL*)URL outputSize:(CGSize)outputSizePx alphaChannel:(BOOL)alpha error:(NSError*__autoreleasing*)error;

@end
