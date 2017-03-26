//
//  FinderRecipes.h
//  SBTSystemPlugin
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#ifndef FinderRecipes_h
#define FinderRecipes_h

#import <Cocoa/Cocoa.h>

@interface FinderRecipes : NSObject

+ (void)cleanOpenWithAssociations:(id)sender;

+ (void)setShowHiddenFiles:(BOOL)show;

+ (BOOL)showHiddenFiles;

+ (BOOL)showDesktopIcons;

+ (void)setShowDesktopIcons:(BOOL)show;

@end

#endif