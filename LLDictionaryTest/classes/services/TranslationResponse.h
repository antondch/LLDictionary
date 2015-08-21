//
//  TranslationResponse.h
//  LLDictionaryTest
//
//  Created by jessie on 21.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITranslationService.h"


@interface TranslationResponse : NSObject
@property (nonatomic, copy) NSString *translation;
@property (nonatomic) Langs fromLang;
@property (nonatomic) TranslationServiceResult resultCode;

-(instancetype)initFromData:(NSData*)data;
@end
