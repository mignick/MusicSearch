//
//  MUZViewControllerPresentationManager.h
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MUZViewControllerTransitionStyleConfiguration;

@interface MUZViewControllerPresentationManager : NSObject <UIViewControllerTransitioningDelegate>

- (instancetype)initWithTranstionStyle:(MUZViewControllerTransitionStyleConfiguration *)transitionConfiguration
           presentationControllerClass:(Class)presentationControllerClass;

@end
