//
//  PluginManager.m
//  MenuWrench
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import "PluginManager.h"
#import "AppSettings.h"
#import "Utils.h"
#import "MWPluginInterface.h"

#define DEBUG_ENABLED NO

@implementation PluginManager {
    AppSettings *_appSettings;
    NSMutableArray *_pluginBundles;
    NSMutableArray *_pluginInstances;
}

- (instancetype)initWithAppSettings:(AppSettings *)appSettings {
    self = [super init];
    if (self) {
        _appSettings = appSettings;
        _pluginBundles = [[NSMutableArray alloc] init];
        _pluginInstances = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadPlugins {
    NSString *pluginFolder = [NSString stringWithFormat:@"%@/plugins", _appSettings.settingsPath];

    NSArray *pluginNames = [Utils filesWithinFolder:pluginFolder withExtension:@"plugin"];
    for (NSString *pluginName in pluginNames) {
        NSString *pluginPath = [NSString stringWithFormat:@"%@/%@", pluginFolder, pluginName];
        NSBundle *myBundle = [NSBundle bundleWithPath:pluginPath];
        [_pluginBundles addObject:myBundle.principalClass];
    }

    NSLog(@"%d plugin[s] found.", (int) _pluginBundles.count);

    // Create instances of the main classes
    for (Class M in _pluginBundles) {
        NSObject <MWPluginInterface> *pluginInstance = [(NSObject <MWPluginInterface> *) [M alloc] init];
        [_pluginInstances addObject:pluginInstance];
    }
}

- (void)startPlugins {
    NSDictionary *appInfo = @{
            kAppInfoConfigPath: _appSettings.settingsPath,
            kAppInfoDebugEnabled: @(DEBUG_ENABLED)
    };

    for (NSObject <MWPluginInterface> *plugin in _pluginInstances) {
        [plugin startWithInfo:appInfo];
    }
}

- (void)stopPlugins {
    for (NSObject <MWPluginInterface> *plugin in _pluginInstances) {
        [plugin stop];
    }
}

- (NSArray *)menuItems {
    NSMutableArray *menuItems = [NSMutableArray array];
    for (NSObject <MWPluginInterface> *plugin in _pluginInstances) {
        NSMenuItem *menuItem = [plugin menuItem];
        if (menuItem) {
            [menuItems addObject:menuItem];
        }
    }
    return menuItems;
}

@end