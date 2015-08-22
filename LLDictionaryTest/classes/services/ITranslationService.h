//
//  ITranslationService.h
//  LLDictionaryTest
//
//  Created by jessie on 21.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LLTranslationResponse;

typedef enum{
    ru,
    en,
    uncnown
}Langs;

typedef enum{
    succsess,
    translationLimit,
    translationError,
    serverError,
    parseError,
    otherError
}TranslationServiceResult;

typedef void (^ CallBackBlock)(LLTranslationResponse*);

@protocol TranslationServiceDelegate <NSObject>
@optional
-(instancetype)initWithAPIKey:(NSString*)key;

@required
-(NSString*)langToString:(Langs)lang;
-(void)fetchTranslate:(NSString*)original toLang:(Langs)toLang withCallBackBlock:(CallBackBlock)callBackBlock;
@end


