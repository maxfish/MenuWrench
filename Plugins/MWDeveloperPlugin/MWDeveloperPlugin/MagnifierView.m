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
        _zoomFactor = 2; // '4x'
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

    NSScreen *screen = [self _screenContainingPoint:_mouseLocation];
    NSDictionary *screenDescription = [screen deviceDescription];
    NSRect mouseRect = [screen convertRectToBacking:CGRectMake(_mouseLocation.x, _mouseLocation.y, 0.5, 0.5)];
    _mouseLocation = mouseRect.origin;

    CGDirectDisplayID theCGDisplayID = (CGDirectDisplayID) [screenDescription[@"NSScreenNumber"] pointerValue];
    CGImageRef imageRef = CGDisplayCreateImage(theCGDisplayID);
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

//- (void)drawRect_xx:(NSRect)dirtyRect {
//    CGRect viewBounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
//    int scale = _zoomFactor * 2;
//    int visiblePixelsH = (int) ((viewBounds.size.width - (int) self.bounds.size.width % scale) / scale + 1);
//    int visiblePixelsV = (int) ((viewBounds.size.height - (int) self.bounds.size.height % scale) / scale + 1);
//
//    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
//    CGContextSetBlendMode(context, kCGBlendModeNormal);
//    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
//    CGContextSetRGBFillColor(context, 0.1, 0.1, 0.1, 1);
//    CGContextFillRect(context, self.bounds);
//
////    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
////    CGContextScaleCTM(context, 1.0, -1.0);
//
//    // Get current screen
//    NSScreen *screen = [self _screenContainingPoint:_mouseLocation];
//    if (!screen) {
//        return;
//    }
//    CGFloat backingScaleFactor = [screen backingScaleFactor];
//    NSRect screenRect = [screen frame];
//
//    // Capture image
//    CGRect sourceRect = CGRectMake(
//            (int) (_mouseLocation.x - visiblePixelsH / 2),
//            screenRect.size.height - (int) (_mouseLocation.y + visiblePixelsV / 2),
//            visiblePixelsH,
//            visiblePixelsV
//    );
//    CGWindowID windowID = (CGWindowID) [self.window windowNumber];
//    CGImageRef imageRef = CGWindowListCreateImage(sourceRect, kCGWindowListOptionOnScreenBelowWindow, windowID, (kCGWindowImageBoundsIgnoreFraming));
//
//    CGDataProviderRef provider = CGImageGetDataProvider(imageRef);
//    CFDataRef dataref = CGDataProviderCopyData(provider);
//    const UInt8 *data = CFDataGetBytePtr(dataref);
//    int imageWidth = (int) CGImageGetWidth(imageRef);
//    int imageHeight = (int) CGImageGetHeight(imageRef);
//    CFRelease(dataref);
//
//    int numberOfColorComponents = 4;
//    int x = visiblePixelsH / 2 + 9;
//    int y = imageHeight - (visiblePixelsV / 2 -1);
//    int coordinate = ((imageWidth * y) + x);
//    int pixelInfo = coordinate * numberOfColorComponents;
//
//    if (x < 0 || y < 0 || x >= imageWidth || y >= imageHeight) {
//        _red = _green = _blue = 0;
//    } else {
//        _blue = data[pixelInfo];
//        _green = data[(pixelInfo + 1)];
//        _red = data[pixelInfo + 2];
//        // UInt8 alpha = data[pixelInfo + 3];
//    }
//
//    // Draw image
//    CGRect drawRect = CGRectMake(0, 0, visiblePixelsH * scale, visiblePixelsV * scale);
//    CGContextDrawImage(context, drawRect, imageRef);
//
//    // Draw crosshair
//    CGFloat crossX = (visiblePixelsH / 2 - 1) * scale;
//    CGFloat crossY = (visiblePixelsV / 2 +1) * scale;
//    CGContextStrokeRectWithWidth(context, CGRectMake(crossX + 0.5, crossY + 0.5, scale - 1, scale - 1), 1);
//
//    CGImageRelease(imageRef);
//}

- (NSScreen *)_screenContainingPoint:(NSPoint)point {
    for (NSScreen *screen in [NSScreen screens]) {
        NSRect frame = [screen frame];
        frame.size.width += 1;
        frame.size.height += 1;
        if (NSPointInRect(point, frame)) {
            return screen;
        }
    }
    return nil;
}

@end
