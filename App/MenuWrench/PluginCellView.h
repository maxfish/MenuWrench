//
//  TaskCellView.h
//  ToDo
//
//  Created by Massimiliano Pesce on 4/1/15.
//  Copyright (c) 2015 Massimiliano Pesce. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Plugin;

@interface PluginCellView : NSTableCellView

- (void)setupWithPlugin:(Plugin *)plugin;

@end
