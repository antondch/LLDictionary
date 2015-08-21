//
//  LLDictionaryViewController.h
//  LLDictionaryTest
//
//  Created by jessie on 19.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITranslationService.h"

@interface LLDictionaryViewController : UIViewController{
    UITextField *_searchTextField;
    id<TranslationServiceDelegate> _translator;
     CallBackBlock _translationCallBack;
}

@end
