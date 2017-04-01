//
//  AppDelegate.h
//  MenuWrench
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu *statusMenu;
    IBOutlet NSMenuItem *startAtLoginMenuItem;
    NSStatusItem *statusItem;
}

- (IBAction)_toggleStartAtLogin:(id)sender;

@end
