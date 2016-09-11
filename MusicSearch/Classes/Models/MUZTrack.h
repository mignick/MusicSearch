//
//  MUZTrack.h
//  MusicSearch
//
//  Created by Nickolay Migel on 11/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZManagedObject.h"

@class MUZSearch;

@interface MUZTrack : MUZManagedObject

@property (nonatomic,assign,readonly) NSInteger artistId;
@property (nonatomic,assign,readonly) NSInteger collectionId;
@property (nonatomic,assign,readonly) NSInteger trackId;
@property (nonatomic,strong,readonly) NSString *artistName;
@property (nonatomic,strong,readonly) NSString *collectionName;
@property (nonatomic,strong,readonly) NSString *trackName;
@property (nonatomic,strong,readonly) NSString *artworkSmall;
@property (nonatomic,strong,readonly) NSString *artworkBig;
@property (nonatomic,strong,readonly) NSString *genre;
@property (nonatomic,strong,readonly) NSDate *releaseDate;

+ (NSFetchedResultsController *)fetchedResultsControllerForSearch:(MUZSearch *)search;

- (void)updateFromTrack:(MUZTrack *)track;

@end
