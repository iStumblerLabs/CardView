#import <KitBridge/KitBridge.h>

/* http://stackoverflow.com/questions/17507170/how-to-save-png-file-from-nsimage-retina-issues */


#pragma mark -

@implementation ILImage (CardView)

#ifdef IL_APP_KIT
- (BOOL)writePNGToURL:(NSURL*)URL outputSize:(CGSize)outputSizePx alphaChannel:(BOOL)alpha error:(NSError*__autoreleasing*)error
{
    BOOL result = NO;
    ILImage* scalingImage = [ILImage imageWithSize:self.size flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
        [self drawAtPoint:NSMakePoint(0.0, 0.0) fromRect:dstRect operation:NSCompositingOperationSourceOver fraction:1.0];
        return YES;
    }];
    CGRect proposedRect = CGRectMake(0.0, 0.0, outputSizePx.width, outputSizePx.height);
    unsigned components = 4;
    unsigned bitsPerComponent = 8;
    unsigned bytesPerRow = proposedRect.size.width * (components * (bitsPerComponent / BYTE_SIZE));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    CGContextRef cgContext = CGBitmapContextCreate(NULL,
        proposedRect.size.width, proposedRect.size.height,
        bitsPerComponent, bytesPerRow, colorSpace, (alpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst));
    NSGraphicsContext* context = [NSGraphicsContext graphicsContextWithGraphicsPort:cgContext flipped:NO];
    NSDictionary* hints = @{(id)kCGImagePropertyHasAlpha: @(alpha)};
    CGImageRef cgImage = [scalingImage CGImageForProposedRect:&proposedRect context:context hints:hints];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)(URL), kUTTypePNG, 1, NULL);
    CFDictionaryRef imageOptions = CFBridgingRetain(hints);
    CGImageDestinationAddImage(destination, cgImage, imageOptions);

    if (CGImageDestinationFinalize(destination)) {
        result = NO;
    }
    else {
        NSDictionary* details = @{NSLocalizedDescriptionKey:@"Error writing PNG image"};
        [details setValue:@"ran out of money" forKey:NSLocalizedDescriptionKey];
        NSError* writeError = [NSError errorWithDomain:@"SSWPNGAdditionsErrorDomain" code:10 userInfo:details];
        if (*error != nil && writeError) {
            *error = writeError;
        }
    }

exit:

    CGColorSpaceRelease(colorSpace);
    CGContextRelease(cgContext);
    CFRelease(destination);
    CFRelease(imageOptions);
    return result;
}
#endif

@end
