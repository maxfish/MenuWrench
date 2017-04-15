//
//  TaskCellView.m
//  ToDo
//
//  Created by Massimiliano Pesce on 4/1/15.
//  Copyright (c) 2015 Massimiliano Pesce. All rights reserved.
//

#import "PluginCellView.h"
#import "Plugin.h"

@implementation PluginCellView {
    IBOutlet NSButton *_enabledCheck;
    IBOutlet NSTextField *_nameLabel;
    IBOutlet NSTextField *_descriptionLabel;
}

+ (void)initialize {
}

- (void)setupWithPlugin:(Plugin *)plugin {
    [_nameLabel setStringValue:plugin.name];
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ - v.%@", plugin.description, plugin.version];
    [_descriptionLabel setStringValue:descriptionString];
}

@end
