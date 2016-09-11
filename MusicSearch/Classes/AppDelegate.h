//
//  AppDelegate.h
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic,strong) UIWindow *window;
@property (nonatomic,strong) UIViewController *rootViewController;

@property (nonatomic,strong) MUZDatabaseManager *databaseManager;
@property (nonatomic,strong) MUZNetworkManager *networkManager;

@end

