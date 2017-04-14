//
//  Snippet.h
//  Text Inflater Plugin
//
//  Created by maxfish on 29/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Snippet : NSObject

@property(copy) NSString *label;
@property(copy) NSString *abbreviation;
@property(copy) NSString *fullAbbreviation;
@property(copy) NSString *text;
@property(copy) NSData *rtf;
@property(copy) NSData *html;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary prefix:(NSString *)prefix suffix:(NSString *)suffix;

@end