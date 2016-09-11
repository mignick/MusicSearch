//
//  MUZManagedObject.h
//  MusicSearch
//
//  Created by Nickolay Migel on 11/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MUZManagedObjectProtocol.h"

@interface MUZManagedObject : NSManagedObject <MUZManagedObjectProtocol>

+ (NSString *)entityName;
+ (instancetype)createNewObjectWithContext:(NSManagedObjectContext *)context;
+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context;

@end
