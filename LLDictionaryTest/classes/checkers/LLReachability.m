//
//  Reachability.m
//  LLDictionaryTest
//
//  Created by jessie on 22.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import "LLReachability.h"


NSString *const REACHABILITI_CHANGED = @"kNetworkReachabilityChangedNotification";


static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info) {
#pragma unused (target, flags)
    NSCAssert(info != NULL, @"info was NULL in ReachabilityCallback");
    NSCAssert([(__bridge NSObject *) info isKindOfClass:[LLReachability class]], @"info was wrong class in ReachabilityCallback");

    LLReachability *noteObject = (__bridge LLReachability *) info;
    // Post a notification to notify the client that the network reachability changed.
    [[NSNotificationCenter defaultCenter] postNotificationName:REACHABILITI_CHANGED object:noteObject];
}


@implementation LLReachability
- (id)init {
    @throw [[NSException alloc] initWithName:@"Error: it's a singleton! " reason:@"Use +[Reachability defaultReachability]" userInfo:nil];
    return nil;
}

+ (LLReachability *)defaultReachability {
    static LLReachability *reachability = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reachability = [[self alloc] initPrivate];
    });
    return reachability;
}

- (LLReachability *)initPrivate {
    self = [super init];
    if (self) {
        _reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, "apple.com");
    }
    return self;
}

- (BOOL)reachabilityForInternetConnection {
    _reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, "apple.com");
    SCNetworkConnectionFlags flags = 0;
    BOOL ok;

    SCNetworkReachabilityGetFlags(_reachabilityRef, &flags);
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL connectionRequired = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    ok = (isReachable && !connectionRequired);

    return ok;
}

#pragma mark - Start and stop notifier

- (BOOL)startNotifier {
    BOOL returnValue = NO;
    _reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, "apple.com");
    SCNetworkReachabilityContext context = {0, (__bridge void *) (self), NULL, NULL, NULL};

    if (SCNetworkReachabilitySetCallback(_reachabilityRef, ReachabilityCallback, &context)) {
        if (SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)) {
            returnValue = YES;
        }
    }

    return returnValue;
}

- (void)stopNotifier {
    if (_reachabilityRef != NULL) {
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}
@end
