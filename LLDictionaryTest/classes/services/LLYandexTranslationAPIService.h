//
//  LLYandexTranslationAPIService.h
//  LLDictionaryTest
//
//  Created by jessie on 20.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITranslationService.h"


@interface LLYandexTranslationAPIService: NSObject<TranslationServiceDelegate>{
    NSURLSession *_session;
}
-(void)fetchTranslate:(NSString*)original toLang:(Langs)toLang withCallBackBlock:(CallBackBlock)callBackBlock;
@end
