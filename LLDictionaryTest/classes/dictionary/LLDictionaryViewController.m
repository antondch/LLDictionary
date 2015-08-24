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
#import "LLReachability.h"
#import "FileStorage.h"

@interface LLDictionaryViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *dictionaryTableView;

@end

@implementation LLDictionaryViewController

#pragma mark - init section

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDictionary];
    [self setupViewComponens];
    [self setupTranslationService];
    [self handleAPPLifeCicle];
    [self checkInternet];
}

- (void)setupViewComponens{
    _prototypeCell = [[LLTwoColumnTableViewCell alloc]init];
    self.dictionaryTableView.dataSource = self;
    self.dictionaryTableView.delegate = self;
    [self.dictionaryTableView registerClass:[LLTwoColumnTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.dictionaryTableView reloadData];

    //search text field
    _searchTextField = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 1000, 21.0)];
//    _searchTextField.text = NSLocalizedString(@"SearchWordTextField", @"Default text for search field.");
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
    LLWordItem *item = [[LLDictionaryStore sharedStore]getItemWithWord:_searchTextField.text];
    if(item){
        [self showAlertWithTitle:NSLocalizedString(@"wordIsExitsTitle", @"word already exits alert title") andText:NSLocalizedString(@"wordIsExitsText", @"word already exits alert text")];
        return;
    }
    if([_searchTextField.text isEqualToString:@""]){
        return;
    }
    if(!_isInternetAvailable){
        [self showAlertWithTitle:NSLocalizedString(@"internetNATitle", @"internet not available alert title") andText:NSLocalizedString(@"internetNAText", @"internet not available alert text")];
        return;
    }
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
                dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showAlertWithTitle:NSLocalizedString(@"translateErrorTitle", @"translation error alert title") andText:NSLocalizedString(@"translateErrorText", @"translation error alert text")];
                });
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
}

-(void)removeWord:(id)sender{
    NSIndexPath *indexpath = [self.dictionaryTableView indexPathForSelectedRow];
    if(!indexpath){
        return;
    }
    LLDictionaryStore *dictionaryStore = [LLDictionaryStore sharedStore];
    LLWordItem *item = dictionaryStore.filteredWords[indexpath.row];
    NSArray *indexArray = [NSArray arrayWithObjects:indexpath, nil];
    [dictionaryStore removeWordItem:item];
    [dictionaryStore setFilterMask:_searchTextField.text];
    [self.dictionaryTableView beginUpdates];
    [self.dictionaryTableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
    [self.dictionaryTableView endUpdates];
}

#pragma mark - tableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[LLDictionaryStore sharedStore]filteredWords] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tableview updated");
    NSArray *items = [[LLDictionaryStore sharedStore]filteredWords];
    LLWordItem *item = items[indexPath.row];
    LLTwoColumnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.label1.text = [NSString stringWithFormat:@"%@", item.original];
    [cell.label1 sizeToFit];
    cell.label2.text = [NSString stringWithFormat:@"%@", item.translation];
    [cell.label2 sizeToFit];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *items = [[LLDictionaryStore sharedStore]filteredWords];
    LLWordItem *item = items[indexPath.row];
    if(item){
    _prototypeCell.label1.text = [NSString stringWithFormat:@"%@", item.original];
    [_prototypeCell.label1 sizeToFit];
    _prototypeCell.label2.text = [NSString stringWithFormat:@"%@", item.translation];
    [_prototypeCell.label2 sizeToFit];
    [_prototypeCell setNeedsUpdateConstraints];
    [_prototypeCell layoutIfNeeded];
//    CGSize size = [_prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping; //set the line break mode
        NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:_prototypeCell.label1.font, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
        CGSize size = [_prototypeCell.label1.text boundingRectWithSize:_prototypeCell.label1.frame.size
                                                 options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                              attributes:attrDict context:nil].size;
        
	    return size.height+1;
    }else{
        return 30;
    }
}

#pragma mark - UISearchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [[LLDictionaryStore sharedStore]setFilterMask:searchText];
    [self.dictionaryTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self searchWord:nil];
}

#pragma mark - handle internet status

- (void)checkInternet{
    _isInternetAvailable = [LLReachability defaultReachability].reachabilityForInternetConnection;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(internetStatusChanged) name:REACHABILITI_CHANGED object:nil];
    [[LLReachability defaultReachability] startNotifier];
}

- (void)internetStatusChanged{
   _isInternetAvailable = [LLReachability defaultReachability].reachabilityForInternetConnection;
}

- (void)showAlertWithTitle:(NSString*)title andText:(NSString*)text{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                         message:text
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [alert show];
}

#pragma mark - handle app status

-(void)handleAPPLifeCicle{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

-(void)appWillResignActive:(NSNotification*)notification{
    [[LLDictionaryStore sharedStore]save];
}

#pragma mark - init model
-(void)initDictionary{
    [LLDictionaryStore sharedStore].storage = [FileStorage defaultStorage];
    [[LLDictionaryStore sharedStore]load];
}

@end
