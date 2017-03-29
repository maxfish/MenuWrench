//
//  SBTTextInflaterPlugin.m
//  Text Inflater Plugin
//
//  Created by maxfish on 29/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SBTTextInflaterPlugin.h"
#import "Trie.h"
#import "Snippet.h"


// some common key codes
NSUInteger const kKeyCode_V = ((CGKeyCode) 9);
NSUInteger const kKeyCode_G = ((CGKeyCode) 0x05);
NSUInteger const kKeyCode_Backspace = ((CGKeyCode) 0x33);

NSString *const kTextExpanderSnippetsFileExtension = @"snippets.plist";
NSString *const kTextExpanderSnippetsSectionName = @"snippets";
NSString *const kConfigEnabledKey = @"enable";

@interface SBTTextInflaterPlugin ()
@property(nonatomic) BOOL enabled;
@property(nonatomic) BOOL debugEnabled;
@property(strong, nonatomic) NSMenuItem *menuItem;
@property(strong, nonatomic) NSMenu *submenu;

@property(strong, nonatomic) NSDictionary *appInfo;
@property(strong, nonatomic) NSMutableDictionary *pluginConfig;

@property(readonly) NSString *configFile;
@property(readonly) NSString *absoluteConfigPath;

@property(strong, nonatomic) NSMutableArray *snippetsList;
@property(strong, nonatomic) NSMutableDictionary *snippetForAbbreviation;
@end

@implementation SBTTextInflaterPlugin {
    id _keyMonitorId;
    Trie *_trie;
    NSMutableString *_textCapturedSoFar;
    NSMenuItem *_itemEnableSwitch;
}

- (id)init {
    self = [super init];
    if (self) {
        self.pluginConfig = [[NSMutableDictionary alloc] init];
        _trie = [[Trie alloc] init];
        _textCapturedSoFar = [[NSMutableString alloc] init];
        _keyMonitorId = nil;

        // Default values
        self.pluginConfig[kConfigEnabledKey] = @(YES);

        [self _createMenuItem];
    }

    return self;
}

- (BOOL)startWithInfo:(NSDictionary *)appInfo {
    self.appInfo = appInfo;
    [self loadConfig];
    [self _loadSnippetFiles];

    self.debugEnabled = [appInfo[kAppInfoDebugEnabled] boolValue];

    if (self.enabled && !_keyMonitorId) {
        [self _startKeyEventsHandler];
    }

    return YES;
}

- (void)stop {
    [self _stopKeyEventsHandler];
}

- (NSMenuItem *)menuItem {
    return _menuItem;
}

#pragma - Properties

- (NSString *)configFile {
    return [NSString stringWithFormat:@"%@/%@", self.absoluteConfigPath, @"config.plist"];
}

- (NSString *)absoluteConfigPath {
    NSString *pluginName = [[NSBundle bundleForClass:self.class] objectForInfoDictionaryKey:kBundlePluginName];
    return [NSString stringWithFormat:@"%@/%@", self.appInfo[kAppInfoConfigPath], pluginName];
}

#pragma - Private methods

- (void)_createMenuItem {
    NSString *pluginName = [[NSBundle bundleForClass:self.class] objectForInfoDictionaryKey:kBundlePluginName];
    self.menuItem = [[NSMenuItem alloc] initWithTitle:pluginName action:nil keyEquivalent:@""];
    self.submenu = [[NSMenu alloc] init];
    [self.menuItem setEnabled:YES];
    _itemEnableSwitch = [self.submenu addItemWithTitle:@"Enabled" action:@selector(_toggleEnabled:) keyEquivalent:@""];
    [_itemEnableSwitch setTarget:self];
    [_itemEnableSwitch setState:self.enabled];

    [self.submenu addItem:[NSMenuItem separatorItem]];
    [self.menuItem setSubmenu:self.submenu];
}

- (BOOL)enabled {
    return [_pluginConfig[kConfigEnabledKey] boolValue];
}

- (void)setEnabled:(BOOL)newState {
    _pluginConfig[kConfigEnabledKey] = @(newState);
    [self saveConfig];
    [_itemEnableSwitch setState:self.enabled ? NSOnState : NSOffState];
}

- (NSDictionary *)loadConfig {
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:self.configFile];
    if (plist) {
        [_pluginConfig setValuesForKeysWithDictionary:plist];
    }
    [_itemEnableSwitch setState:self.enabled ? NSOnState : NSOffState];

    return plist;
}

- (void)saveConfig {
    [_pluginConfig writeToFile:self.configFile atomically:YES];
}

- (void)_toggleEnabled:(id)sender {
    if (self.enabled) {
        [self _stopKeyEventsHandler];
        self.enabled = NO;
    } else {
        [self _startKeyEventsHandler];
    }
}

- (void)_startKeyEventsHandler {
    NSDictionary *options = @{(__bridge id) kAXTrustedCheckOptionPrompt: @YES};
    BOOL accessibilityEnabled = AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef) options);

    if (!accessibilityEnabled) {
        [self _stopKeyEventsHandler];
        [self setEnabled:NO];
        return;
    }
    [self setEnabled:YES];

    [_textCapturedSoFar setString:@""];
    NSEventMask mask = NSKeyUpMask;

    _keyMonitorId = [self _monitorEveryEvent:mask handler:^(NSEvent *event) {
        if (self.debugEnabled) {
            NSLog(@"----> EVENT %@", event.description);
        }

        if (self.enabled) {
            TrieNode *node;

            [_textCapturedSoFar appendString:event.characters];
            node = [_trie nodeForLongestPrefixOF:_textCapturedSoFar];
            if (node != nil) {
                if ([node isLeaf]) {
                    [self _removeTextFromTheInput:_textCapturedSoFar];
                    Snippet *snippet = ((Snippet *) self.snippetForAbbreviation[_textCapturedSoFar]);
                    [self _pasteSnippet:snippet];
                    [_textCapturedSoFar setString:@""];
                }
            } else {
                // Try to preserve the last character that brake the previous sequence
                if (_textCapturedSoFar.length > 1) {
                    [_textCapturedSoFar setString:event.characters];
                    node = [_trie nodeForLongestPrefixOF:_textCapturedSoFar];
                    if (node == nil) {
                        [_textCapturedSoFar setString:@""];
                    }
                } else {
                    [_textCapturedSoFar setString:@""];
                }
            }
        }
    }];

    if (self.debugEnabled) {
        NSLog(@"----> Started key monitor: %@", _keyMonitorId);
    }
}

- (void)_stopKeyEventsHandler {
    if (_keyMonitorId) {
        [self _removeEventMonitor:_keyMonitorId];
        _keyMonitorId = nil;
    }
}

- (void)_removeTextFromTheInput:(NSString *)text {
    for (int i = 0; i < text.length; i++) {
        // Deletes user input
        [self simulateKeyPress:kKeyCode_Backspace flags:0 string:nil];
    }
}

- (void)_pasteSnippet:(Snippet *)snippet {
    if (snippet.rtf || snippet.html) {
        [[NSPasteboard generalPasteboard] clearContents];
        [[NSPasteboard generalPasteboard] setData:[snippet.text dataUsingEncoding:NSUTF8StringEncoding] forType:NSPasteboardTypeString];

        if (snippet.rtf) {
            [[NSPasteboard generalPasteboard] setData:snippet.rtf forType:NSPasteboardTypeRTF];
        }
        if (snippet.html) {
            [[NSPasteboard generalPasteboard] setData:snippet.html forType:NSPasteboardTypeHTML];
        }

        [self simulateKeyPress:kKeyCode_V flags:kCGEventFlagMaskCommand string:@""];
    } else {
        [self _injectAbbreviationTextAsInput:snippet.text];
    }
}

- (void)_injectAbbreviationTextAsInput:(NSString *)abbreviationText {
    NSString *stringToSend = [self _replaceMacrosInText:abbreviationText];

    while (stringToSend.length > 0) {
        NSString *piece = [stringToSend substringToIndex:MIN(16, stringToSend.length)];
        stringToSend = [stringToSend substringFromIndex:MIN(16, stringToSend.length)];
        [self simulateKeyPress:kKeyCode_G flags:0 string:piece];
    }
}

- (void)_loadSnippetFiles {
    NSArray *filesList = [self filesWithinFolder:self.absoluteConfigPath withExtension:kTextExpanderSnippetsFileExtension];
    self.snippetForAbbreviation = [NSMutableDictionary dictionary];
    self.snippetsList = [NSMutableArray array];

    for (NSString *fileName in filesList) {
        // Load snippet file
        NSDictionary *plistContents = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", self.absoluteConfigPath, fileName]];
        NSString *prefix = plistContents[@"prefix"] ? plistContents[@"prefix"] : @"";
        NSString *suffix = plistContents[@"suffix"] ? plistContents[@"suffix"] : @"";

        // Load snippets
        NSMutableArray *snippets = [NSMutableArray array];
        for (NSDictionary *dict in plistContents[kTextExpanderSnippetsSectionName]) {
            Snippet *snippet = [[Snippet alloc] initWithDictionary:dict prefix:prefix suffix:suffix];
            [snippets addObject:snippet];

            [self.snippetForAbbreviation setValue:snippet forKey:snippet.fullAbbreviation];
            [_trie insertString:snippet.fullAbbreviation withData:snippet];
        }
        [self.snippetsList addObjectsFromArray:snippets];

        if (self.debugEnabled) {
            NSLog(@"TextExpander: '%@' => loaded %lu abbreviations", fileName, (unsigned long) snippets.count);
        }

        // Create menu entries
        NSString *menuTitle = [NSString stringWithFormat:@"%@ [%lu]", [fileName stringByReplacingOccurrencesOfString:@".snippets.plist" withString:@""], (unsigned long) snippets.count];
        NSMenuItem *item = [self addMenuItemWithTitle:menuTitle toMenu:self.submenu target:self action:nil];

        // SubMenu with snippets listing
        NSMenu *subMenu = [[NSMenu alloc] init];
        [item setSubmenu:subMenu];

        // Open-snippets file menu item
        NSMenuItem *openSnippetsItem = [self addMenuItemWithTitle:@"Open snippets file" toMenu:subMenu target:self action:@selector(_openSnippetsFile:)];
        openSnippetsItem.representedObject = fileName;
        [subMenu addItem:[NSMenuItem separatorItem]];

        // Info
        [self addMenuItemWithTitle:[NSString stringWithFormat:@"prefix '%@', suffix '%@'", prefix, suffix] toMenu:subMenu target:self action:nil];
        [subMenu addItem:[NSMenuItem separatorItem]];

        // Snippets
        for (Snippet *snippet in snippets) {
            [self addMenuItemWithTitle:[NSString stringWithFormat:@"%@ -> %@", snippet.fullAbbreviation, snippet.label] toMenu:subMenu target:self action:nil];
        }
    }
}

- (void)_openSnippetsFile:(id)sender {
    NSMenuItem *senderItem = (NSMenuItem *) sender;
    NSString *file = [NSString stringWithFormat:@"%@/%@", self.absoluteConfigPath, (NSString *) senderItem.representedObject];
    NSURL *url = [NSURL fileURLWithPath:file isDirectory:NO];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (NSString *)_replaceMacrosInText:(NSString *)text {
    // TODO
    return text;
}

- (id)_monitorEveryEvent:(NSEventMask)eventMask handler:(void (^)(NSEvent *event))block {
    return [NSEvent addGlobalMonitorForEventsMatchingMask:eventMask handler:block];
}

- (void)_removeEventMonitor:(id)monitor {
    [NSEvent removeMonitor:monitor];
}

#pragma - Files and folders

- (NSArray *)filesWithinFolder:(NSString *)folderPath withExtension:(NSString *)extension {
    NSError *error = nil;
    NSArray *filesList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error];

    if (filesList == nil) {
        NSLog(@"%@", [error localizedDescription]);
        return @[];
    }

    NSString *predicate = [NSString stringWithFormat:@"self ENDSWITH '.%@'", extension];
    return [filesList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicate]];
}

#pragma - Keyboard

- (void)simulateKeyPress:(CGKeyCode)key flags:(CGEventFlags)flags string:(NSString *)string {
    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStatePrivate);

    CGEventRef keyDown = CGEventCreateKeyboardEvent(source, key, TRUE);
    if (flags != 0) {
        CGEventSetFlags(keyDown, flags);
    }
    if (string) {
        CGEventKeyboardSetUnicodeString(keyDown, string.length, (const UniChar *) [string cStringUsingEncoding:NSUnicodeStringEncoding]);
    }
    CGEventPost(kCGHIDEventTap, keyDown);

    CGEventRef keyUp = CGEventCreateKeyboardEvent(source, key, FALSE);
    if (flags != 0) {
        CGEventSetFlags(keyUp, flags);
    }
    CGEventPost(kCGHIDEventTap, keyUp);

    CFRelease(keyUp);
    CFRelease(keyDown);
    CFRelease(source);
}

#pragma - Menu

- (NSMenuItem *)addMenuItemWithTitle:(NSString *)title toMenu:(NSMenu *)menu target:(id)target action:(SEL)selector {
    NSMenuItem *s1 = [menu addItemWithTitle:title action:selector keyEquivalent:@""];
    [s1 setEnabled:YES];
    [s1 setTarget:target];
    return s1;
}

@end