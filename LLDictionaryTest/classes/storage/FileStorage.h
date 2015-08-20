//
//  FileStorage.h
//  LLDictionaryTest
//
//  Created by jessie on 20.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IStorage.h"

@interface FileStorage : NSObject<StorageDelegate>{
    NSString* _docPath;
}

+(FileStorage*)defaultStorage;
-(BOOL)saveData:(NSData*)data withName:(NSString*)name;
-(NSData*)loadDataWithName:(NSString*)name;
@end
