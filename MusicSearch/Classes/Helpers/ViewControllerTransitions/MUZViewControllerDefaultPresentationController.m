//
//  MUZViewControllerDefaultPresentationController.m
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZViewControllerDefaultPresentationController.h"

@implementation MUZViewControllerDefaultPresentationController

- (UIView *)dimmingView
{
  if (!_dimmingView) {
    _dimmingView = [[UIView alloc] initWithFrame:CGRectZero];
    _dimmingView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    [_dimmingView addGestureRecognizer:({
      [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewWasTapped)];
    })];
  }
  return _dimmingView;
}

- (void)presentationTransitionWillBegin
{
  CGRect containerBounds = self.containerView.bounds;
  
  self.dimmingView.alpha = 0.0f;
  self.dimmingView.frame = containerBounds;
  [self.containerView insertSubview:self.dimmingView atIndex:0];
  
  void(^animations)() = ^{
    self.dimmingView.alpha = 1.0f;
  };
  
  id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
  if (coordinator) {
    [coordinator
     animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
       animations();
     } completion:nil];
  }
  else {
    animations();
  }
}

- (void)dismissalTransitionWillBegin
{
  void(^animations)() = ^{
    self.dimmingView.alpha = 0.0f;
  };
  
  id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
  if (coordinator) {
    [coordinator
     animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
       animations();
     } completion:nil];
  }
  else {
    animations();
  }
}

- (UIModalPresentationStyle)adaptivePresentationStyle
{
  return UIModalPresentationNone;
}

- (BOOL)shouldPresentInFullscreen
{
  return YES;
}

- (void)containerViewWillLayoutSubviews
{
  self.presentedView.frame = [self frameOfPresentedViewInContainerView];
}

#pragma mark Actions

- (void)dimmingViewWasTapped
{
  [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
