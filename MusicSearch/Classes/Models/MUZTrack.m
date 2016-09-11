//
//  MUZTrack.m
//  MusicSearch
//
//  Created by Nickolay Migel on 11/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZTrack.h"
#import "MUZSearch.h"

@interface MUZTrack()

@property (nonatomic,assign) NSInteger artistId;
@property (nonatomic,assign) NSInteger collectionId;
@property (nonatomic,assign) NSInteger trackId;
@property (nonatomic,strong) NSString *artistName;
@property (nonatomic,strong) NSString *collectionName;
@property (nonatomic,strong) NSString *trackName;
@property (nonatomic,strong) NSString *artworkUrl30;
@property (nonatomic,strong) NSString *artworkUrl60;
@property (nonatomic,strong) NSString *artworkUrl100;
@property (nonatomic,strong) NSString *genre;
@property (nonatomic,strong) NSDate *releaseDate;

@end

@implementation MUZTrack

@dynamic artistId;
@dynamic collectionId;
@dynamic trackId;
@dynamic artistName;
@dynamic collectionName;
@dynamic trackName;
@dynamic artworkUrl30;
@dynamic artworkUrl60;
@dynamic artworkUrl100;
@dynamic genre;
@dynamic releaseDate;

+ (NSFetchedResultsController *)fetchedResultsControllerForSearch:(MUZSearch *)search
{
  NSParameterAssert(search);
  
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
  request.fetchBatchSize = 25;
  request.returnsObjectsAsFaults = NO;
  request.predicate = [NSPredicate predicateWithFormat:@"ANY searches = %@", search];
  request.sortDescriptors = @[];
  
  NSFetchedResultsController *controller = [[NSFetchedResultsController alloc]
                                            initWithFetchRequest:request
                                            managedObjectContext:search.managedObjectContext
                                            sectionNameKeyPath:nil
                                            cacheName:nil];
  return controller;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context
{
  self = [super initWithDictionary:dict inContext:context];
  if (!self || !dict) return nil;
  
  [KZPropertyMapper mapValuesFrom:dict toInstance:self usingMapping:
  @{
    @"artistId": KZProperty(artistId),
    @"collectionId": KZProperty(collectionId),
    @"trackId": KZProperty(trackId),
    
    @"artistName": KZProperty(artistName),
    @"collectionName": KZProperty(collectionName),
    @"trackName": KZProperty(trackName),
    
    @"artworkUrl30": KZProperty(artworkUrl30),
    @"artworkUrl60": KZProperty(artworkUrl60),
    @"artworkUrl100": KZProperty(artworkUrl100),
    
    @"primaryGenreName": KZProperty(genre),
    @"releaseDate": KZBox(Date, releaseDate)
    }];
    
  return self;
}

- (void)updateFromTrack:(MUZTrack *)track
{
  NSParameterAssert(track);
  if (!track) {
    return;
  }
  
  self.artistId = track.artistId;
  self.collectionId = track.collectionId;
  self.trackId = track.trackId;
  self.artistName = track.artistName;
  self.collectionName = track.collectionName;
  self.trackName = track.trackName;
  self.genre = track.genre;
  self.releaseDate = track.releaseDate;
}

- (NSString *)artworkSmall
{
  return (self.artworkUrl30 ? : (self.artworkUrl60 ? : self.artworkUrl100));
}

- (NSString *)artworkBig
{
  return (self.artworkUrl100 ? : (self.artworkUrl60 ? : self.artworkUrl30));
}

@end
