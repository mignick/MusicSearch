//
//  MUZDatabaseManager.h
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

@import CoreData;

typedef void(^MUZInitCompletionBlock)(NSString *errorMessage);

@interface MUZDatabaseManager : NSObject

@property (nonatomic,readonly) NSString *storeFilename;
@property (nonatomic,readonly) NSManagedObjectContext *mainObjectContext;
@property (nonatomic,readonly) NSManagedObjectContext *backgroundObjectContext;

- (instancetype)initWithStoreFilename:(NSString *)storeFilename
                      completionBlock:(MUZInitCompletionBlock)completionBlock;

- (void)saveWithCompletionBlock:(void(^)(BOOL succeed))completionBlock;

@end
