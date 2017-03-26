//
//  PasteBoard_MenuItem.m
//  SBTPasteBoard
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import "PasteBoard_MenuItem.h"
#import "PasteBoard_Clip.h"
#import "PasteBoardPlugin.h"

@implementation PasteBoard_MenuItem {
    PasteBoardPlugin *_module;
    PasteBoard_Clip *_clip;
}

- (id)initWithContent:(PasteBoard_Clip *)clip image:(NSImage *)image module:(PasteBoardPlugin *)module {
    _module = module;
    _clip = clip;

    NSString *title = [_clip displayString];
    PasteBoard_MenuItem *itself = (PasteBoard_MenuItem *) [super initWithTitle:title action:@selector(action:) keyEquivalent:@""];
    [itself setImage:[_clip displayIcon]];

    [itself setTarget:self];
    [itself setEnabled:YES];

    return itself;
}

- (void)action:(id)sender {
    [_module requirePasteContent:_clip];
}

@end
