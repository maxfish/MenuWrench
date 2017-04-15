//
//  MagnifierView.h
//  MWDeveloperPlugin
//
//  Created by max on 15/04/17.
//  Copyright © 2017 Massimiliano Pesce. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MagnifierView : NSImageView

@property (assign) NSPoint mouseLocation;
@property (assign) int zoomFactor;

@end
