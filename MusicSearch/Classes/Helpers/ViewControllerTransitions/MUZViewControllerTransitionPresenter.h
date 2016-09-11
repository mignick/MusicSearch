//
//  MUZViewControllerTransitionPresenter.h
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MUZViewControllerTransitionStyleConfiguration;

@interface MUZViewControllerTransitionPresenter : UIViewController

- (instancetype)initWithViewController:(__kindof UIViewController *)controllerToPresent
                                 style:(MUZViewControllerTransitionStyleConfiguration *)style
           presentationControllerClass:(Class)presentationControllerClass;

@end
