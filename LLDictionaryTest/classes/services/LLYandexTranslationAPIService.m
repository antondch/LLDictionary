//
//  LLYandexTranslationAPIService.m
//  LLDictionaryTest
//
//  Created by jessie on 20.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import "LLYandexTranslationAPIService.h"

@implementation LLYandexTranslationAPIService

static NSString * const APIURL = @"https://translate.yandex.net/api/v1.5/tr.json/translate";

-(instancetype)initWithAPIKey:(NSString*)key{
    self = [super init];
    if(self){
        _APIKey = key;
        [self configSession];
    }
    return self;
}

-(void)configSession{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    
}

-(void)fetchTranslate:(NSString *)original toLang:(Langs)toLang withCallBackBlock:(CallBackBlock)callBackBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:APIURL]];
    [request setHTTPMethod:@"POST"];
    NSString *body = [NSString stringWithFormat:@"key=%@&lang=%@&text=%@&format=%@&options=%@",_APIKey,[self langToString:toLang],original,@"plain",@"1"];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:
    //callback block
     ^(NSData *data, NSURLResponse *response, NSError *error) {
         TranslationServiceResult resultCode;
         if(error){
             callBackBlock(nil,serverError);
             return;
         }
//test***
//         NSString *json = [[NSString alloc] initWithData:data
//                                                encoding:NSUTF8StringEncoding];
//*******
         NSError *convertError = nil;
         NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&convertError];
         if(convertError){
             callBackBlock(nil,otherError);
             return;
         }
         NSInteger code = [[dictionary valueForKey:@"code"]integerValue];
         switch (code){
             case 200:
                 resultCode = succsess;
                 callBackBlock(data,resultCode);
                 return;
                 break;
             case 403:
             case 404:
                 resultCode = translationLimit;
                 break;
             case 422:
             case 501:
                 resultCode = translationError;
                 break;
             default:
                 resultCode = otherError;
                 break;
         }
         callBackBlock(nil,resultCode);
     }];//callback block
    
    [dataTask resume];
}

-(NSString*)langToString:(Langs)lang{
    switch (lang) {
        case ru:
            return @"ru";
            break;
        case en:
            return @"en";
            break;
            
        default:
            return @"en";
    }
}

@end