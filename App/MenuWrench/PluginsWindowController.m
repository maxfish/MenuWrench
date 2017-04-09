//
// Created by Massimiliano Pesce on 3/28/15.
// Copyright (c) 2015 Massimiliano Pesce. All rights reserved.
//

#import "PluginsWindowController.h"
#import "PluginCellView.h"


@implementation PluginsWindowController {
    NSMutableArray *_list;
    IBOutlet NSTableView *_tableView;
}

- (instancetype)initWithWindowNibName:(NSString *)windowNibName {
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        _list = [[NSMutableArray alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }

    return self;
}

- (void)_populateTableList {
//    [_list addObject:@"Today"];
//    [_list addObject:@"Ahhhh"];
//    [_list addObject:@"asdrqwerqw"];
//    [_list addObject:@"asdrqwerqw"];
//    [_list addObject:@"asdrqwerqw"];
}

#pragma -

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 5;
}
- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView
{
    return NO;
}
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
        return [tableView rowHeight];
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {

        PluginCellView *cell = [tableView makeViewWithIdentifier:@"PluginCellView" owner:self];
        [cell setupWithPluginId:@""];

        return cell;
}


@end
