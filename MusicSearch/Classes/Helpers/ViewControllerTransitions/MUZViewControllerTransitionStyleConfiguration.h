//
//  MUZViewControllerTransitionStyleConfiguration.h
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MUZViewControllerTransitionStyle) {
  MUZViewControllerTransitionStyleBounceDown
};

@interface MUZViewControllerTransitionStyleConfiguration : NSObject

@property (nonatomic,assign) MUZViewControllerTransitionStyle style;
@property (nonatomic,assign) CGFloat inDuration;
@property (nonatomic,assign) CGFloat outDuration;

+ (instancetype)configurationWithStyle:(MUZViewControllerTransitionStyle)Style
                            inDuration:(CGFloat)inDuration
                           outDuration:(CGFloat)outDuration;

@end
