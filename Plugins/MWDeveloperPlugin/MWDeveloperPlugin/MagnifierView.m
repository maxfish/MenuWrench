//
//  MagnifierView.m
//  MWDeveloperPlugin
//
//  Created by max on 15/04/17.
//  Copyright © 2017 Massimiliano Pesce. All rights reserved.
//

#import "MagnifierView.h"

@implementation MagnifierView {
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _zoomFactor = 2; // *2 = 4
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    CGContextRef myContext = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetInterpolationQuality(myContext, kCGInterpolationNone);
    CGContextSetBlendMode(myContext, kCGBlendModeNormal);
    CGContextSetLineWidth(myContext, 1);
    CGContextSetRGBFillColor(myContext, 0.1, 0.1, 0.1, 1);
    CGContextSetRGBStrokeColor(myContext, 0, 0, 0, 1);

    CGImageRef imageRef = CGDisplayCreateImage(CGMainDisplayID());
    CGDataProviderRef provider = CGImageGetDataProvider(imageRef);
    CFDataRef dataref = CGDataProviderCopyData(provider);

    int scale = _zoomFactor * 2;
    CGRect clipRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    CGRect screenRect = CGRectMake(0, 0, CGImageGetWidth(imageRef),  CGImageGetHeight(imageRef));
//    size_t imageWidth = CGImageGetWidth(imageRef);
//    size_t imageHeight = CGImageGetHeight(imageRef);
    size_t bpp = CGImageGetBitsPerPixel(imageRef) / 8;
    CFRelease(dataref);

    CGRect drawRect = CGRectMake(
            -(int) (_mouseLocation.x - self.bounds.size.width / 2 / scale) * scale,
            (int) (self.bounds.size.height - (int) (_mouseLocation.y + self.bounds.size.height / 2 / scale) * scale),
            (int) (screenRect.size.width * scale),
            (int) (screenRect.size.height * scale)
    );

    // Draw
    CGContextClipToRect(myContext, clipRect);
    CGContextFillRect(myContext, clipRect);
    CGContextDrawImage(myContext, drawRect, imageRef);
    CGContextStrokeRectWithWidth(myContext, CGRectMake(clipRect.size.width / 2 - scale / 2 - 0.5, clipRect.size.height / 2 - scale / 2 - 0.5, scale + 1, scale + 1), 1);

    CGImageRelease(imageRef);
}

- (void)drawRect_SMALL_AREA:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    CGContextRef myContext = [[NSGraphicsContext currentContext] graphicsPort];

    int scale = _zoomFactor * 2;
    CGRect clipRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);

    NSScreen *mainScreen = [NSScreen mainScreen];
    NSRect screenRect = [mainScreen frame];

//    CGImageRef imageRef2 = CGDisplayCreateImage(CGMainDisplayID())
    CGRect sourceRect = CGRectMake(
            (int) (_mouseLocation.x - self.bounds.size.width / 2 / scale),
            screenRect.size.height - (int) (_mouseLocation.y + self.bounds.size.height / 2 / scale),
            clipRect.size.width / scale,
            clipRect.size.height / scale
    );
    CGImageRef imageRef = CGDisplayCreateImageForRect(CGMainDisplayID(), sourceRect);

//    CGDataProviderRef provider = CGImageGetDataProvider(imageRef);
//    CFDataRef dataref = CGDataProviderCopyData(provider);
//    size_t imageWidth = CGImageGetWidth(imageRef);
//    size_t imageHeight = CGImageGetHeight(imageRef);
//    size_t bpp = CGImageGetBitsPerPixel(imageRef) / 8;
//    CFRelease(dataref);

//    CGRect drawRect = CGRectMake(
//            (int) (-(int) (_mouseLocation.x - self.bounds.size.width / 2 / scale) * scale),
//            (int) (self.bounds.size.height - (int) (_mouseLocation.y + self.bounds.size.height / 2 / scale) * scale),
//            (int) (imageWidth * scale),
//            (int) (imageHeight * scale)
//    );

    CGContextSetBlendMode(myContext, kCGBlendModeNormal);
    CGContextSetLineWidth(myContext, 1);
    CGContextSetRGBFillColor(myContext, 0.1, 0.1, 0.1, 1);
    CGContextFillRect(myContext, clipRect);

    CGContextSetInterpolationQuality(myContext, kCGInterpolationNone);
    CGContextClipToRect(myContext, clipRect);
    CGContextDrawImage(myContext, clipRect, imageRef);
    CGImageRelease(imageRef);

    CGContextSetRGBStrokeColor(myContext, 0, 0, 0, 1);
    CGContextStrokeRectWithWidth(myContext, CGRectMake(clipRect.size.width / 2 - scale / 2 - 0.5, clipRect.size.height / 2 - scale / 2 - 0.5, scale + 1, scale + 1), 1);
}

@end
