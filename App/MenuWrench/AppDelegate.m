//
//  AppDelegate.m
//  MenuWrench
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import "AppDelegate.h"
#import "PluginManager.h"
#import "AppSettings.h"
#import "Utils.h"
#import "PluginsWindowController.h"


@interface AppDelegate () {
    AppSettings *_appSettings;
    PluginManager *_pluginManager;
    NSWindowController *_aboutWindowController;
    PluginsWindowController *_preferencesWindowController;
}
@end

@implementation AppDelegate

- (void)awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    NSImage *icon = [NSImage imageNamed:@"MenuIconWhite"];
    icon.template = YES;
    statusItem.image = icon;
    statusItem.menu = statusMenu;

    _appSettings = [[AppSettings alloc] init];
    [_appSettings loadFromFile];
    startAtLoginMenuItem.state = _appSettings.startAtLogin;
    [Utils toggleLoginItem:_appSettings.startAtLogin];

    _pluginManager = [[PluginManager alloc] initWithAppSettings:_appSettings];
    [_pluginManager loadPlugins];
    [_pluginManager startPlugins];

    int menuIndex = 0;
    for (NSMenuItem *menuItem in [_pluginManager menuItems]) {
        [statusMenu insertItem:menuItem atIndex:menuIndex++];
    }
}

- (NSString *)_versionString {
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    return [[NSString alloc] initWithFormat:@"v.%@ (%@)", version, build];
}

- (void)_toggleStartAtLogin:(id)sender {
    _appSettings.startAtLogin = !_appSettings.startAtLogin;
    startAtLoginMenuItem.state = _appSettings.startAtLogin;
    [Utils toggleLoginItem:_appSettings.startAtLogin];
    [_appSettings saveToFile];
}

- (IBAction)_showAboutWindow:(id)sender {
    if (!_aboutWindowController) {
        _aboutWindowController = [[NSWindowController alloc] initWithWindowNibName:@"AboutWindow"];
        NSTextField *versionLabel = [[[_aboutWindowController window] contentView] viewWithTag:1000];
        [versionLabel setStringValue:[self _versionString]];
    }
    [_aboutWindowController showWindow:[_aboutWindowController window]];
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)_showPreferencesWindow:(id)sender {
    if (!_preferencesWindowController) {
        _preferencesWindowController = [[PluginsWindowController alloc] initWithWindowNibName:@"PluginsWindow"];
    }
    [_preferencesWindowController showWindow:[_preferencesWindowController window]];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [_pluginManager stopPlugins];
}

@end
