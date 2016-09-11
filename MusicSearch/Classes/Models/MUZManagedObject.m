//
//  MUZManagedObject.m
//  MusicSearch
//
//  Created by Nickolay Migel on 11/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZManagedObject.h"

@implementation MUZManagedObject

+ (NSString *)entityName
{
  NSString *className = NSStringFromClass(self);
  return ([className hasPrefix:@"MUZ"] ? [className substringFromIndex:3] : className);
}

+ (instancetype)createNewObjectWithContext:(NSManagedObjectContext *)context
{
  NSParameterAssert(context);
  NSManagedObjectModel *model = [context.persistentStoreCoordinator managedObjectModel];
  NSEntityDescription *entity = [[model entitiesByName] objectForKey:[self entityName]];
  return (MUZManagedObject *)[[NSManagedObject alloc] initWithEntity:entity
                                      insertIntoManagedObjectContext:nil];
}

+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context
{
  NSParameterAssert(context);
  return (MUZManagedObject *)[NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                                           inManagedObjectContext:context];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context
{
  self = [self.class createNewObjectWithContext:context];
  if (!self) return nil;
  
  return self;
}

@end
