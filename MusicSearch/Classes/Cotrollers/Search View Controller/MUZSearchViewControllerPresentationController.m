//
//  MUZSearchViewControllerPresentationController.m
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZSearchViewControllerPresentationController.h"

@interface MUZSearchViewControllerPresentationController()

@property (nonatomic,assign) CGFloat navigationBarHeight;

@end

@implementation MUZSearchViewControllerPresentationController

- (void)presentationTransitionWillBegin
{
  CGRect containerBounds = self.containerView.bounds;
  
  if ([self.presentingViewController isKindOfClass:UINavigationController.class]) {
    UINavigationController *navigation = (UINavigationController *)self.presentingViewController;
    self.navigationBarHeight = CGRectGetMaxY(navigation.navigationBar.frame);
  }
  
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

- (CGRect)frameOfPresentedViewInContainerView
{
  CGRect frame = CGRectZero;
  frame.size = [self sizeForChildContentContainer:self.presentedViewController
                          withParentContainerSize:self.containerView.bounds.size];
  frame.size.height = self.presentedViewController.preferredContentSize.height;
  frame.origin.y = self.navigationBarHeight;
  
  return frame;
}

@end
