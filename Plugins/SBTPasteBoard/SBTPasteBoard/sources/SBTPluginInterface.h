//
//  SBTPluginInterface.h
//  StatusBarTool
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#ifndef StatusBarApp_PluginInterface_h
#define StatusBarApp_PluginInterface_h

#define kBundlePluginName @"PluginNameString"
#define kAppInfoConfigPath @"AppConfigPath"
#define kAppInfoDebugEnabled @"AppDebugEnabled"

#pragma -

@protocol SBTPluginInterface

- (BOOL)startWithInfo:(NSDictionary *)appInfo;

- (void)stop;

@property(nonatomic, readonly, copy) NSMenuItem *menuItem;

@end

#endif