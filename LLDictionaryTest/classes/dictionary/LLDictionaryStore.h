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
    //array of LLWordItem
    NSMutableArray *_privateWordList;
    NSArray *_filteredWordList;
    
    id<StorageDelegate> _storage;
}

+(instancetype)sharedStore;

@property(nonatomic, strong) id<StorageDelegate> storage;

@property(nonatomic, readonly) NSArray* filteredWords;
@property(nonatomic, readonly) NSArray* allWords;

-(void)addWord:(NSString*)word withTranslation:(NSString*)translation;
-(void)removeWord:(NSString*)word;
-(void)setFilterMask:(NSString*)mask;
-(BOOL)save;


@end
