//
//  LLDictionaryViewController.m
//  LLDictionaryTest
//
//  Created by jessie on 19.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import "LLDictionaryViewController.h"
#import "LLDictionaryStore.h"
#import "ITranslationService.h"
#import "LLYandexTranslationAPIService.h"
#import "TranslationResponse.h"

@interface LLDictionaryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *dictionaryTableView;

@end

@implementation LLDictionaryViewController

#pragma mark - init section

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupTranslationService];
}

- (void)setupNavigationBar{
    //search text field
    _searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 1000, 21.0)];
    _searchTextField.borderStyle = UITextBorderStyleNone;
    _searchTextField.backgroundColor = [UIColor colorWithRed:0.2 green:0.9 blue:0.5 alpha:0.3];
    _searchTextField.textAlignment = NSTextAlignmentCenter;
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.text = NSLocalizedString(@"SearchWordTextField", @"Default text for search field.");
    self.navigationItem.titleView = _searchTextField;

    //control buttons
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeWord:)];
    self.navigationItem.leftBarButtonItem = deleteButton;
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchWord:)];
    self.navigationItem.rightBarButtonItem = searchButton;
}

-(void)setupTranslationService{
    _translator = [[LLYandexTranslationAPIService alloc]initWithAPIKey:@"trnsl.1.1.20150820T162617Z.f1d7c06eaab938fe.f10b23322dce20bc2224b83d70072f2e99b62dbb"];
}

#pragma mark - dictionary manipulation
-(void)searchWord:(id)sender{
    __weak LLDictionaryViewController *weakSelf = self;
    [_translator fetchTranslate:_searchTextField.text toLang:ru withCallBackBlock:^(TranslationResponse *result) {
        __strong LLDictionaryViewController *strongSelf = weakSelf;
        switch(result.resultCode){
            case succsess:
                [strongSelf addWordtoDictionary:@"test" withTranslation:@"test"];
                break;
            default:
                break;
        }
    }];
}

-(void)addWordtoDictionary:(NSString*) word withTranslation:(NSString*) translation{
    LLDictionaryStore *dictionaryStore = [LLDictionaryStore sharedStore];
    [dictionaryStore addWord:word withTranslation:translation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
