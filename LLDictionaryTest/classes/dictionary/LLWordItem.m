//
//  LLWordItem.m
//  LLDictionaryTest
//
//  Created by jessie on 20.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import "LLWordItem.h"

@implementation LLWordItem
@synthesize original = _original;
@synthesize translation = _translation;

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        _original = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(original))];
        _translation = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(translation))];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_original forKey:NSStringFromSelector(@selector(original))];
    [aCoder encodeObject:_translation forKey:NSStringFromSelector(@selector(translation))];
}
@end
