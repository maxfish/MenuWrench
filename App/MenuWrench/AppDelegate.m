//
//  AppDelegate.m
//  MenuWrench
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import "AppDelegate.h"
#import "PluginsManager.h"
#import "AppSettings.h"
#import "Utils.h"
#import "PluginsWindowController.h"
#import "MWPluginInterface.h"

@interface AppDelegate () {
    AppSettings *_appSettings;
    PluginsManager *_pluginsManager;
    NSWindowController *_aboutWindowController;
    PluginsWindowController *_pluginsWindowController;
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

    _pluginsManager = [[PluginsManager alloc] initWithAppSettings:_appSettings];
    [_pluginsManager loadPlugins];
    [_pluginsManager startPlugins];

    // Build the plugins menus
    int menuIndex = 0;
    NSArray<Plugin *> *plugins = [_pluginsManager pluginsList];
    for (Plugin *plugin in plugins) {
        NSMenuItem *menuItem = [plugin.instance menuItem];
        if (menuItem) {
            [statusMenu insertItem:menuItem atIndex:menuIndex++];
        }
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
    if (!_pluginsWindowController) {
        _pluginsWindowController = [[PluginsWindowController alloc] initWithWindowNibName:@"PluginsWindow"];
    }
    [_pluginsWindowController showWindow:[_pluginsWindowController window]];
    [_pluginsWindowController setPluginsList:_pluginsManager.pluginsList];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [_pluginsManager stopPlugins];
}

@end
