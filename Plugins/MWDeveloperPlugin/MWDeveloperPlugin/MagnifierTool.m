//
// Created by maxfish on 15/04/17.
// Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import "MagnifierTool.h"
#import "MagnifierView.h"

@implementation MagnifierTool {
    IBOutlet NSView *_containerView;
    IBOutlet MagnifierView *_magnifierView;
    IBOutlet NSTextField *_coordsLabel;
    IBOutlet NSTextField *_rgbLabel;
    IBOutlet NSColorWell *_colorWell;

    NSTimer *_timer;
}

- (instancetype)init {
    self = [super initWithWindowNibName:@"MagnifierTool"];
    if (self) {
        NSPanel *w = (NSPanel *) [self window];
        [w setHidesOnDeactivate:NO];
        [w setFloatingPanel:YES];
        [w setStyleMask:NSWindowStyleMaskTitled | NSUtilityWindowMask | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable | NSWindowStyleMaskNonactivatingPanel];
        [w setLevel:kCGMaximumWindowLevelKey];
        [w setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorFullScreenAuxiliary | NSWindowCollectionBehaviorTransient];
        [w center];
        [w orderFront:nil];
    }

    return self;
}

- (void)show {
    [self showWindow:[self window]];

    if (!_timer || ![_timer isValid]) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                  target:self
                                                selector:@selector(refreshTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

- (void)hide {
    [_timer invalidate];
    _timer = nil;
}

- (void)refreshTimer:(NSTimer *)timer {
    NSPoint mouseLocation = [self getMouseLocationOnScreen];
    [_magnifierView setMouseLocation:mouseLocation];

    NSString *coords = [NSString stringWithFormat:@"%i, %i", (int) (mouseLocation.x), (int) (mouseLocation.y)];
    [_coordsLabel setStringValue:coords];

    NSString *hexColor = [NSString stringWithFormat:@"#%02X%02X%02X", _magnifierView.red, _magnifierView.green, _magnifierView.blue];
    NSString *rgbColor = [NSString stringWithFormat:@"%i,%i,%i", _magnifierView.red, _magnifierView.green, _magnifierView.blue];
    NSString *rgb = [NSString stringWithFormat:@"#%@ / %i,%i,%i", hexColor, _magnifierView.red, _magnifierView.green, _magnifierView.blue];
    [_rgbLabel setStringValue:[NSString stringWithFormat:@"%@ / %@", hexColor, rgbColor]];
    [_colorWell setColor:[NSColor colorWithRed:_magnifierView.red / 256.0 green:_magnifierView.green / 256.0 blue:_magnifierView.blue / 256.0 alpha:1]];

    [_magnifierView setNeedsDisplay:YES];
}

- (IBAction)changeZoomFactor:(id)sender {
    NSSliderCell *sliderCell = sender;
    _magnifierView.zoomFactor = sliderCell.intValue;
}

- (NSPoint)getMouseLocationOnScreen {
    NSPoint mouseLocation = [NSEvent mouseLocation];
    mouseLocation.x = round(mouseLocation.x);
    mouseLocation.y = round(mouseLocation.y);

//    NSScreen *mainScreen = [NSScreen mainScreen];
//    NSRect screenFrame = [mainScreen frame];
//    if (mouseLocation.x < NSMinX(screenFrame)) {
//        mouseLocation.x = NSMinX(screenFrame);
//    } else if (mouseLocation.x > NSMaxX(screenFrame)) {
//        mouseLocation.x = NSMaxX(screenFrame);
//    }
//    if (mouseLocation.y < NSMinY(screenFrame)) {
//        mouseLocation.y = NSMinY(screenFrame);
//    } else if (mouseLocation.y > NSMaxY(screenFrame)) {
//        mouseLocation.y = NSMaxY(screenFrame);
//    }
    return mouseLocation;
}

@end
