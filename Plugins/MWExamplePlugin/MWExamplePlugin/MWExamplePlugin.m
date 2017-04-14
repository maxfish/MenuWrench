//
// Created by max on 26/03/17.
// Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import "MWExamplePlugin.h"


NSString *const kConfigEnabledKey = @"enable";

@interface MWExamplePlugin ()
@property(nonatomic) BOOL enabled;
@end

@implementation MWExamplePlugin {
    NSDictionary *_appInfo;
    BOOL _debugEnabled;
    NSMutableDictionary *_pluginConfig;
    
    NSMenuItem *_menuItem;
    NSMenu *_submenu;
    NSMenuItem *_itemEnableSwitch;
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
    [self loadConfig];

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

    _itemEnableSwitch = [_submenu addItemWithTitle:@"Enabled" action:@selector(_toggleEnabled:) keyEquivalent:@""];
    [_itemEnableSwitch setTarget:self];
    [_itemEnableSwitch setState:self.enabled];

    [_submenu addItem:[NSMenuItem separatorItem]];

    [_submenu addItemWithTitle:@"NOP Menu item" action:nil keyEquivalent:@""];

    [_submenu addItem:[NSMenuItem separatorItem]];
    [_menuItem setSubmenu:_submenu];
}

- (NSMenuItem *)menuItem {
    if (!_menuItem) {
        [self _createMenuItem];
    }

    return _menuItem;
}

#pragma - properties

- (BOOL)enabled {
    return [_pluginConfig[kConfigEnabledKey] boolValue];
}

- (void)setEnabled:(BOOL)newState {
    _pluginConfig[kConfigEnabledKey] = @(newState);
    [self saveConfig];
    [_itemEnableSwitch setState:newState ? NSOnState : NSOffState];
}

- (void)_toggleEnabled:(id)sender {
    [self setEnabled:!self.enabled];
}

#pragma - Private methods

- (NSDictionary *)loadConfig {
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:self.configFile];
    if (plist) {
        [_pluginConfig setValuesForKeysWithDictionary:plist];
    }
    [_itemEnableSwitch setState:self.enabled ? NSOnState : NSOffState];

    return plist;
}

- (void)saveConfig {
    if (_debugEnabled) {
        NSLog(@"Saving config to '%@'", self.configFile);
    }
    [_pluginConfig writeToFile:self.configFile atomically:YES];
}

- (NSString *)configFile {
    return [NSString stringWithFormat:@"%@/%@", self._absoluteConfigPath, @"config.plist"];
}

- (NSString *)_absoluteConfigPath {
    NSString *pluginName = [[NSBundle bundleForClass:self.class] objectForInfoDictionaryKey:kBundlePluginName];
    return [NSString stringWithFormat:@"%@/%@", _appInfo[kAppInfoConfigPath], pluginName];
}

@end
