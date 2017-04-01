//
//  PluginManager.h
//  MenuWrench
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppSettings;

@interface PluginManager : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithAppSettings:(AppSettings *)appSettings NS_DESIGNATED_INITIALIZER;

- (void)loadPlugins;

- (void)startPlugins;

- (void)stopPlugins;

@property(NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *menuItems;

@end