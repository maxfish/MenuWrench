//
//  Plugin.h
//  MenuWrench
//
//  Created by maxfish on 14/04/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppSettings;
@protocol MWPluginInterface;

@interface Plugin : NSObject

- (instancetype)initWithBundle:(NSBundle *)bundle;

- (NSBundle *)bundle;

- (NSObject <MWPluginInterface> *)instance;

- (BOOL)isEnabled;

@end