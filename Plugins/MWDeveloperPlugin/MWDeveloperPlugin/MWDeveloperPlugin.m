//
//  MWDeveloperPlugin.m
//  MWDeveloperPlugin
//
//  Created by maxfish on 10/04/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import "MWDeveloperPlugin.h"
#import "MagnifierTool.h"

NSString *const kConfigEnabledKey = @"enable";

@implementation MWDeveloperPlugin {
    NSDictionary *_appInfo;
    BOOL _debugEnabled;
    NSMutableDictionary *_pluginConfig;
    NSMenuItem *_menuItem;
    NSMenu *_submenu;
    
    MagnifierTool *_magnifierTool;
}

- (id)init {
    self = [super init];
    if (self) {
        _pluginConfig = [[NSMutableDictionary alloc] init];

        // Default values
        _pluginConfig[kConfigEnabledKey] = @(YES);
    }

    return self;
}

- (BOOL)startWithInfo:(NSDictionary *)appInfo {
    _appInfo = appInfo;
    _debugEnabled = [appInfo[kAppInfoDebugEnabled] boolValue];
    return YES;
}

- (void)stop {

}

- (void)_createMenuItem {
    NSString *pluginName = [[NSBundle bundleForClass:self.class] objectForInfoDictionaryKey:kBundlePluginName];
    _menuItem = [[NSMenuItem alloc] initWithTitle:pluginName action:nil keyEquivalent:@""];
    _submenu = [[NSMenu alloc] init];
    [self.menuItem setEnabled:YES];
    [self.menuItem setSubmenu:_submenu];
    NSMenuItem *magnifierItem = [_submenu addItemWithTitle:@"Magnifier tool" action:@selector(showMagnifierTool:) keyEquivalent:@""];
    [magnifierItem setEnabled:YES];
    [magnifierItem setTarget:self];
}

- (NSMenuItem *)menuItem {
    if (!_menuItem) {
        [self _createMenuItem];
    }

    return _menuItem;
}

- (void)showMagnifierTool:(id)sender {
    _magnifierTool = [[MagnifierTool alloc] init];
    [_magnifierTool show];
}

@end
