//
//  MUZViewControllerTransitionStyleConfiguration.m
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "MUZViewControllerTransitionStyleConfiguration.h"

@implementation MUZViewControllerTransitionStyleConfiguration

+ (instancetype)configurationWithStyle:(MUZViewControllerTransitionStyle)style
                            inDuration:(CGFloat)inDuration
                           outDuration:(CGFloat)outDuration
{
  MUZViewControllerTransitionStyleConfiguration *config = [MUZViewControllerTransitionStyleConfiguration new];
  config.style = style;
  config.inDuration = inDuration;
  config.outDuration = outDuration;
  return config;
}

@end
