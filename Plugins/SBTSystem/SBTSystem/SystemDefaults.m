//
//  SystemDefaults.m
//  SBTSystemPlugin
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import "SystemDefaults.h"

@implementation SystemDefaults

- (instancetype)init {
    self = [super init];
    if (self) {
        _settings = @[
                // setting_id: [label, domain, key, values[], extra_task[]]
                @[
                        @"Show hidden files", @"com.apple.finder", @"AppleShowAllFiles", @[@"YES", @"NO"], @[@"/usr/bin/killall", @"Finder"]
                ],
                @[
                        @"Hide desktop icons", @"com.apple.finder", @"CreateDesktop", @[@"NO", @"YES"], @[@"/usr/bin/killall", @"Finder"]
                ],
                @[
                        @"Show expanded save dialog", @"NSGlobalDomain", @"NSNavPanelExpandedStateForSaveMode", @[@"YES", @"NO"], [NSNull null]
                ],
                @[
                        @"Disable Dashboard", @"com.apple.dashboard", @"mcx-disabled", @[@"NO", @"YES"], @[@"/usr/bin/killall", @"Dock"]
                ],
                @[
                        @"Don't write .DS_Store on network drives", @"com.apple.desktopservices", @"DSDontWriteNetworkStores", @[@"NO", @"YES"], [NSNull null]
                ],
                @[
                        @"Crash reporter as notification", @"com.apple.CrashReporter", @"UseUNC", @[@"1", @"0"], [NSNull null]
                ],
                @[
                        @"Disable confirmation dialog for opening downloaded apps", @"com.apple.LaunchServices", @"LSQuarantine", @[@"NO", @"YES"], @[@"/usr/bin/killall", @"Finder"]
                ]
        ];
    }

    return self;
}

- (BOOL)statusOf:(NSUInteger)setting_index {
    NSArray *data = _settings[setting_index];
    NSDictionary *dockDict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:data[1]];
    return [[dockDict valueForKey:data[2]] isEqualTo:data[3][0]];
}

- (void)setDefault:(NSUInteger)setting_id to:(BOOL)value {
    NSArray *data = _settings[setting_id];
    NSString *valueStr = value ? data[3][0] : data[3][1];
    [[NSTask launchedTaskWithLaunchPath:@"/usr/bin/defaults" arguments:@[@"write", data[1], data[2], valueStr]] waitUntilExit];
    if (data[4] != [NSNull null]) {
        [[NSTask launchedTaskWithLaunchPath:data[4][0] arguments:@[data[4][1]]] waitUntilExit];
    }
}

@end