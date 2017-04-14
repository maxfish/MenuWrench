//
//  PasteBoard_Clip.m
//  PasteBoard Plugin
//
//  Created by maxfish on 26/03/17.
//  Copyright (c) 2017 Massimiliano Pesce. All rights reserved.
//

@import AppKit;
#import "PasteBoard_Clip.h"

#define kMaxTitleChars 140
#define kSupportedTypes @[NSTIFFPboardType, NSRTFPboardType, NSTabularTextPboardType, NSStringPboardType, NSRTFDPboardType, NSHTMLPboardType, NSPDFPboardType]


@implementation PasteBoard_Clip {
    NSPasteboard *_pasteboard;
}

- (id)initWithPasteBoardContent {
    self = [super init];

    if (self) {
        _pasteboard = [NSPasteboard pasteboardWithUniqueName];
        for (NSString *type in kSupportedTypes) {
            NSData *data = [[NSPasteboard generalPasteboard] dataForType:type];
            [_pasteboard setData:data forType:type];
        }
    }

    return self;
}

- (BOOL)isEqualToClip:(PasteBoard_Clip *)aClip {
    if (self == aClip) {
        return YES;
    }

    if (![_pasteboard.types isEqualToArray:aClip->_pasteboard.types]) {
        return NO;
    }

    return [[_pasteboard dataForType:NSStringPboardType] isEqualToData:[aClip->_pasteboard dataForType:NSStringPboardType]];
}

- (void)copyToPasteBoard {
    for (NSString *type in kSupportedTypes) {
        NSData *data = [_pasteboard dataForType:type];
        [[NSPasteboard generalPasteboard] setData:data forType:type];
    }
}

- (NSString *)displayString {
    NSString *plainText = [_pasteboard stringForType:NSStringPboardType];

    if (!plainText || [plainText isEqualToString:@""]) {
        plainText = @"--- no text ---";
    }

    NSString *newTitle = [plainText copy];
    NSString *newlineReplacementString = @"↩ ";

    // Replace newlines/tabs
    newTitle = [newTitle stringByReplacingOccurrencesOfString:@"\n" withString:newlineReplacementString];
    newTitle = [newTitle stringByReplacingOccurrencesOfString:@"\r" withString:newlineReplacementString];
    newTitle = [newTitle stringByReplacingOccurrencesOfString:@"\r\n" withString:newlineReplacementString];
    newTitle = [newTitle stringByReplacingOccurrencesOfString:@"\t" withString:@" "];

    // Replace multiple spaces with single space
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    newTitle = [newTitle stringByTrimmingCharactersInSet:whitespace];

    // Replace all other known types of newlines
    unichar chrNEL[] = {0x0085}; // NEL: Next Line, U+0085
    unichar chrFF[] = {0x000C}; // FF: Form Feed, U+000C
    unichar chrLS[] = {0x2028}; // LS: Line Separator, U+2028
    unichar chrPS[] = {0x2029}; // PS: Paragraph Separator, U+2029

    NSString *crString = [NSString stringWithCharacters:chrNEL length:1];
    newTitle = [newTitle stringByReplacingOccurrencesOfString:crString withString:newlineReplacementString];

    crString = [NSString stringWithCharacters:chrFF length:1];
    newTitle = [newTitle stringByReplacingOccurrencesOfString:crString withString:newlineReplacementString];

    crString = [NSString stringWithCharacters:chrLS length:1];
    newTitle = [newTitle stringByReplacingOccurrencesOfString:crString withString:newlineReplacementString];

    crString = [NSString stringWithCharacters:chrPS length:1];
    newTitle = [newTitle stringByReplacingOccurrencesOfString:crString withString:newlineReplacementString];

    // Remove multiple spaces
    NSRange range = [newTitle rangeOfString:@"  " options:0];
    while (range.length >= 2) {
        newTitle = [newTitle stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        range = [newTitle rangeOfString:@"  " options:0];
    }

    // Shorten newTitle to max kMaxTitleChars chars.
    NSUInteger length = [newTitle length];
    if (length > kMaxTitleChars)
        length = kMaxTitleChars;

    return [newTitle substringToIndex:length];
}

- (NSImage *)displayIcon {
    return nil;
}

@end