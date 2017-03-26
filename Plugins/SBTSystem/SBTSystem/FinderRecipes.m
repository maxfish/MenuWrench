//
//  FinderRecipes.m
//  SBTSystemPlugin
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import "FinderRecipes.h"

@implementation FinderRecipes

+ (void)cleanOpenWithAssociations:(id)sender {
    //  /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain user;killall Finder;
    NSArray *arguments = @[@"-kill", @"-r", @"-domain", @"local", @"-domain", @"user"];
    NSTask *task = [NSTask launchedTaskWithLaunchPath:@"/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister" arguments:arguments];
    [task waitUntilExit];

    // Restarts finder
    [[NSTask launchedTaskWithLaunchPath:@"/usr/bin/killall" arguments:@[@"Finder"]] waitUntilExit];
}

+ (BOOL)showHiddenFiles {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dockDict = [defaults persistentDomainForName:@"com.apple.finder"];
    return [[dockDict valueForKey:@"AppleShowAllFiles"] boolValue];
}

+ (void)setShowHiddenFiles:(BOOL)show {
    CFPreferencesSetAppValue(CFSTR("AppleShowAllFiles"), show ? kCFBooleanTrue : kCFBooleanFalse, CFSTR("com.apple.finder"));
    CFPreferencesAppSynchronize(CFSTR("com.apple.finder"));
    // Restarts finder
    [[NSTask launchedTaskWithLaunchPath:@"/usr/bin/killall" arguments:@[@"Finder"]] waitUntilExit];
}

#pragma mark - Desktop icons

+ (BOOL)showDesktopIcons {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dockDict = [defaults persistentDomainForName:@"com.apple.finder"];
    return [[dockDict valueForKey:@"CreateDesktop"] boolValue];
}

+ (void)setShowDesktopIcons:(BOOL)show {
    CFPreferencesSetAppValue(CFSTR("CreateDesktop"), show ? kCFBooleanTrue : kCFBooleanFalse, CFSTR("com.apple.finder"));
    CFPreferencesAppSynchronize(CFSTR("com.apple.finder"));
    // Restarts finder
    [[NSTask launchedTaskWithLaunchPath:@"/usr/bin/killall" arguments:@[@"Finder"]] waitUntilExit];
}


#pragma mark - Screen saver

+ (void)showLoginScreen {
    NSArray *arguments = @[@"-suspend"];
    NSTask *task = [[NSTask alloc] init];
    [task setArguments:arguments];
    [task setLaunchPath:@"/System/Library/CoreServices/Menu Extras/user.menu/Contents/Resources/CGSession"];
    [task launch];
}

- (void)showScreenSaver {
//    [Utils runAppleScript:@"tell application \"System Events\" to start current screen saver"];
}

@end