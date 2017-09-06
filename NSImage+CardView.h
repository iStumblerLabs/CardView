/* http://stackoverflow.com/questions/17507170/how-to-save-png-file-from-nsimage-retina-issues */

@interface ILImage (CardView)

- (BOOL)writePNGToURL:(NSURL*)URL outputSize:(NSSize)outputSizePx alphaChannel:(BOOL)alpha error:(NSError*__autoreleasing*)error;

@end
