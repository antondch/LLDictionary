//
//  LLWordItem.h
//  LLDictionaryTest
//
//  Created by jessie on 20.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLWordItem : NSObject<NSCoding>{
    NSString *_original;
    NSString *_translation;
}
@property (nonatomic, copy) NSString *original;
@property (nonatomic, copy) NSString *translation;
@end
