//
//  MUZFetchTracksResponse.m
//  MusicSearch
//
//  Created by Nickolay Migel on 11/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZFetchTracksResponse.h"
#import "MUZTrack.h"
#import "MUZResponse.h"

@implementation MUZFetchTracksResponse

- (instancetype)initWithDictionary:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context
{
  self = [super initWithDictionary:dict inContext:context];
  if (!self) return nil;
  
  [KZPropertyMapper mapValuesFrom:dict toInstance:self usingMapping:
  @{
    @"resultCount": KZProperty(trackCount),
    @"results": KZCall(tracksFromValue:, tracks)
    }];
  
  return self;
}

#pragma mark Private

- (NSArray *)tracksFromValue:(id)value
{
  return [MUZResponse arrayOfObjectsFromArrayOfDictionaries:value
                                                targetClass:MUZTrack.class
                                                  inContext:self.context];
}

@end
