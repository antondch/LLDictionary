//
//  LLDictionaryStorage.m
//  LLDictionaryTest
//
//  Created by jessie on 19.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import "LLDictionaryStore.h"
#import "LLWordItem.h"

@interface LLDictionaryStore()
@end

@implementation LLDictionaryStore
@synthesize storage = _storage;

#pragma mark - conatants
//Скользкий путь, в больших проектах такие вещи лучше объявлять глобально, во избежания дублирования, либо добавлять уникальный id модели, которая требует сохранения.
static NSString * const DIC_FILE_NAME = @"words";

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
    }
    return  self;
}

-(instancetype) init{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[LLDictionaryStore sharedStore]" userInfo:nil];
    return nil;
}

#pragma mark - get & set words

-(NSUInteger)wordsCount{
    return [_privateWordList count];
}

-(NSArray*)getWordsWithMask:(NSString*)mask{
    return _privateWordList;
}

-(void)addWord:(NSString *)word withTranslation:(NSString *)translation{
    LLWordItem *item = [[LLWordItem alloc]init];
    item.original = word;
    item.translation = translation;
    [_privateWordList addObject:item];
}

-(void)removeWord:(NSString *)word{
//todo: реализовать удаление
}

#pragma mark - save & load

-(BOOL)save{
    BOOL result = NO;
    if([_privateWordList count]==0){
        return NO;
    }
    NSData *words = [NSKeyedArchiver archivedDataWithRootObject:_privateWordList];
    if(_storage){
        if ([_storage respondsToSelector:@selector(saveData:withName:)]){
            result = [_storage saveData:words withName:DIC_FILE_NAME];
        }
    }
    return result;
}

-(BOOL)load{
    BOOL result = NO;
   if ([_storage respondsToSelector:@selector(loadDataWithName:)]){
       @try{
           NSData *words = [_storage loadDataWithName:DIC_FILE_NAME];
            _privateWordList = [NSKeyedUnarchiver unarchiveObjectWithData:words];
           if([_privateWordList count]){
               result = YES;
           }
       }@catch(NSException *exception){
           NSLog(@"Error loading data from device: %@", exception.reason);
           result = NO;
       }
       return result;
   }
}

@end
