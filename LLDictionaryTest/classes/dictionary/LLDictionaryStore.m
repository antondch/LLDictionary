//
//  LLDictionaryStorage.m
//  LLDictionaryTest
//
//  Created by jessie on 19.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import "LLDictionaryStore.h"

@interface LLDictionaryStore()
@end

@implementation LLDictionaryStore

#pragma mark - init section

+(instancetype)sharedStore{
    static LLDictionaryStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

-(instancetype)initPrivate{
    self = [super init];
    if(self){
        _privateWordList = [[NSMutableArray alloc]init];
        _privateTransList = [[NSMutableArray alloc]init];
    }
    return  self;
}

-(instancetype) init{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[LLDictionaryStore sharedStore]" userInfo:nil];
    return nil;
}

#pragma mark - get & set words

-(NSArray*)allOriginalWords{
    return _privateWordList;
}

-(NSArray*)allTranslations{
    return _privateTransList;
}

-(void)addWord:(NSString *)word withTranslation:(NSString *)translation{
    [_privateWordList addObject:word];
    [_privateTransList addObject:translation];
}

-(void)removeWord:(NSString *)word{
    NSUInteger idx = [_privateWordList indexOfObject:word];
    if(idx == NSNotFound){
        idx = [_privateTransList indexOfObject:word];
    }
    if(idx != NSNotFound){
        [_privateWordList removeObjectAtIndex:idx];
        [_privateTransList removeObjectAtIndex:idx];
    }
}

@end
