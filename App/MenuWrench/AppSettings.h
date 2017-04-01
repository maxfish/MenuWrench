//
//  AppSettings.h
//  MenuWrench
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject

@property(assign) BOOL startAtLogin;

- (void)loadFromFile;

- (void)saveToFile;

- (NSString *)settingsPathForModule:(NSString *)moduleName;

@property(NS_NONATOMIC_IOSONLY, readonly, copy) NSString *settingsPath;

@end