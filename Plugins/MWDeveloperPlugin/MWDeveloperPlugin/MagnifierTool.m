//
// Created by maxfish on 15/04/17.
// Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import "MagnifierTool.h"
#import "MagnifierView.h"


@implementation MagnifierTool {
//    NSWindowController *_windowController;
    IBOutlet MagnifierView *_magnifierView;
    IBOutlet NSTextField *_coordsLabel;
    NSTimer *_timer;
}

- (instancetype)init {
    self = [super initWithWindowNibName:@"MagnifierTool"];
    if (self) {
    }

    return self;
}

- (void)show {
    [self showWindow:[self window]];
    [[self window] setViewsNeedDisplay:YES];
//    NSLog(@"---> controller %@", _windowController);
    NSLog(@"---> window %@", [self window]);
    [NSApp activateIgnoringOtherApps:YES];

    if (!_timer || ![_timer isValid]) {
//        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer *timer) {
//
////        NSLog(@"Mouse location: %f %f", mouseLoc.x, mouseLoc.y);
//        }];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                  target:self
                                                selector:@selector(timerDo:)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

- (void)hide {
    [_timer invalidate];
    _timer = nil;
}

- (void)timerDo:(NSTimer *)timer {
    NSPoint mouseLocation = [NSEvent mouseLocation];
    mouseLocation.x = round(mouseLocation.x);
    mouseLocation.y = round(mouseLocation.y);
    [_magnifierView setMouseLocation:mouseLocation];

    NSScreen *mainScreen = [NSScreen mainScreen];
    NSRect screenRect = [mainScreen frame];
    
    NSString *coords = [NSString stringWithFormat:@"(%i, %i)", (int) mouseLocation.x, (int) (screenRect.size.height - mouseLocation.y)];
    [_coordsLabel setStringValue:coords];
    
    [_magnifierView setNeedsDisplay:YES];
}

- (IBAction)changeZoomFactor:(id)sender {
    NSSliderCell *sliderCell = sender;
    _magnifierView.zoomFactor = sliderCell.intValue;
}

@end


/*
            CGContextSetInterpolationQuality(r13, kCGInterpolationNone);
            CGContextDrawImage(r13, 0x0, rdx);
https://pastebin.com/caqHmuEZ

 */
