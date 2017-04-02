//
//  Utils.h
//  MenuWrench
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface Utils : NSObject

#pragma mark - Login item

+ (void)addAppToStartupItems;

+ (void)removeAppFromStartupItems;

+ (void)toggleLoginItem:(BOOL)toggle;

#pragma mark - Files

+ (NSArray *)filesWithinFolder:(NSString *)folderPath withExtension:(NSString *)extension;

+ (NSString *)dropboxFolder;

+ (BOOL)doesFolderExistAtPath:(NSString *)path;

+ (BOOL)createFolderAtPath:(NSString *)path;

@end
