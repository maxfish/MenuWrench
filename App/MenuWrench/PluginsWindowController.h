//
// Created by Massimiliano Pesce on 3/28/15.
// Copyright (c) 2015 Massimiliano Pesce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@class PluginsManager;
@class Plugin;


@interface PluginsWindowController : NSWindowController <NSTextFieldDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property IBOutlet NSTableView *tableView;

- (void)setPluginsList:(NSArray<Plugin *> *)pluginsList;

@end
