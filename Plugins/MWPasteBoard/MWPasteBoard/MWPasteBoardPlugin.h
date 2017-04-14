//
//  MWPasteBoardPlugin.h
//  PasteBoard Plugin
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import <objc/NSObject.h>
#import "PasteBoard_Clip.h"
#import "MWPluginInterface.h"

@interface MWPasteBoardPlugin : NSObject <MWPluginInterface>

- (void)requirePasteContent:(PasteBoard_Clip *)item;

@end