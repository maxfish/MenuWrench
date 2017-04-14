//
//  SBTPluginInterface.h
//  StatusBarTool
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#ifndef StatusBarApp_PluginInterface_h
#define StatusBarApp_PluginInterface_h

#import <Cocoa/Cocoa.h>

NSString *const kBundlePluginName = @"PluginNameString";
NSString *const kAppInfoConfigPath = @"AppConfigPath";
NSString *const kAppInfoDebugEnabled = @"AppDebugEnabled";

#pragma -

@protocol SBTPluginInterface

- (BOOL)startWithInfo:(NSDictionary *)appInfo;

- (void)stop;

@property(NS_NONATOMIC_IOSONLY, readonly, copy) NSMenuItem *menuItem;

@end

#endif
