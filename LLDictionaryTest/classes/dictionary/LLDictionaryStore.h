//
//  LLDictionaryStorage.h
//  LLDictionaryTest
//
//  Created by jessie on 19.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IStorage.h"

@interface LLDictionaryStore : NSObject{
    //array of original words
    NSMutableArray *_privateWordList;
    //array of translations
    NSMutableArray *_privateTransList;
    
    id<StorageDelegate> _storage;
}

+(instancetype)sharedStore;

@property(nonatomic, readonly) NSArray *allOriginalWords;
@property(nonatomic, readonly) NSArray *allTranslations;
@property(nonatomic, strong) id<StorageDelegate> storage;

-(void)addWord:(NSString*)word withTranslation:(NSString*)translation;
-(void)removeWord:(NSString*)word;
-(BOOL)save;

@end
