//
//  YandexResponse.h
//  LLDictionaryTest
//
//  Created by jessie on 21.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITranslationService.h"
#import "TranslationResponse.h"

@interface YandexResponse : TranslationResponse
-(instancetype)initFromData:(NSData *)data;
@end
