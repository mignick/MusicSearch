//
//  MUZDependencyProtocols.h
//  MusicSearch
//
//  Created by Nickolay Migel on 11/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MUZTrack, MUZSearch;

@protocol MUZDependencyProtocol <NSObject>

- (void)assertDependencies;

@end

@protocol MUZTracksControllerDependencyProtocol <MUZDependencyProtocol>

- (void)setDependenciesWithDatabase:(MUZDatabaseManager *)database network:(MUZNetworkManager *)network;

@end

@protocol MUZSearchControllerDependencyProtocol <MUZDependencyProtocol>

- (void)setDependenciesWithDatabase:(MUZDatabaseManager *)database completionBlock:(void(^)(MUZSearch *search))compeletionBlock;

@end

@protocol MUZTrackProfileControllerDependencyProtocol <MUZDependencyProtocol>

- (void)setDependenciesWithTrack:(MUZTrack *)track;

@end
