//
//  FileStorage.m
//  LLDictionaryTest
//
//  Created by jessie on 20.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import "FileStorage.h"

@interface FileStorage()

@end
@implementation FileStorage

#pragma mark - init & get instance

- (id)init {
    @throw [[NSException alloc] initWithName:@"Error: it's a singleton! " reason:@"Use +[FileStorage sharedStore]" userInfo:nil];
    return nil;
}

+ (FileStorage *)defaultStorage {
    static FileStorage *defaultStorage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultStorage = [[self alloc] initPrivate];
    });
    return defaultStorage;
}

- (FileStorage *)initPrivate {
    self = [super init];
    [self createDataPath];
    return self;
}



#pragma mark - file manipulation


- (NSData*)loadDataWithName:(NSString *)name {
    NSString *dataPath = [_docPath stringByAppendingPathComponent:name];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:dataPath options:0 error:&error];
    if(error){
        NSLog(@"Error loading file: %@ reason: %@", dataPath, [error localizedDescription]);
        return nil;
    }
    return  data;
}

- (BOOL)saveData:(NSData *)data withName:(NSString *)name {
    if(!data){
        data = [[NSData alloc]init];
    }
    NSError *error = nil;
    NSString *dataPath = [_docPath stringByAppendingPathComponent:name];
    [data writeToFile:dataPath options:0 error:&error];
    if(error){
        NSLog(@"Error writing file: %@ reason: %@", dataPath, [error localizedDescription]);
        return NO;
    }
    return YES;
}

#pragma mark - create path string

- (BOOL)createDataPath {
    
    if (_docPath == nil) {
        _docPath = [self getPrivateDocsDir];
    }
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:_docPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    return success;
}

- (NSString *)getPrivateDocsDir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
}
@end

