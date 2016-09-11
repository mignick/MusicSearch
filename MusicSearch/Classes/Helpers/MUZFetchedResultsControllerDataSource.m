//
//  MUZFetchedResultsControllerDataSource.m
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZFetchedResultsControllerDataSource.h"

@interface MUZFetchedResultsControllerDataSource()

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MUZFetchedResultsControllerDataSource

- (instancetype)initWithTableView:(UITableView *)tableView
{
  self = [super init];
  if (!self) return nil;
  
  self.tableView = tableView;
  tableView.dataSource = self;
  
  return self;
}

- (id)selectedObject
{
  NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
  return (indexPath ? [self.fetchedResultsController objectAtIndexPath:indexPath] : nil);
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
  id<NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections[sectionIndex];
  return section.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
  id cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier forIndexPath:indexPath];
  NSAssert([self.delegate conformsToProtocol:@protocol(MUZFetchedResultsControllerDataSourceDelegate)],
           @" Delegate must conform to MUZFetchedResultsControllerDataSourceDelegate");
  [self.delegate fetchedResultsControllerDataSource:self configureCell:cell atIndexPath:indexPath withObject:object];
  return cell;
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
  _fetchedResultsController = fetchedResultsController;
  fetchedResultsController.delegate = self;
  NSError *error = nil;
  NSAssert([fetchedResultsController performFetch:&error],
           @"Failed to perfrom initial fetch request %@\n%@", error.localizedDescription, error.userInfo);
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
  if (type == NSFetchedResultsChangeInsert) {
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  }
  else if (type == NSFetchedResultsChangeUpdate) {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  }
  else if (type == NSFetchedResultsChangeDelete) {
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  }
}

@end
