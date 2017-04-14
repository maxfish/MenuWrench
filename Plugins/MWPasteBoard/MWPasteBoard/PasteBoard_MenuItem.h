//
//  PasteBoard_MenuItem.h
//  PasteBoard Plugin
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

@import Cocoa;

@class MWPasteBoardPlugin;
@class PasteBoard_Clip;


@interface PasteBoard_MenuItem : NSMenuItem {
}

- (id)initWithContent:(PasteBoard_Clip *)clip image:(NSImage *)image module:(MWPasteBoardPlugin *)module;

@end
