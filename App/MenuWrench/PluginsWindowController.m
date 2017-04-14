//
// Created by Massimiliano Pesce on 3/28/15.
// Copyright (c) 2015 Massimiliano Pesce. All rights reserved.
//

#import "PluginsWindowController.h"
#import "PluginCellView.h"
#import "PluginsManager.h"


@implementation PluginsWindowController {
    NSArray<Plugin *> *_pluginsList;
}

- (instancetype)initWithWindowNibName:(NSString *)windowNibName {
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
    }

    return self;
}

- (void)setPluginsList:(NSArray<Plugin *> *)pluginsList {
    _pluginsList = pluginsList;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _pluginsList.count;
}

- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView {
    return NO;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return [tableView rowHeight];
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {

    PluginCellView *cell = [tableView makeViewWithIdentifier:@"PluginCellView" owner:self];
    [cell setupWithPlugin:_pluginsList[row]];

    return cell;
}


@end
