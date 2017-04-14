//
//  Plugin.m
//  MenuWrench
//
//  Created by maxfish on 14/04/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import "Plugin.h"

@implementation Plugin {
    NSBundle *_bundle;
    NSObject <MWPluginInterface> *_instance;
    BOOL _enabled;
}

- (instancetype)initWithBundle:(NSBundle *)bundle {
    self = [super init];
    if (self) {
        _bundle = bundle;
        Class c = bundle.principalClass;
        _instance = [(NSObject <MWPluginInterface> *) [c alloc] init];
    }
    return self;
}

- (NSBundle *)bundle {
    return _bundle;
}

- (NSObject <MWPluginInterface> *)instance {
    return _instance;
}

- (BOOL)isEnabled {
    return _enabled;
}

@end
