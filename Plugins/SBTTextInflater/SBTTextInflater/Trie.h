//
//  Trie.h
//  Text Inflater Plugin
//
//  Created by maxfish on 29/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrieNode : NSObject

@property(nonatomic, strong) NSMutableDictionary *children;

@property(retain) NSObject *data;

- (BOOL)isLeaf;

@end

@interface Trie : NSObject

@property(nonatomic, strong) TrieNode *root;

- (void)insertString:(NSString *)string withData:(NSObject *)data;

- (TrieNode *)nodeForLongestPrefixOF:(NSString *)string;

@end
