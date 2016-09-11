//
//  MUZSearch.m
//  MusicSearch
//
//  Created by Nickolay Migel on 11/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZSearch.h"
#import "MUZTrack.h"
#import "MUZFetchTracksResponse.h"

@interface MUZSearch()

@property (nonatomic,strong) NSString *query;
@property (nonatomic,strong) NSDate *searchTime;
@property (nonatomic,strong) NSOrderedSet *tracks;

@end

@implementation MUZSearch

@dynamic query;
@dynamic searchTime;
@dynamic tracks;

+ (instancetype)insertIntoContext:(NSManagedObjectContext *)context
                            query:(NSString *)query
                       searchTime:(NSDate *)searchTime
                           tracks:(NSArray *)tracks
{
  NSMutableArray *artistIds = [NSMutableArray array];
  NSMutableArray *collectionIds = [NSMutableArray array];
  NSMutableArray *trackIds = [NSMutableArray array];
  for (MUZTrack *t in tracks) {
    [artistIds addObject:@(t.artistId)];
    [collectionIds addObject:@(t.collectionId)];
    [trackIds addObject:@(t.trackId)];
  }

  NSPredicate *predicate = [NSPredicate
                            predicateWithFormat:@" artistId IN %@ AND collectionId IN %@ AND trackId IN %@",
                            artistIds, collectionIds, trackIds];
  
  NSFetchRequest *request = [NSFetchRequest new];
  request.entity = [NSEntityDescription entityForName:[MUZTrack entityName]
                               inManagedObjectContext:context];
  request.predicate = predicate;
  
  NSError *error = nil;
  NSArray *fetchedTracks = [context executeFetchRequest:request error:&error];
  NSAssert(!error, error.localizedDescription);
  
  NSMutableOrderedSet *tracksToInsert = [NSMutableOrderedSet orderedSet];
  for (MUZTrack *track in tracks) {
    NSUInteger index = [fetchedTracks
                        indexOfObjectPassingTest:^BOOL(MUZTrack *obj,
                                                       NSUInteger idx,
                                                       BOOL *stop) {
                          BOOL shouldStop = (obj.artistId == track.artistId
                                             && obj.collectionId == track.collectionId
                                             && obj.artistId == track.artistId);
                          *stop = shouldStop;
                          return shouldStop;
                        }];
    if (index != NSNotFound) {
      MUZTrack *existedTrack = fetchedTracks[index];
      [existedTrack updateFromTrack:track];
      [tracksToInsert addObject:existedTrack];
    }
    else {
      [context insertObject:track];
      [tracksToInsert addObject:track];
    }
  }
  
  MUZSearch *search = [self insertNewObjectIntoContext:context];
  search.query = query;
  search.searchTime = searchTime;
  search.tracks = tracksToInsert;
  
  return search;
}

+ (NSFetchedResultsController *)fetchedResultsControllerWithContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
  request.fetchBatchSize = 20;
  request.returnsObjectsAsFaults = NO;
  request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(searchTime)) ascending:YES]];
  
  NSFetchedResultsController *controller = [[NSFetchedResultsController alloc]
                                            initWithFetchRequest:request
                                            managedObjectContext:context
                                            sectionNameKeyPath:nil
                                            cacheName:nil];
  return controller;
}

+ (NSUInteger)countObjectsInContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
  NSError *error = nil;
  NSUInteger count = [context countForFetchRequest:request error:NULL];
  NSAssert(count != NSNotFound, @"Failed to fecth MUZSearch objects count: %@\n%@", error.localizedDescription, error.userInfo);
  if (count == NSNotFound) {
    count = 0;
  }
  return count;
}

+ (MUZSearch *)searchWithQuery:(NSString *)query inContext:(NSManagedObjectContext *)context
{
  NSParameterAssert(query.length && context);
  if (!query.length || !context) {
    return nil;
  }
  
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
  request.predicate = [NSPredicate predicateWithFormat:@"query = %@", query];
  request.returnsObjectsAsFaults = NO;
  NSError *error = nil;
  NSArray *results = [context executeFetchRequest:request error:&error];
  NSAssert(!error, @"Failed ro fetch search with query '%@': %@\n%@", query, error.localizedDescription, error.userInfo);
  return [results firstObject];
}

+ (void)fetchTracksWithQuery:(NSString *)query
                  toDatabase:(MUZDatabaseManager *)database
                 fromNetwork:(MUZNetworkManager *)network
                successBlock:(void(^)(MUZSearch *))successBlock
                failureBlock:(MUZOpeationFailureBlock)failureBlock
{
  NSParameterAssert(query.length && database && network && successBlock);
  if (!query.length || !database || !network) {
    return;
  }
  
  NSManagedObjectContext *context = database.backgroundObjectContext;
  [network
   fetchTracksWithQuery:query
   toContext:context
   successBlock:^(MUZFetchTracksResponse *response) {
     if (response.tracks.count) {
       MUZSearch * search = [MUZSearch insertIntoContext:context
                                                   query:query
                                              searchTime:[NSDate new]
                                                  tracks:response.tracks];
  
       if (search) {
         [database saveWithCompletionBlock:^(BOOL succeed) {
           if (succeed) {
             if (successBlock) {
               dispatch_async(dispatch_get_main_queue(), ^{
                 successBlock(search);
               });
             }
           }
           else if (failureBlock) {
             failureBlock(0, nil, NO);
           }
         }];
       }
     }
     else {
       if (successBlock) {
         dispatch_async(dispatch_get_main_queue(), ^{
           successBlock(nil);
         });
       }
     }
   }
   failureBlock:^(NSInteger errorCode, NSString *errorMessage, BOOL wasCanceled) {
     if (failureBlock) {
       dispatch_async(dispatch_get_main_queue(), ^{
         failureBlock(errorCode, errorMessage, wasCanceled);
       });
     }
   }];
}

@end
