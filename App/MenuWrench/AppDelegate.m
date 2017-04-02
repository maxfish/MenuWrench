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
#import "AboutWindowController.h"


@interface AppDelegate () {
    AppSettings *_appSettings;
    PluginManager *_pluginManager;
    AboutWindowController *_aboutWindowController;
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

- (void)_toggleStartAtLogin:(id)sender {
    _appSettings.startAtLogin = !_appSettings.startAtLogin;
    startAtLoginMenuItem.state = _appSettings.startAtLogin;
    [Utils toggleLoginItem:_appSettings.startAtLogin];
    [_appSettings saveToFile];
}

- (IBAction)_showAboutWindow:(id)sender {
    if (!_aboutWindowController) {
        _aboutWindowController = [[AboutWindowController alloc] initWithWindowNibName:@"AboutWindow"];
    }
    [_aboutWindowController showWindow:[_aboutWindowController window]];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [_pluginManager stopPlugins];
}

@end
