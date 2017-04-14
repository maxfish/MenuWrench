//
//  PasteBoard_Clip.h
//  PasteBoard Plugin
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

@interface PasteBoard_Clip : NSObject

- (id)initWithPasteBoardContent;

- (BOOL)isEqualToClip:(PasteBoard_Clip *)aClip;

- (NSString *)displayString;

- (void)copyToPasteBoard;

- (NSImage *)displayIcon;

@end