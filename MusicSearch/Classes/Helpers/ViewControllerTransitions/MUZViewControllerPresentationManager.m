//
//  MUZViewControllerPresentationManager.m
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZViewControllerPresentationManager.h"
#import "MUZViewControllerBounceDownTransition.h"
#import "MUZViewControllerTransitionStyleConfiguration.h"

@interface MUZViewControllerPresentationManager()

@property (nonatomic,strong) MUZViewControllerTransitionStyleConfiguration *transitionConfiguration;
@property (nonatomic,strong) Class presentationControllerClass;

@end

@implementation MUZViewControllerPresentationManager

- (instancetype)initWithTranstionStyle:(MUZViewControllerTransitionStyleConfiguration *)transitionConfiguration
           presentationControllerClass:(Class)presentationControllerClass
{
  self = [super init];
  if (!self) return nil;
  
  _transitionConfiguration = transitionConfiguration;
  _presentationControllerClass = presentationControllerClass;
  
  return self;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source
{
  return [[self.presentationControllerClass alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
  MUZViewControllerTransition *transitionAnimator;
  switch (self.transitionConfiguration.style) {
    case MUZViewControllerTransitionStyleBounceDown:
      transitionAnimator = [[MUZViewControllerBounceDownTransition alloc]
                            initWithInDuration:self.transitionConfiguration.inDuration
                            outDuration:self.transitionConfiguration.outDuration
                            direction:MUZViewControllerTransitionDirectionIn];
      break;
  }
  
  return transitionAnimator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
  MUZViewControllerTransition *transitionAnimator;
  switch (self.transitionConfiguration.style) {
    case MUZViewControllerTransitionStyleBounceDown:
      transitionAnimator = [[MUZViewControllerBounceDownTransition alloc]
                            initWithInDuration:self.transitionConfiguration.inDuration
                            outDuration:self.transitionConfiguration.outDuration
                            direction:MUZViewControllerTransitionDirectionOut];
      break;
  }
  
  return transitionAnimator;
}

@end
