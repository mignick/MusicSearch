//
//  MUZResponse.h
//  MusicSearch
//
//  Created by Nickolay Migel on 11/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUZResponse : NSObject

@property (nonatomic,strong,readonly) NSManagedObjectContext *context;

+ (NSArray *)arrayOfObjectsFromArrayOfDictionaries:(NSArray *)array
                                       targetClass:(Class)targetClass
                                         inContext:(NSManagedObjectContext *)context;

- (instancetype)initWithDictionary:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context;

@end
