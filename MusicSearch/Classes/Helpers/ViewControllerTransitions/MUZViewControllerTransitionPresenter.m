//
//  MUZViewControllerTransitionPresenter.m
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZViewControllerTransitionPresenter.h"
#import "MUZViewControllerPresentationManager.h"

@interface MUZViewControllerTransitionPresenter()

@property (nonatomic,strong) UIViewController *viewController;
@property (nonatomic,strong) MUZViewControllerPresentationManager *presentationManager;

@end

@implementation MUZViewControllerTransitionPresenter

- (void)dealloc
{
  [_viewController willMoveToParentViewController:nil];
  [_viewController removeFromParentViewController];
}

- (instancetype)initWithViewController:(__kindof UIViewController *)controllerToPresent
                                 style:(MUZViewControllerTransitionStyleConfiguration *)style
           presentationControllerClass:(Class)presentationControllerClass
{
  self = [super initWithNibName:nil bundle:nil];
  if (!self) return nil;
  
  _viewController = controllerToPresent;
  _presentationManager = [[MUZViewControllerPresentationManager alloc]
                          initWithTranstionStyle:style
                          presentationControllerClass:presentationControllerClass];
  
  self.transitioningDelegate = _presentationManager;
  self.modalPresentationStyle = UIModalPresentationCustom;
  
  [self addChildViewController:controllerToPresent];
  [self.view addSubview:controllerToPresent.view];
  [controllerToPresent didMoveToParentViewController:self];
  
  return self;
}

- (void)loadView
{
  self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.view.backgroundColor = [UIColor clearColor];
}

- (CGSize)preferredContentSize
{
  return [self.viewController preferredContentSize];
}

@end
