//
//  MUZManagedObjectProtocol.h
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MUZManagedObjectProtocol <NSObject>

- (instancetype)initWithDictionary:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context;

@end
