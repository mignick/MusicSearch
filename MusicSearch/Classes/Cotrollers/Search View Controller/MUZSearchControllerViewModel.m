//
//  MUZSearchControllerViewModel.m
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZSearchControllerViewModel.h"
#import "MUZFetchedResultsControllerDataSource.h"
#import "MUZSearch.h"
#import "MUZSearchTableViewCell.h"
#import "MUZSearchCellViewModel.h"

@interface MUZSearchControllerViewModel()
<
  MUZFetchedResultsControllerDataSourceDelegate
>

@property (nonatomic,strong) MUZFetchedResultsControllerDataSource * fetchedResultsControllerDataSource;
@property (nonatomic,strong) NSMutableDictionary *models;

@end

@implementation MUZSearchControllerViewModel

- (instancetype)init
{
  self = [super init];
  if (!self) return nil;
  
  _models = [NSMutableDictionary dictionary];
  
  return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView
              cellReuseIdentifier:(NSString *)cellReuseIdentifier
                         database:(MUZDatabaseManager *)database
{
  self = [super init];
  if (!self) return nil;
  
  self.fetchedResultsControllerDataSource = [[MUZFetchedResultsControllerDataSource alloc] initWithTableView:tableView];
  self.fetchedResultsControllerDataSource.fetchedResultsController =
    [MUZSearch fetchedResultsControllerWithContext:database.mainObjectContext];
  self.fetchedResultsControllerDataSource.delegate = self;
  self.fetchedResultsControllerDataSource.reuseIdentifier = cellReuseIdentifier;
  
  return self;
}

- (MUZSearch *)searchAtIndexPath:(NSIndexPath *)indexPath
{
  return [self.fetchedResultsControllerDataSource.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark MUZFetchedResultsControllerDataSourceDelegate

- (void)fetchedResultsControllerDataSource:(MUZFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
                             configureCell:(MUZSearchTableViewCell *)cell
                               atIndexPath:(NSIndexPath *)indexPath
                                withObject:(MUZSearch *)object
{
  MUZSearchCellViewModel *model = [self modelAtIndexPath:indexPath object:object];
  [cell configureWithViewModel:model];
}

#pragma mark Private

- (MUZSearchCellViewModel *)modelAtIndexPath:(NSIndexPath *)indexPath object:(MUZSearch *)object
{
  MUZSearchCellViewModel *model = self.models[indexPath];
  if (!model) {
    model = [MUZSearchCellViewModel new];
  }
  model.modelObject = object;
  return model;
}

@end
