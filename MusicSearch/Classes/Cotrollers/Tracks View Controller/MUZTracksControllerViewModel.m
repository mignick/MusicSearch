//
//  MUZTracksControllerViewModel.m
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZTracksControllerViewModel.h"
#import "MUZFetchedResultsControllerDataSource.h"
#import "MUZSearch.h"
#import "MUZTrack.h"
#import "MUZTracksTableViewCell.h"
#import "MUZTrackCellViewModel.h"

@interface MUZTracksControllerViewModel()
<
  MUZFetchedResultsControllerDataSourceDelegate
>

@property (nonatomic,strong) MUZFetchedResultsControllerDataSource * fetchedResultsControllerDataSource;
@property (nonatomic,strong) NSMutableDictionary *models;

@end

@implementation MUZTracksControllerViewModel

- (instancetype)init
{
  self = [super init];
  if (!self) return nil;
  
  _models = [NSMutableDictionary dictionary];
  
  return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView
              cellReuseIdentifier:(NSString *)cellReuseIdentifier
                           search:(MUZSearch *)search
{
  self = [super init];
  if (!self) return nil;
  
  self.fetchedResultsControllerDataSource = [[MUZFetchedResultsControllerDataSource alloc] initWithTableView:tableView];
  self.fetchedResultsControllerDataSource.fetchedResultsController = [MUZTrack fetchedResultsControllerForSearch:search];
  self.fetchedResultsControllerDataSource.delegate = self;
  self.fetchedResultsControllerDataSource.reuseIdentifier = cellReuseIdentifier;
  
  return self;
}

- (MUZTrack *)selectedTrack
{
  return [self.fetchedResultsControllerDataSource selectedObject];
}

#pragma mark MUZFetchedResultsControllerDataSourceDelegate

- (void)fetchedResultsControllerDataSource:(MUZFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
                             configureCell:(MUZTracksTableViewCell *)cell
                               atIndexPath:(NSIndexPath *)indexPath
                                withObject:(MUZTrack *)object
{
  MUZTrackCellViewModel *model = [self modelAtIndexPath:indexPath object:object];
  [cell configureWithViewModel:model];
}

#pragma mark Private

- (MUZTrackCellViewModel *)modelAtIndexPath:(NSIndexPath *)indexPath object:(MUZTrack *)object
{
  MUZTrackCellViewModel *model = self.models[indexPath];
  if (!model) {
    model = [MUZTrackCellViewModel new];
  }
  model.modelObject = object;
  return model;
}

@end
