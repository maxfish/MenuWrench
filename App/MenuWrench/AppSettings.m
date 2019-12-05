//
//  AppSettings.m
//  MenuWrench
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import "AppSettings.h"
#import "Utils.h"


#define CONFIG_FILE_NAME @"config.plist"
#define kStartAtLoginKey @"startAtLogin"
#define kAppDataPath @"MenuWrench"

@implementation AppSettings {
}

- (void)loadFromFile {
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:self._configFilePath];
    if (plist) {
        self.startAtLogin = [plist[kStartAtLoginKey] boolValue];
    }
}

- (void)saveToFile {
    [@{kStartAtLoginKey: @(_startAtLogin),} writeToFile:self._configFilePath atomically:YES];
}

- (NSString *)settingsPathForModule:(NSString *)moduleName {
    NSString *settingsPath = [NSString stringWithFormat:@"%@/%@", self.settingsPath, moduleName];

    if (![Utils doesFolderExistAtPath:settingsPath]) {
        [Utils createFolderAtPath:settingsPath];
    }
    return settingsPath;
}

- (NSString *)settingsPath {
    NSString *settingsPath = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), kAppDataPath];

    if (![Utils doesFolderExistAtPath:settingsPath]) {
        bool success = [Utils createFolderAtPath:settingsPath];
        NSLog(@"Settings path created -> %d", success);
    }
    NSLog(@"Settings path '%@'", settingsPath);
    return settingsPath;
}

- (NSString *)_configFilePath {
    return [NSString stringWithFormat:@"%@/%@", [self settingsPath], CONFIG_FILE_NAME];
}

@end
