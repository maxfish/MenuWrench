//
//  MagnifierView.h
//  MWDeveloperPlugin
//
//  Created by maxfish on 15/04/17.
//  Copyright © 2017 Massimiliano Pesce. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MagnifierView : NSView

@property (assign) NSPoint mouseLocation;
@property (assign) int zoomFactor;
@property (readonly) UInt8 red;
@property (readonly) UInt8 blue;
@property (readonly) UInt8 green;

@end
