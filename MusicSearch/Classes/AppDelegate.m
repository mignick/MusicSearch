//
//  AppDelegate.m
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // disable exessive loging
  [KZPropertyMapper logIgnoredValues:NO];
  
  self.networkManager = [[MUZNetworkManager alloc] initWithBaseURL:[NSURL URLWithString:MUZApiBaseUrl]];
  
  // check if we need to migrate data & show some temp UI with progress
  BOOL needMigration = NO;
  if (needMigration) {
    //self.rootViewController = ...
  }
  self.databaseManager = [[MUZDatabaseManager alloc]
                          initWithStoreFilename:MUZDatabaseFilename
                          completionBlock:^(NSString *errorMessage) {
                            if (errorMessage) {
                              NSLog(@"Failed to init database: %@", errorMessage);
                              // show error controller
                              //self.rootViewController = ...
                            }
                          }];
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.window.rootViewController = (self.rootViewController ? : [self makeRootViewController]);
  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  [self.databaseManager saveWithCompletionBlock:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  [self.databaseManager saveWithCompletionBlock:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  [self.databaseManager saveWithCompletionBlock:nil];
}

#pragma mark UI

- (UIViewController *)makeRootViewController
{
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  UIViewController *controller = [storyboard instantiateInitialViewController];
  UIViewController<MUZTracksControllerDependencyProtocol> *rootController;
  if ([controller isKindOfClass:UINavigationController.class]) {
    UINavigationController *navigation = (UINavigationController *)controller;
    rootController = [navigation.viewControllers firstObject];
  }
  
  [rootController setDependenciesWithDatabase:self.databaseManager network:self.networkManager];
  return controller;
}

@end
