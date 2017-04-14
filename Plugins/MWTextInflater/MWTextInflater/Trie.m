//
//  Trie.m
//  Text Inflater Plugin
//
//  Created by maxfish on 29/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

#import "Trie.h"


@implementation TrieNode

- (instancetype)init {
    if (self = [super init]) {
        self.children = nil;
    }
    return self;
}

- (BOOL)isLeaf {
    return self.children == nil;
}

@end

@implementation Trie

- (instancetype)init {
    if (self = [super init]) {
        self.root = [[TrieNode alloc] init];
    }
    return self;
}

- (void)insertString:(NSString *)string withData:(NSObject*)data {
    TrieNode *node = self.root;
    for (NSUInteger index = 0; index < string.length; index++) {
        NSString *c = [NSString stringWithFormat:@"%c", [string characterAtIndex:index]];
        if (!node.children) {
            node.children = [NSMutableDictionary new];
        }
        if (!node.children[c]) {
            node.children[c] = [[TrieNode alloc] init];
        }
        node = node.children[c];
    }

    // The current node is the leaf
    node.data = data;
}

- (TrieNode *)nodeForLongestPrefixOF:(NSString *)string {
    TrieNode *node = self.root;
    for (NSUInteger index = 0; index < string.length; index++) {
        NSString *c = [NSString stringWithFormat:@"%c", [string characterAtIndex:index]];
        if (!node.children || !node.children[c]) {
            return nil;
        }
        node = node.children[c];
    }
    return node;
}

@end