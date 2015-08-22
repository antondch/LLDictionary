//
//  LLYandexTranslationAPIService.m
//  LLDictionaryTest
//
//  Created by jessie on 20.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import "LLYandexTranslationAPIService.h"
#import "LLYandexResponse.h"

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
         if(error){
             callBackBlock(nil);
             return;
         }
         LLYandexResponse *yandexResponse = [[LLYandexResponse alloc]initFromData:data];
//test***
//         NSString *json = [[NSString alloc] initWithData:data
//                                                encoding:NSUTF8StringEncoding];
//*******
         callBackBlock(yandexResponse);
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
