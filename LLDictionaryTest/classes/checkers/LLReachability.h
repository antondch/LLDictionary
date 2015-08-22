//
//  Reachability.h
//  LLDictionaryTest
//
//  Created by jessie on 22.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>


extern NSString *const REACHABILITI_CHANGED;


@interface LLReachability : NSObject{
    SCNetworkReachabilityRef _reachabilityRef;
}

@property (nonatomic, readonly) BOOL reachabilityForInternetConnection;

+(LLReachability *)defaultReachability;

- (BOOL)startNotifier;
- (void)stopNotifier;

@end


