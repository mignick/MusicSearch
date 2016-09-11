//
//  MUZFetchTracksResponse.h
//  MusicSearch
//
//  Created by Nickolay Migel on 11/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZResponse.h"

@interface MUZFetchTracksResponse : MUZResponse

@property (nonatomic,assign) NSInteger trackCount;
@property (nonatomic,readonly) NSArray *tracks;

@end
