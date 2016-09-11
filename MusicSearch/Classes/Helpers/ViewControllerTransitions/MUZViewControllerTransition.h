//
//  MUZViewControllerTransition.h
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MUZViewControllerTransitionDirection) {
  MUZViewControllerTransitionDirectionIn,
  MUZViewControllerTransitionDirectionOut
};

@interface MUZViewControllerTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic,strong) UIViewController *toViewController;
@property (nonatomic,strong) UIViewController *fromViewController;

@property (nonatomic,assign) NSTimeInterval inDuration;
@property (nonatomic,assign) NSTimeInterval outDuration;
@property (nonatomic,assign) MUZViewControllerTransitionDirection direction;

- (instancetype)initWithInDuration:(NSTimeInterval)inDuration
                       outDuration:(NSTimeInterval)outDuration
                         direction:(MUZViewControllerTransitionDirection)direction;

@end
