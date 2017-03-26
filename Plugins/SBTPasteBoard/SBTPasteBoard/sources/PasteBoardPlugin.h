//
//  PasteBoardPlugin.h
//  SBTPasteBoard
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import "PasteBoard_Clip.h"
#import "SBTPluginInterface.h"

@interface PasteBoardPlugin : NSObject <SBTPluginInterface>

- (void)requirePasteContent:(PasteBoard_Clip *)item;

@end