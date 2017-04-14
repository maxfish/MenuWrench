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

#define kBundlePluginName @"PluginNameString"
#define kAppInfoConfigPath @"AppConfigPath"
#define kAppInfoDebugEnabled @"AppDebugEnabled"

#pragma -

@protocol MWPluginInterface

- (BOOL)startWithInfo:(NSDictionary *)appInfo;

- (void)stop;

@property(readonly, copy) NSMenuItem *menuItem;

@end

#endif
