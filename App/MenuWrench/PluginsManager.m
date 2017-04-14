//
//  PluginsManager.m
//  MenuWrench
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import "PluginsManager.h"
#import "AppSettings.h"
#import "Utils.h"
#import "MWPluginInterface.h"

#define DEBUG_ENABLED NO

@implementation PluginsManager {
    AppSettings *_appSettings;
    NSMutableArray<Plugin *> *_plugins;
}

- (instancetype)initWithAppSettings:(AppSettings *)appSettings {
    self = [super init];
    if (self) {
        _appSettings = appSettings;
        _plugins = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadPlugins {
    NSString *pluginFolder = [NSString stringWithFormat:@"%@/plugins", _appSettings.settingsPath];
    NSArray *pluginNames = [Utils filesWithinFolder:pluginFolder withExtension:@"plugin"];
    for (NSString *pluginName in pluginNames) {
        @try {
            NSString *pluginPath = [NSString stringWithFormat:@"%@/%@", pluginFolder, pluginName];
            NSBundle *bundle = [NSBundle bundleWithPath:pluginPath];
            Plugin *plugin = [[Plugin alloc] initWithBundle:bundle];
            [_plugins addObject:plugin];
        } @catch (NSException *e) {
            NSLog(@"Couldn't load plugin '%@'", pluginName);
        }
    }

    NSLog(@"%d plugin[s] loaded.", (int) _plugins.count);
}

- (void)startPlugins {
    NSDictionary *appInfo = @{
            kAppInfoConfigPath: _appSettings.settingsPath,
            kAppInfoDebugEnabled: @(DEBUG_ENABLED)
    };

    for (Plugin *plugin in _plugins) {
        [plugin.instance startWithInfo:appInfo];
    }
}

- (void)stopPlugins {
    for (Plugin *plugin in _plugins) {
        [plugin.instance stop];
    }
}

- (NSArray<Plugin *> *)pluginsList {
    return _plugins;
}

@end
