//
//  MagnifierView.m
//  MWDeveloperPlugin
//
//  Created by maxfish on 15/04/17.
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
    int scale = _zoomFactor * 2;

    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextSetLineWidth(context, 1);
    CGContextSetRGBFillColor(context, 0.4, 0.4, 0.4, 1);
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);

    CGImageRef imageRef = CGDisplayCreateImage(CGMainDisplayID());
    CGRect screenRect = CGRectMake(0, 0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));

    CGDataProviderRef provider = CGImageGetDataProvider(imageRef);
    CFDataRef dataref = CGDataProviderCopyData(provider);
    const UInt8 *data = CFDataGetBytePtr(dataref);
    int imageWidth = (int) CGImageGetWidth(imageRef);
    int imageHeight = (int) CGImageGetHeight(imageRef);

    int numberOfColorComponents = 4;
    int x = (int) _mouseLocation.x - 1;
    int y = (int) (imageHeight - _mouseLocation.y - 1);
    int coordinate = ((imageWidth * y) + x);
    int pixelInfo = coordinate * numberOfColorComponents;

    if (x < 0 || y < 0 || x >= imageWidth || y >= imageHeight) {
        _red = _green = _blue = 0;
    } else {
        _blue = data[pixelInfo];
        _green = data[(pixelInfo + 1)];
        _red = data[pixelInfo + 2];
        // UInt8 alpha = data[pixelInfo + 3];
    }
    CFRelease(dataref);

    // Draw captured image
    CGRect drawRect = CGRectMake(
            (-_mouseLocation.x + self.bounds.size.width / 2 / scale) * scale,
            (-_mouseLocation.y + self.bounds.size.height / 2 / scale) * scale,
            (int) (screenRect.size.width * scale),
            (int) (screenRect.size.height * scale)
    );
    CGContextDrawImage(context, drawRect, imageRef);

    // Draw crosshair
    CGFloat crossX = ceil(self.bounds.size.width / 2 - scale);
    CGFloat crossY = ceil(self.bounds.size.height / 2 - scale);
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextStrokeRectWithWidth(context, CGRectMake(crossX + 0.5, crossY + 0.5, scale - 1, scale - 1), 1);

    CGImageRelease(imageRef);
}

//- (void)drawRect_Small:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
//
//    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
//    CGContextSetBlendMode(context, kCGBlendModeNormal);
//    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
//    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//
//    int scale = _zoomFactor * 2;
//    CGRect clipRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
//    CGRect drawRect = clipRect;
//
//    NSScreen *mainScreen = [NSScreen mainScreen];
//    NSRect screenRect = [mainScreen frame];
//
////    CGImageRef imageRef2 = CGDisplayCreateImage(CGMainDisplayID())
//    CGRect sourceRect = CGRectMake(
//            (int) (_mouseLocation.x - self.bounds.size.width / 2 / scale),
//            screenRect.size.height - (int) (_mouseLocation.y + self.bounds.size.height / 2 / scale),
//            clipRect.size.width / scale,
//            clipRect.size.height / scale
//    );
//    CGImageRef imageRef = CGDisplayCreateImageForRect(CGMainDisplayID(), sourceRect);
//    CGDataProviderRef provider = CGImageGetDataProvider(imageRef);
//    CFDataRef dataref = CGDataProviderCopyData(provider);
//    size_t imageWidth = CGImageGetWidth(imageRef);
//    size_t imageHeight = CGImageGetHeight(imageRef);
//    size_t bpp = CGImageGetBitsPerPixel(imageRef) / 8;
//
//    if (imageWidth < sourceRect.size.width) {
//        int diffX = (int) ((sourceRect.size.width - imageWidth) * scale);
//        if (sourceRect.origin.x < 0) {
//            drawRect.origin.x = diffX;
//        }
//    }
//    if (sourceRect.origin.y < 0) {
//        drawRect.origin.y = -sourceRect.origin.y * scale;
////        int diffY = (int) ((sourceRect.size.height - imageHeight) * scale);
////        if (sourceRect.origin.y < 0) {
////            drawRect.origin.y = diffY;
////        }
//    }
//    drawRect.size.width = imageWidth * scale;
//    drawRect.size.height = imageHeight * scale;
//
//    CGContextSetRGBFillColor(context, 0.1, 0.1, 0.1, 1);
//    CGContextFillRect(context, clipRect);
//
//    CGContextScaleCTM(context, 1.0, -1.0);
//    CGContextTranslateCTM(context, 0, -self.bounds.size.height);
//    CGContextDrawImage(context, drawRect, imageRef);
//
//    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
//    CGContextStrokeRectWithWidth(context, CGRectMake(clipRect.size.width / 2 - scale / 2 - 0.5, clipRect.size.height / 2 - scale / 2 - 0.5, scale + 1, scale + 1), 1);
//
//    CFRelease(dataref);
//    CGImageRelease(imageRef);
//}

@end
