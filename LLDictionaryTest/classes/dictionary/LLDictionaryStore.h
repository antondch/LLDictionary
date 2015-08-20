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
    
    id<StorageDelegate> _storage;
}

+(instancetype)sharedStore;

@property(nonatomic, strong) id<StorageDelegate> storage;

-(void)addWord:(NSString*)word withTranslation:(NSString*)translation;
-(void)removeWord:(NSString*)word;
-(NSArray*)getWordsWithMask:(NSString*)mask;
-(BOOL)save;

@end
