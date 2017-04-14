//
//  Snippet.m
//  Text Inflater Plugin
//
//  Created by maxfish on 29/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import "Snippet.h"

@implementation Snippet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary prefix:(NSString *)prefix suffix:(NSString *)suffix {
    self = [super init];
    if (self) {
        self.label = dictionary[@"label"];
        self.text = dictionary[@"plainText"];
        self.rtf = dictionary[@"richText"];
        self.html = dictionary[@"html"];
        self.abbreviation = dictionary[@"abbreviation"];
        self.fullAbbreviation =  [NSString stringWithFormat:@"%@%@%@", prefix, _abbreviation, suffix];
    }

    return self;
}

@end