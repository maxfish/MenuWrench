//
//  PasteBoard_MenuItem.h
//  SBTPasteBoard
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

@import Cocoa;

@class PasteBoardPlugin;
@class PasteBoard_Clip;


@interface PasteBoard_MenuItem : NSMenuItem {
}

- (id)initWithContent:(PasteBoard_Clip *)clip image:(NSImage *)image module:(PasteBoardPlugin *)module;

@end
