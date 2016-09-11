//
//  MUZViewControllerBounceDownTransition.m
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZViewControllerBounceDownTransition.h"

@implementation MUZViewControllerBounceDownTransition

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
  [super animateTransition:transitionContext];
  
  switch (self.direction) {
    case MUZViewControllerTransitionDirectionIn: {
      self.toViewController.view.bounds = ({
        CGRect bounds = self.toViewController.view.bounds;
        bounds.origin = CGPointMake(0, self.fromViewController.view.bounds.size.height);
        bounds;
      });
      [UIView animateWithDuration:self.inDuration
                            delay:0.0
           usingSpringWithDamping:0.6
            initialSpringVelocity:0.0
                          options:UIViewAnimationOptionCurveEaseOut
                       animations:^{
                         self.toViewController.view.bounds = self.fromViewController.view.bounds;
                       } completion:^(BOOL finished) {
                         [transitionContext completeTransition:finished];
                       }];
      break;
    }
    case MUZViewControllerTransitionDirectionOut: {
      [UIView animateWithDuration:self.outDuration
                            delay:0.0
                          options:UIViewAnimationOptionCurveEaseIn
                       animations:^{
                         self.fromViewController.view.bounds = ({
                           CGRect bounds = self.fromViewController.view.bounds;
                           bounds.origin = CGPointMake(0, self.fromViewController.view.bounds.size.height);
                           bounds;
                         });
                         self.fromViewController.view.alpha = 0.0f;
                       } completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                       }];
      break;
    }
  }
}

@end
