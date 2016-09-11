//
//  MUZViewControllerTransition.m
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZViewControllerTransition.h"
#import "MUZViewControllerTransitionStyleConfiguration.h"

@implementation MUZViewControllerTransition

- (instancetype)initWithInDuration:(NSTimeInterval)inDuration
                       outDuration:(NSTimeInterval)outDuration
                         direction:(MUZViewControllerTransitionDirection)direction
{
  self = [super init];
  if (!self) return nil;
  
  _inDuration = inDuration;
  _outDuration = outDuration;
  _direction = direction;
  
  return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
  return (self.direction == MUZViewControllerTransitionDirectionIn ? self.inDuration : self.outDuration);
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
  switch (self.direction) {
    case MUZViewControllerTransitionDirectionIn:
      self.toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
      self.fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
      [[transitionContext containerView] addSubview:self.toViewController.view];
      break;
    case MUZViewControllerTransitionDirectionOut:
      self.toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
      self.fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
      break;
  }
}

@end
