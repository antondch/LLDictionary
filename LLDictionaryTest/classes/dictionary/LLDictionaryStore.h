//
//  LLDictionaryStorage.h
//  LLDictionaryTest
//
//  Created by jessie on 19.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLDictionaryStore : NSObject{
    //array of original words
    NSMutableArray *_privateWordList;
    //array of translations
    NSMutableArray *_privateTransList;
}

+(instancetype)sharedStore;

@property(nonatomic, readonly) NSArray *allOriginalWords;
@property(nonatomic, readonly) NSArray *allTranslations;
@end
