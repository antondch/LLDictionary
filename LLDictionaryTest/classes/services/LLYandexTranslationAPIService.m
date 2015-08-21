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
        [self configSessionWithKey:key];
    }
    return self;
}

-(void)configSessionWithKey:(NSString*)key{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    config.HTTPAdditionalHeaders = [[NSDictionary alloc] initWithObjectsAndKeys:key,@"key", nil];
    _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    
}

-(void)fetchTranslate:(NSString *)original toLang:(Langs)toLang withCallBackBlock:(CallBackBlock)callBackBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:APIURL]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"trnsl.1.1.20150820T162617Z.f1d7c06eaab938fe.f10b23322dce20bc2224b83d70072f2e99b62dbb" forHTTPHeaderField:@"key"];
    [request setValue:original forHTTPHeaderField:@"text"];
    [request setValue:@"1" forHTTPHeaderField:@"options"];
    [request setValue:@"plain" forHTTPHeaderField:@"format"];
    [request setValue:[self langToString:toLang] forHTTPHeaderField:@"lang"];
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:
     ^(NSData *data, NSURLResponse *response, NSError *error) {
         NSString *json = [[NSString alloc] initWithData:data
                                                encoding:NSUTF8StringEncoding];
         NSLog(@"%@", json);
     }];
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
