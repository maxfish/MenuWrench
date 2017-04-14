//
//  SBTSystemPlugin.m
//  SBTSystemPlugin
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import "SBTSystemPlugin.h"
#import "SystemDefaults.h"

NSString *const kConfigEnabledKey = @"enable";

@interface SBTSystemPlugin ()
@property(strong, nonatomic) NSMenuItem *menuItem;
@property(strong, nonatomic) NSMenu *submenu;
@end

@implementation SBTSystemPlugin {
    NSDictionary *_appInfo;
    BOOL _debugEnabled;
    NSMutableDictionary *_pluginConfig;

    SystemDefaults *_defaults;
}

- (id)init {
    self = [super init];
    if (self) {
        _pluginConfig = [[NSMutableDictionary alloc] init];

        // Default values
        _pluginConfig[kConfigEnabledKey] = @(YES);
        _defaults = [[SystemDefaults alloc] init];
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
    self.menuItem = [[NSMenuItem alloc] initWithTitle:pluginName action:nil keyEquivalent:@""];
    self.submenu = [[NSMenu alloc] init];
    [self.menuItem setEnabled:YES];

    [_submenu addItem:[NSMenuItem separatorItem]];

    NSMenuItem *m2 = [self.submenu addItemWithTitle:@"Defaults" action:nil keyEquivalent:@""];
    NSMenu *s1 = [[NSMenu alloc] init];

    // One menu item per setting
    for (int index=0; index<_defaults.settings.count; index++){
        NSArray *setting = _defaults.settings[(NSUInteger) index];
        NSMenuItem *menuItem = [s1 addItemWithTitle:setting[0] action:@selector(toggleDefaultsMenuItem:) keyEquivalent:@""];
        [menuItem setTarget:self];
        [menuItem setTag:index];
        [self _setDefaultsMenuItemStatus:menuItem];
    }

    [m2 setSubmenu:s1];
    [self.menuItem setSubmenu:self.submenu];
    NSMenuItem *cleanItem = [self.submenu addItemWithTitle:@"Clean up 'Open with' associations" action:@selector(cleanOpenWithAssociations:) keyEquivalent:@""];
    [cleanItem setEnabled:YES];
    [cleanItem setTarget:self];
}

- (NSMenuItem *)menuItem {
    if (!_menuItem) {
        [self _createMenuItem];
    }

    return _menuItem;
}

- (void)_setDefaultsMenuItemStatus:(NSMenuItem *)item {
    [item setState:[_defaults statusOf:(NSUInteger) item.tag] ? NSOnState : NSOffState];
}

- (IBAction)toggleDefaultsMenuItem:(id)sender {
    NSMenuItem *menuItem = sender;
    NSUInteger default_id = (NSUInteger) menuItem.tag;
    BOOL newState = ![_defaults statusOf:default_id];
    [_defaults setDefault:default_id to:newState];
    [menuItem setState:newState ? NSOnState : NSOffState];
}

- (void)cleanOpenWithAssociations:(id)sender {
    NSArray *arguments = @[@"-kill", @"-r", @"-domain", @"local", @"-domain", @"user"];
    NSTask *task = [NSTask launchedTaskWithLaunchPath:@"/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister" arguments:arguments];
    [task waitUntilExit];
    [[NSTask launchedTaskWithLaunchPath:@"/usr/bin/killall" arguments:@[@"Finder"]] waitUntilExit];
}

@end