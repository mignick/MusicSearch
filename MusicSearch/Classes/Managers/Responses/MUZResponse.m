//
//  MUZResponse.m
//  MusicSearch
//
//  Created by Nickolay Migel on 11/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZResponse.h"

@implementation MUZResponse

+ (NSArray *)arrayOfObjectsFromArrayOfDictionaries:(NSArray *)array
                                       targetClass:(Class)targetClass
                                         inContext:(NSManagedObjectContext *)context
{
  NSParameterAssert([array isKindOfClass:NSArray.class]);
  if (![array isKindOfClass:NSArray.class] || !array.count) {
    return nil;
  }
  
  NSMutableArray *objects = [NSMutableArray arrayWithCapacity:array.count];
  for (id dict in array) {
    if (![dict isKindOfClass:NSDictionary.class]) {
      continue;
    }
    
    id item = [[targetClass alloc] initWithDictionary:dict inContext:context];
    if (item) {
      [objects addObject:item];
    }
  }
  
  return [NSArray arrayWithArray:objects];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context
{
  self = [super init];
  if (!self || !dict) return nil;
 
  _context = context;
  
  return self;
}

@end
