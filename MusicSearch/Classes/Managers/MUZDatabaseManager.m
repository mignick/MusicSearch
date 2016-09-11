//
//  MUZDatabaseManager.m
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZDatabaseManager.h"

@interface MUZDatabaseManager()

@property (nonatomic,strong) NSString *storeFilename;
@property (nonatomic,strong) NSManagedObjectContext *mainObjectContext;
@property (nonatomic,strong) NSManagedObjectContext *backgroundObjectContext;

@property (nonatomic,copy) MUZInitCompletionBlock completionBlock;

@end

@implementation MUZDatabaseManager

- (instancetype)initWithStoreFilename:(NSString *)storeFilename
                      completionBlock:(MUZInitCompletionBlock)completionBlock
{
  self = [super init];
  if (!self) return nil;
  
  self.storeFilename = [storeFilename copy];
  self.completionBlock = completionBlock;
  [self initCoreDataStack];
  
  return self;
}

- (void)saveWithCompletionBlock:(void (^)(BOOL succeed))completionBlock
{
  NSAssert(!([self.backgroundObjectContext hasChanges] && [self.mainObjectContext hasChanges]), @"No changes in contexts!");
  if (![self.backgroundObjectContext hasChanges] && ![self.mainObjectContext hasChanges]) {
    completionBlock ? completionBlock(YES) : nil;
    return;
  }
  
  [self.mainObjectContext performBlockAndWait:^{
    NSError *error = nil;
    NSAssert([self.mainObjectContext save:&error],
             @"Failed to save main context %@\n%@",
             error.localizedDescription,
             error.userInfo);
    
    if (!error) {
      [self.backgroundObjectContext performBlockAndWait:^{
        NSError *error2 = nil;
        NSAssert([self.backgroundObjectContext save:&error2],
                 @"Failed to save bgrd context %@\n%@",
                 error2.localizedDescription,
                 error2.userInfo);
        completionBlock ? completionBlock(!error2) : nil;
      }];
    }
    else {
      completionBlock ? completionBlock(NO) : nil;
    }
  }];  
}

#pragma mark Private

- (void)initCoreDataStack
{
  if (self.mainObjectContext) {
    return;
  }
  
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.storeFilename withExtension:@"momd"];
  NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  [self validateResultObject:mom errorMessage:@"No model to generate store"];
  
  if (mom) {
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    [self validateResultObject:coordinator errorMessage:@"Failed to init store coordinator"];
    
    if (coordinator) {
      self.backgroundObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
      self.backgroundObjectContext.persistentStoreCoordinator = coordinator;
      
      self.mainObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
      self.mainObjectContext.parentContext = self.backgroundObjectContext;
      
      [self initStore];
    }
  }
}

- (void)initStore
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    NSPersistentStoreCoordinator *psc = [self.backgroundObjectContext persistentStoreCoordinator];
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption: @(YES),
                              NSInferMappingModelAutomaticallyOption: @(YES),
                              //NSSQLitePragmasOption: @{@"jornal_mode": @"DELETE"}
                              };
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURLS = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURLS URLByAppendingPathComponent:[self.storeFilename stringByAppendingString:@".sqlite"]];
    
    NSError *error = nil;
    NSPersistentStore *ps = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                              configuration:nil
                                                        URL:storeURL
                                                    options:options
                                                      error:&error];
    
    if (!ps || error) {
      [self validateResultObject:ps errorMessage:[error localizedDescription]];
    }
    else {
      if (self.completionBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
          self.completionBlock(nil);
        });
      }
    }
  });
}

- (void)validateResultObject:(id)resultObject errorMessage:(NSString *)errorMessage
{
  NSAssert(resultObject, errorMessage);
  if (self.completionBlock && !resultObject) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.completionBlock(errorMessage);
    });
  }
}

@end
