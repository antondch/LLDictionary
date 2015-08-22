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
#import "LLTranslationResponse.h"
#import "LLTwoColumnTableViewCell.h"
#import "LLWordItem.h"

@interface LLDictionaryViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *dictionaryTableView;

@end

@implementation LLDictionaryViewController

#pragma mark - init section

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewComponens];
    [self setupTranslationService];
}

- (void)setupViewComponens{
    self.dictionaryTableView.dataSource = self;
    [self.dictionaryTableView registerClass:[LLTwoColumnTableViewCell class] forCellReuseIdentifier:@"Cell"];

    //search text field
    _searchTextField = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 1000, 21.0)];
//    _searchTextField.borderStyle = UITextBorderStyleNone;
//    _searchTextField.backgroundColor = [UIColor colorWithRed:0.2 green:0.9 blue:0.5 alpha:0.3];
//    _searchTextField.textAlignment = NSTextAlignmentCenter;
//    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.text = NSLocalizedString(@"SearchWordTextField", @"Default text for search field.");
    _searchTextField.delegate = self;
    
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
    [_translator fetchTranslate:_searchTextField.text toLang:ru withCallBackBlock:^(LLTranslationResponse *result) {
        __strong LLDictionaryViewController *strongSelf = weakSelf;
        switch(result.resultCode){
            case succsess:{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf addWordtoDictionary:_searchTextField.text withTranslation:result.translation];
                });
                break;
            }
            default:
                break;
        }
    }];
}

-(void)addWordtoDictionary:(NSString*) word withTranslation:(NSString*) translation{
    LLDictionaryStore *dictionaryStore = [LLDictionaryStore sharedStore];
    [dictionaryStore addWord:word withTranslation:translation];
    NSLog(@"data received");
    [dictionaryStore setFilterMask:_searchTextField.text];
    [self.dictionaryTableView beginUpdates];
    NSIndexPath *path = [NSIndexPath indexPathForRow:dictionaryStore.filteredWords.count-1 inSection:0];
    NSArray *indexArray = [NSArray arrayWithObjects:path, nil];
    [self.dictionaryTableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
    [self.dictionaryTableView endUpdates];
//       [self.dictionaryTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dictionary table view delegate

#pragma mark tableView data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[LLDictionaryStore sharedStore]filteredWords] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tableview updated");
    NSArray *items = [[LLDictionaryStore sharedStore]filteredWords];
    LLWordItem *item = items[indexPath.row];
    LLTwoColumnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.label1.text = [NSString stringWithFormat:@"%@", item.original];
    cell.label2.text = [NSString stringWithFormat:@"%@", item.translation];
    return cell;
}


#pragma mark - UISearchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [[LLDictionaryStore sharedStore]setFilterMask:searchText];
    [self.dictionaryTableView reloadData];
}

//-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
//    // Tells the table data source to reload when scope bar selection changes
//    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
//     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
//    // Return YES to cause the search result table view to be reloaded.
//    return YES;
//}

@end
