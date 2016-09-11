//
//  UIViewController+MUZAlert.m
//  MusicSearch
//
//  Created by Nickolay Migel on 11/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "UIViewController+MUZAlert.h"

@implementation UIViewController (MUZAlert)

- (void)muz_showAlertWithTitle:(NSString *)title message:(NSString *)message
{
  [UIAlertController showAlertInViewController:self
                                     withTitle:title
                                       message:message
                             cancelButtonTitle:nil
                        destructiveButtonTitle:nil
                             otherButtonTitles:@[@"Ok"]
                                      tapBlock:nil];
}

@end
