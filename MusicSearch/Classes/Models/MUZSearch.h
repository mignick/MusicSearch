//
//  MUZSearch.h
//  MusicSearch
//
//  Created by Nickolay Migel on 11/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZManagedObject.h"

@interface MUZSearch : MUZManagedObject

@property (nonatomic,strong,readonly) NSString *query;
@property (nonatomic,strong,readonly) NSDate *searchTime;
@property (nonatomic,strong,readonly) NSOrderedSet *tracks;

+ (instancetype)insertIntoContext:(NSManagedObjectContext *)context
                            query:(NSString *)query
                       searchTime:(NSDate *)searchTime
                           tracks:(NSArray *)tracks;

// Local
+ (NSFetchedResultsController *)fetchedResultsControllerWithContext:(NSManagedObjectContext *)context;

+ (NSUInteger)countObjectsInContext:(NSManagedObjectContext *)context;
+ (MUZSearch *)searchWithQuery:(NSString *)query inContext:(NSManagedObjectContext *)context;

// Remote
+ (void)fetchTracksWithQuery:(NSString *)query
                  toDatabase:(MUZDatabaseManager *)database
                 fromNetwork:(MUZNetworkManager *)network
                successBlock:(void(^)(MUZSearch *))successBlock
                failureBlock:(MUZOpeationFailureBlock)failureBlock;

@end
