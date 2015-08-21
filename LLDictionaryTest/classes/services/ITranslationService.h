//
//  ITranslationService.h
//  LLDictionaryTest
//
//  Created by jessie on 21.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    ru,
    en
}Langs;

typedef enum{
    succsess,
    translationLimit,
    translationError,
    serverError,
    otherError
}TranslationServiceResult;

typedef void (^ CallBackBlock)(NSData*,TranslationServiceResult);

@protocol TranslationServiceDelegate <NSObject>

@optional
-(instancetype)initWithAPIKey:(NSString*)key;

@required
-(NSString*)langToString:(Langs)lang;
-(void)fetchTranslate:(NSString*)original toLang:(Langs)toLang withCallBackBlock:(CallBackBlock)callBackBlock;
@end

