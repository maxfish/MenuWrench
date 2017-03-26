//
//  SBTSystemPlugin.m
//  SBTSystemPlugin
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import "SBTSystemPlugin.h"
#import "FinderRecipes.h"

NSString *const kConfigEnabledKey = @"enable";

@interface SBTSystemPlugin ()
@property(strong, nonatomic) NSMenuItem *menuItem;
@property(strong, nonatomic) NSMenu *submenu;
@end

@implementation SBTSystemPlugin {
    NSDictionary *_appInfo;
    BOOL _debugEnabled;
    NSMutableDictionary *_pluginConfig;

    NSMenuItem *_itemShowHiddenFiles;
    NSMenuItem *_itemShowDesktopIcons;
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
    self.menuItem = [[NSMenuItem alloc] initWithTitle:pluginName action:nil keyEquivalent:@""];
    self.submenu = [[NSMenu alloc] init];
    [self.menuItem setEnabled:YES];

    [_submenu addItem:[NSMenuItem separatorItem]];

    NSMenuItem *m2 = [self.submenu addItemWithTitle:@"Defaults" action:nil keyEquivalent:@""];
    NSMenu *s1 = [[NSMenu alloc] init];

    _itemShowHiddenFiles = [s1 addItemWithTitle:@"Show hidden files" action:@selector(toggleShowHiddenFiles:) keyEquivalent:@""];
    [_itemShowHiddenFiles setTarget:self];
    [self _initShowHiddenFiles];

    _itemShowDesktopIcons = [s1 addItemWithTitle:@"Show Desktop icons" action:@selector(toggleShowDesktopIcons:) keyEquivalent:@""];
    [_itemShowDesktopIcons setTarget:self];
    [self _initShowDesktopIcons];

    [m2 setSubmenu:s1];
    [self.menuItem setSubmenu:self.submenu];

    [[self.submenu addItemWithTitle:@"Clean up 'Open with' associations" action:@selector(cleanOpenWithAssociations:) keyEquivalent:@""] setTarget:FinderRecipes.class];
}

- (NSMenuItem *)menuItem {
    if (!_menuItem) {
        [self _createMenuItem];
    }

    return _menuItem;
}

#pragma - Hidden files

- (void)_initShowHiddenFiles {
    [_itemShowHiddenFiles setState:FinderRecipes.showHiddenFiles ? NSOnState : NSOffState];
}

- (IBAction)toggleShowHiddenFiles:(id)sender {
    BOOL newState = !(FinderRecipes.showHiddenFiles == NSOnState);
    [FinderRecipes setShowHiddenFiles:newState];
    [_itemShowHiddenFiles setState:newState ? NSOnState : NSOffState];
}

#pragma - Desktop icons

- (void)_initShowDesktopIcons {
    [_itemShowDesktopIcons setState:FinderRecipes.showDesktopIcons ? NSOnState : NSOffState];
}

- (IBAction)toggleShowDesktopIcons:(id)sender {
    BOOL newState = !(FinderRecipes.showDesktopIcons == NSOnState);
    [FinderRecipes setShowDesktopIcons:newState];
    [_itemShowDesktopIcons setState:newState ? NSOnState : NSOffState];
}

@end