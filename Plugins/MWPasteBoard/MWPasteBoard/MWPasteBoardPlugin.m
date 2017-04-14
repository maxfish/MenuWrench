//
//  MWPasteBoardPlugin.m
//  PasteBoard Plugin
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

@import Cocoa;

#import "MWPasteBoardPlugin.h"
#import "PasteBoard_MenuItem.h"


NSString *const kConfigEnabledKey = @"enable";
NSUInteger const kMaxNumClips = 3;
NSUInteger const kNumMenuItems = 4;


@interface MWPasteBoardPlugin ()
@property(nonatomic) BOOL enabled;
@end

@implementation MWPasteBoardPlugin {
    NSDictionary *_appInfo;
    BOOL _debugEnabled;
    NSMutableDictionary *_pluginConfig;

    long _pasteBoardChangeCount;
    PasteBoard_Clip *_lastCopiedClip;
    BOOL _canCopy;

    NSMenuItem *_menuItem;
    NSMenu *_submenu;
    NSMenuItem *_itemEnableSwitch;
}

- (id)init {
    self = [super init];
    if (self) {
        _pluginConfig = [[NSMutableDictionary alloc] init];

        // Default values
        _pluginConfig[kConfigEnabledKey] = @(YES);
    }

    return self;
}

- (BOOL)startWithInfo:(NSDictionary *)appInfo {
    _appInfo = appInfo;
    [self loadConfig];

    _debugEnabled = [appInfo[kAppInfoDebugEnabled] boolValue];

    _pasteBoardChangeCount = [[NSPasteboard generalPasteboard] changeCount];
    [NSTimer scheduledTimerWithTimeInterval:0.30 target:self selector:@selector(_checkPasteBoard) userInfo:nil repeats:YES];

    return YES;
}

- (void)stop {

}

- (void)_createMenuItem {
    NSString *pluginName = [[NSBundle bundleForClass:self.class] objectForInfoDictionaryKey:kBundlePluginName];
    _menuItem = [[NSMenuItem alloc] initWithTitle:pluginName action:nil keyEquivalent:@""];
    _submenu = [[NSMenu alloc] init];
    [self.menuItem setEnabled:YES];

    _itemEnableSwitch = [_submenu addItemWithTitle:@"Enabled" action:@selector(_toggleEnabled:) keyEquivalent:@""];
    [_itemEnableSwitch setTarget:self];
    [_itemEnableSwitch setState:self.enabled];

    [_submenu addItem:[NSMenuItem separatorItem]];

    NSMenuItem *clearHistory = [_submenu addItemWithTitle:@"Clear history" action:@selector(clearAll:) keyEquivalent:@""];
    [clearHistory setTarget:self];

    [_submenu addItem:[NSMenuItem separatorItem]];
    [self.menuItem setSubmenu:_submenu];
}

- (NSMenuItem *)menuItem {
    if (!_menuItem) {
        [self _createMenuItem];
    }

    return _menuItem;
}

- (void)requirePasteContent:(PasteBoard_Clip *)item {
    [self _copyItemPasteBoard:item];
    [self _pasteCurrentContentToApp];
}

#pragma - properties

- (BOOL)enabled {
    return [_pluginConfig[kConfigEnabledKey] boolValue];
}

- (void)setEnabled:(BOOL)newState {
    _pluginConfig[kConfigEnabledKey] = @(newState);
    [self saveConfig];
    [_itemEnableSwitch setState:newState ? NSOnState : NSOffState];
}

- (void)_toggleEnabled:(id)sender {
    [self setEnabled:!self.enabled];
}

#pragma - Private methods

- (NSDictionary *)loadConfig {
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:self.configFile];
    if (plist) {
        [_pluginConfig setValuesForKeysWithDictionary:plist];
    }
    [_itemEnableSwitch setState:self.enabled ? NSOnState : NSOffState];

    return plist;
}

- (void)saveConfig {
    if (_debugEnabled) {
        NSLog(@"Saving config to '%@'", self.configFile);
    }
    [_pluginConfig writeToFile:self.configFile atomically:YES];
}

- (NSString *)configFile {
    return [NSString stringWithFormat:@"%@/%@", self._absoluteConfigPath, @"config.plist"];
}

- (NSString *)_absoluteConfigPath {
    NSString *pluginName = [[NSBundle bundleForClass:self.class] objectForInfoDictionaryKey:kBundlePluginName];
    return [NSString stringWithFormat:@"%@/%@", _appInfo[kAppInfoConfigPath], pluginName];
}

- (void)_checkPasteBoard {
    if (![self _pasteboardHasChanged] || !self.enabled) {
        return;
    }

    PasteBoard_Clip *newClip = [[PasteBoard_Clip alloc] initWithPasteBoardContent];

    if (newClip) {
        // Copies only if CMD+C has been pressed twice for the same content
        if (_lastCopiedClip && [newClip isEqualToClip:_lastCopiedClip]) {
            if (_canCopy) {
                _canCopy = NO;
                if (_debugEnabled) {
                    NSLog(@"Pasteboard content => '%@'", [newClip displayString]);
                }
                PasteBoard_MenuItem *item = [[PasteBoard_MenuItem alloc] initWithContent:newClip image:nil module:self];
                long numItems = [self.menuItem.submenu.itemArray count] - kNumMenuItems;
                if (numItems >= kMaxNumClips) {
                    [self.menuItem.submenu removeItemAtIndex:[self.menuItem.submenu.itemArray count] - 1];
                }
                [self.menuItem.submenu insertItem:item atIndex:kNumMenuItems];
            }
        } else {
            _lastCopiedClip = newClip;
            _canCopy = YES;
        }
    }
}

- (void)_copyItemPasteBoard:(PasteBoard_Clip *)item {
    __unused NSInteger changeCount = [[NSPasteboard generalPasteboard] clearContents];
    [item copyToPasteBoard];
}

- (void)_pasteCurrentContentToApp {
    const NSUInteger kKeyCode_V = ((CGKeyCode) 9);
    const CGEventFlags flags = kCGEventFlagMaskCommand;

    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStatePrivate);

    CGEventRef keyDown = CGEventCreateKeyboardEvent(source, kKeyCode_V, TRUE);
    CGEventSetFlags(keyDown, flags);
    CGEventPost(kCGHIDEventTap, keyDown);

    CGEventRef keyUp = CGEventCreateKeyboardEvent(source, kKeyCode_V, FALSE);
    CGEventSetFlags(keyUp, flags);
    CGEventPost(kCGHIDEventTap, keyUp);

    CFRelease(keyUp);
    CFRelease(keyDown);
    CFRelease(source);
}

- (BOOL)_pasteboardHasChanged {
    long changeCount = [[NSPasteboard generalPasteboard] changeCount];
    if (changeCount <= _pasteBoardChangeCount)
        return NO;

    //    NSLog(@"PASTEBOARD CHANGED %i", changeCount);
    _pasteBoardChangeCount = changeCount;
    return YES;
}

- (IBAction)clearAll:(id)sender {
    long count = self.menuItem.submenu.itemArray.count - kNumMenuItems;
    for (int i = 0; i < count; i++) {
        [self.menuItem.submenu removeItemAtIndex:kNumMenuItems];
    }
}

@end