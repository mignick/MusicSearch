//
//  MUZNetworkManager.h
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@class MUZFetchTracksResponse;

@interface MUZNetworkManager : AFHTTPSessionManager

- (void)fetchTracksWithQuery:(NSString *)query
                   toContext:(NSManagedObjectContext *)context
                successBlock:(void(^)(MUZFetchTracksResponse *tracksResponse))successBlock
                failureBlock:(MUZOpeationFailureBlock)failureBlock;

@end
