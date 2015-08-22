//
//  YandexResponse.m
//  LLDictionaryTest
//
//  Created by jessie on 21.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import "LLYandexResponse.h"
#import "ITranslationService.h"

@implementation LLYandexResponse
-(instancetype)initFromData:(NSData *)data{
    self = [super initFromData:data];
    if(self){
        NSError *convertError = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&convertError];
        if(convertError){
            self.resultCode = otherError;
            return self;
        }
        NSInteger code = [[dictionary valueForKey:@"code"]integerValue];
        switch (code){
            case 200:
                self.resultCode = succsess;
                break;
            case 403:
            case 404:
                self.resultCode = translationLimit;
                break;
            case 422:
            case 501:
                self.resultCode = translationError;
                break;
            default:
                self.resultCode = otherError;
                break;
        }
        if (self.resultCode == succsess){
            //по хорошему, если тут оставлять трайкетчи, то в случае отлова надо посылать уведомление девелоперам, что сломалась или поменялась апи (например, через сетевой логгер на логсервер компании), но, в пределах тестового, это уже лютый оверкилл. Если будет время - допилю. По поводу того, что медленные трайкетчи - в нашем случае, эта капля в море все равно нивелируется латентностью запроса/ответа на сервер.
            @try{
                NSArray *translations = [dictionary valueForKey:@"text"];
                self.translation = translations[0];
                NSDictionary *langsDetected = [dictionary valueForKey:@"detected"];
                NSString *langDetected = [langsDetected valueForKey:@"lang"];
                self.fromLang = [self convertStringToLang:langDetected];
            }@catch(NSException *exception){
                self.resultCode = parseError;
            }
        }
    }
    return self;
}

- (Langs)convertStringToLang:(NSString*) str {
    if([str isEqualToString:@"en"]){
        return en;
    }else if([str isEqualToString:@"ru"]){
        return ru;
    }
    return uncnown;
}

@end
