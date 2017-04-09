//
//  TaskCellView.m
//  ToDo
//
//  Created by Massimiliano Pesce on 4/1/15.
//  Copyright (c) 2015 Massimiliano Pesce. All rights reserved.
//

#import "PluginCellView.h"

@implementation PluginCellView {
    IBOutlet NSButton *_enabledCheck;
    IBOutlet NSTextField *_nameLabel;
    IBOutlet NSTextField *_descriptionLabel;
}

+ (void)initialize {
}

- (void)setupWithPluginId:(NSString *)pluginId {
    [_nameLabel setStringValue:@"AAAA"];
}

@end
