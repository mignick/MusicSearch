//
//  MUZSearchViewController.m
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZSearchViewController.h"
#import "MUZSearchControllerViewModel.h"
#import "MUZSearchTableViewCell.h"

@interface MUZSearchViewController()
<
  UITableViewDelegate
>

@property (nonatomic,weak) IBOutlet UIView *containerView;
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) IBOutlet UILabel *historyLabel;

@property (nonatomic,strong) MUZSearchControllerViewModel *viewModel;
@property (nonatomic,strong) MUZDatabaseManager *database;

@property (nonatomic,copy) void(^completionBlock)(MUZSearch *);
@property (nonatomic,strong) MUZSearch *selectedSearch;

@end

@implementation MUZSearchViewController

- (void)dealloc
{
  if (_completionBlock) {
    _completionBlock(_selectedSearch);
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self assertDependencies];
  
  self.containerView.layer.cornerRadius = 8.0f;
  self.containerView.clipsToBounds = YES;
  
  self.view.backgroundColor = [UIColor clearColor];
  self.preferredContentSize = CGSizeMake(0, 250);
  
  self.historyLabel.text = NSLocalizedString(@"SearchList.Title", nil);
  
  self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0);
  self.tableView.delegate = self;
  
  self.viewModel = [[MUZSearchControllerViewModel alloc] initWithTableView:self.tableView
                                                       cellReuseIdentifier:NSStringFromClass(MUZSearchTableViewCell.class)
                                                                  database:self.database];
  [self becomeFirstResponder];
}

#pragma mark MUZDependenciesProtocol

- (void)assertDependencies
{
  NSParameterAssert(self.completionBlock);
}

- (void)setDependenciesWithDatabase:(MUZDatabaseManager *)database completionBlock:(void (^)(MUZSearch *))compeletionBlock
{
  self.database = database;
  self.completionBlock = compeletionBlock;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  self.selectedSearch = [self.viewModel searchAtIndexPath:indexPath];
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
