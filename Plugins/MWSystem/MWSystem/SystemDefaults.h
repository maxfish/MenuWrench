//
//  SystemDefaults.h
//  MWSystemPlugin
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#ifndef FinderRecipes_h
#define FinderRecipes_h

#import <Cocoa/Cocoa.h>

@interface SystemDefaults : NSObject

@property(readonly) NSArray *settings;

- (BOOL)statusOf:(NSUInteger)setting_id;

- (void)setDefault:(NSUInteger)setting_id to:(BOOL)value;

@end

#endif