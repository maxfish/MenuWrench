#import "Utils.h"

@implementation Utils {

}

#pragma mark - Login item

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

+ (void)addAppToStartupItems {
    CFURLRef url = (__bridge CFURLRef) [NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath];
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemLast, NULL, NULL, url, NULL, NULL);
    if (item) {
        CFRelease(item);
    }
    CFRelease(loginItems);
}

+ (void)removeAppFromStartupItems {
    UInt32 seedValue;
    NSString *path = [NSBundle mainBundle].bundlePath;
    CFURLRef thePath = (__bridge CFURLRef) [NSURL fileURLWithPath:path];
    LSSharedFileListRef theLoginItemsRefs = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    NSArray *loginItemsArray = (__bridge NSArray *) LSSharedFileListCopySnapshot(theLoginItemsRefs, &seedValue);
    for (id item in loginItemsArray) {
        LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef) item;
        if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef *) &thePath, NULL) == noErr) {
            if ([((__bridge NSURL *) thePath).path hasPrefix:path])
                LSSharedFileListItemRemove(theLoginItemsRefs, itemRef);
        }
    }
}

#pragma GCC diagnostic pop

+ (void)toggleLoginItem:(BOOL)toggle {
    if (toggle) {
        [self addAppToStartupItems];
    } else {
        [self removeAppFromStartupItems];
    }
}

#pragma mark - Files

+ (NSArray *)filesWithinFolder:(NSString *)folderPath withExtension:(NSString *)extension {
    NSError *error = nil;
    NSArray *filesList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error];

    if (filesList == nil) {
        NSLog(@"%@", error.localizedDescription);
        return @[];
    }

    NSString *predicate = [NSString stringWithFormat:@"self ENDSWITH '.%@'", extension];
    return [filesList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicate]];
}

+ (NSString *)dropboxFolder {
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/.dropbox/info.json", NSHomeDirectory()]];
    id object = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];

    if (error || ![object isKindOfClass:[NSDictionary class]]) {
        NSLog(@"dropbox/info.json loading failed");
        return @"";
    }

    NSDictionary *results = object;
    return (NSString *) results[@"personal"][@"path"];
}

+ (BOOL)doesFolderExistAtPath:(NSString *)path {
    BOOL isDirectory = YES;
    return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
}

+ (BOOL)createFolderAtPath:(NSString *)path {
    BOOL successful = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                                                 attributes:nil error:NULL];
    return successful;
}

@end