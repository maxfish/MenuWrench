//
//  MWPluginInterface.h
//  MenuWrench
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#ifndef MWPluginInterface_h
#define MWPluginInterface_h

#import <Cocoa/Cocoa.h>

NSString *const kBundlePluginName = @"PluginNameString";
NSString *const kAppInfoConfigPath = @"AppConfigPath";
NSString *const kAppInfoDebugEnabled = @"AppDebugEnabled";

#pragma -

@protocol MWPluginInterface

- (BOOL)startWithInfo:(NSDictionary *)appInfo;

- (void)stop;

@property(NS_NONATOMIC_IOSONLY, readonly, copy) NSMenuItem *menuItem;

@end

#endif