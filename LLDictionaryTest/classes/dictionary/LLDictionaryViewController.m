//
//  LLDictionaryViewController.m
//  LLDictionaryTest
//
//  Created by jessie on 19.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import "LLDictionaryViewController.h"

@interface LLDictionaryViewController ()

@end

@implementation LLDictionaryViewController

#pragma mark - init section

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    // Do any additional setup after loading the view from its nib.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
