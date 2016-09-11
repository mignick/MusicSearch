//
//  MUZTracksControllerViewModel.h
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MUZFetchedResultsControllerDataSource;
@class MUZSearch, MUZTrack;

@interface MUZTracksControllerViewModel : NSObject

@property (nonatomic,strong,readonly) MUZFetchedResultsControllerDataSource * fetchedResultsControllerDataSource;

- (instancetype)initWithTableView:(UITableView *)tableView
              cellReuseIdentifier:(NSString *)cellReuseIdentifier
                           search:(MUZSearch *)search;

- (MUZTrack *)selectedTrack;

@end
