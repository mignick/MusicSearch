//
//  MUZFetchedResultsControllerDataSource.h
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

@import CoreData;
@import Foundation;

@class MUZFetchedResultsControllerDataSource;

@protocol MUZFetchedResultsControllerDataSourceDelegate <NSObject>

- (void)fetchedResultsControllerDataSource:(MUZFetchedResultsControllerDataSource *)fetchedResultsControllerDataSource
                             configureCell:(id)cell
                               atIndexPath:(NSIndexPath *)indexPath
                                withObject:(id)object;

@end

@interface MUZFetchedResultsControllerDataSource : NSObject
<
  UITableViewDataSource,
  NSFetchedResultsControllerDelegate
>

@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic,strong) NSString *reuseIdentifier;
@property (nonatomic,weak) id<MUZFetchedResultsControllerDataSourceDelegate> delegate;

- (instancetype)initWithTableView:(UITableView *)tableView;

- (id)selectedObject;

@end
