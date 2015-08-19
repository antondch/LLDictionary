//
//  LLDictionaryStorage.h
//  LLDictionaryTest
//
//  Created by jessie on 19.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLDictionaryStore : NSObject
+(instancetype)sharedStore;

@property(nonatomic,readonly) NSArray *allItems;
@end
