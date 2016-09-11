//
//  MUZTracksViewController.m
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZTracksViewController.h"
#import "MUZTracksControllerViewModel.h"
#import "MUZSearch.h"
#import "MUZTracksTableViewCell.h"
#import "MUZSearchViewController.h"
#import "MUZTracksSearchBar.h"
#import "MUZViewControllerTransitionPresenter.h"
#import "MUZSearchViewControllerPresentationController.h"
#import "MUZViewControllerTransitionStyleConfiguration.h"

@interface MUZTracksViewController ()
<
  UITableViewDelegate,
  MUZTracksSearchBarDelegate
>

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,strong) MUZTracksSearchBar *searchBar;

@property (nonatomic,strong) MUZTracksControllerViewModel *viewModel;
@property (nonatomic,strong) MUZDatabaseManager *database;
@property (nonatomic,strong) MUZNetworkManager *network;

@end

@implementation MUZTracksViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self assertDependencies];
  
  self.tableView.delegate = self;
  [self configureSearchBar];
}

- (void)setViewModel:(MUZTracksControllerViewModel *)viewModel
{
  _viewModel = viewModel;
  [self.tableView reloadData];
  [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
  [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
  
  [self.searchBar resignFirstResponder];
}

- (MUZTracksControllerViewModel *)tracksControllerViewModelWithSearch:(MUZSearch *)search
{
  NSParameterAssert(search);
  return [[MUZTracksControllerViewModel alloc] initWithTableView:self.tableView
                                             cellReuseIdentifier:NSStringFromClass(MUZTracksTableViewCell.class)
                                                          search:search];
}

- (void)makeSearchWithQuery:(NSString *)query
{
  [self.searchBar resignFirstResponder];
  
  [SVProgressHUD setMinimumDismissTimeInterval:2.0];
  [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
  [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
  [SVProgressHUD showWithStatus:NSLocalizedString(@"Progress.Title.Searching", nil)];
  
  __weak __typeof(self) weakSelf = self;
  [MUZSearch
   fetchTracksWithQuery:query
   toDatabase:self.database
   fromNetwork:self.network
   successBlock:^(MUZSearch *search) {
     __strong __typeof(weakSelf) strongSelf = weakSelf;
     if (search) {
       [SVProgressHUD dismiss];
       strongSelf.viewModel = [strongSelf tracksControllerViewModelWithSearch:search];
     }
     else {
       [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Progress.Title.Nothing", nil)];
     }
   } failureBlock:^(NSInteger errorCode, NSString *errorMessage, BOOL wasCanceled) {
     
     [SVProgressHUD dismiss];
     
     __strong __typeof(weakSelf) strongSelf = weakSelf;
     if (wasCanceled) {
       return;
     }
     
     if (errorMessage) {
       [strongSelf muz_showAlertWithTitle:@"Error" message:errorMessage];
     }
   }];
}

#pragma mark MUZTracksSearchBarDelegate

- (void)configureSearchBar
{
  self.searchBar = [[MUZTracksSearchBar alloc] initWithDelegate:self];
  self.navigationItem.titleView = self.searchBar;
}


- (BOOL)searchBarShouldBeginEditing:(MUZTracksSearchBar *)searchBar
{
  if (searchBar.enabled) {
    return YES;
  }
  
  [self presentSearchController];
  return NO;
}

- (void)searchBarSearchButtonClicked:(MUZTracksSearchBar *)searchBar
{
  NSString *query = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if (query.length < 2) {
    return;
  }
  
  MUZSearch *search = [MUZSearch searchWithQuery:query inContext:self.database.mainObjectContext];
  if (search) {
    self.viewModel = [self tracksControllerViewModelWithSearch:search];
  }
  else {
    [self makeSearchWithQuery:query];
  }
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)presentSearchController
{
  NSUInteger searchCount = [MUZSearch countObjectsInContext:self.database.mainObjectContext];
  if (!searchCount) {
    self.searchBar.enabled = YES;
    [self.searchBar becomeFirstResponder];
    return;
  }
  
  MUZSearchViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MUZSearchVC"];
  __weak __typeof(self) weakSelf = self;
  [controller setDependenciesWithDatabase:self.database
                          completionBlock:^(MUZSearch *search) {
                            __strong __typeof(weakSelf) strongSelf = weakSelf;
    
                            if (!search) {
                              strongSelf.searchBar.enabled = YES;
                              [strongSelf.searchBar becomeFirstResponder];
                            }
                            else {
                              strongSelf.viewModel = [strongSelf tracksControllerViewModelWithSearch:search];
                            }
                          }];
  
  MUZViewControllerTransitionStyleConfiguration *transitionStyle =
  [MUZViewControllerTransitionStyleConfiguration configurationWithStyle:MUZViewControllerTransitionStyleBounceDown
                                                             inDuration:0.6
                                                            outDuration:0.2];
  MUZViewControllerTransitionPresenter *presenter = [[MUZViewControllerTransitionPresenter alloc]
                                                     initWithViewController:controller
                                                     style:transitionStyle
                                                     presentationControllerClass:MUZSearchViewControllerPresentationController.class];
  
  [self presentViewController:presenter animated:YES completion:nil];
}

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"MUZTrackDetailsSegue"]) {
    UIViewController<MUZTrackProfileControllerDependencyProtocol> *controller = segue.destinationViewController;
    [controller setDependenciesWithTrack:[self.viewModel selectedTrack]];
  }
}

#pragma mark MUZDependenciesProtocol

- (void)assertDependencies
{
  NSParameterAssert(self.database && self.network);
}

- (void)setDependenciesWithDatabase:(id)database network:(id)network
{
  self.database = database;
  self.network = network;
}

@end
