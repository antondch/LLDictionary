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
@synthesize storage = _storage;

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

#pragma mark - save & load

-(BOOL)save{
    BOOL result = NO;
    NSData *originals = [NSKeyedArchiver archivedDataWithRootObject:_privateWordList];
    NSData *translations = [NSKeyedArchiver archivedDataWithRootObject:_privateTransList];
    if(_storage){
        //fixme: запилить константы на имена и проверить сохранность данных.
        if ([_storage respondsToSelector:@selector(saveData:withName:)]) {
            result = [_storage saveData:originals withName:@"originals"];
            if(result){
                result =  [_storage saveData:translations withName:@"translations"];
            }
            
        }
    }
    return result;
}

@end
