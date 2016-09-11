//
//  Constants.h
//  MusicSearch
//
//  Created by Nickolay Migel on 11/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

// General error block type
typedef void(^MUZOpeationFailureBlock)(NSInteger errorCode, NSString *errorMessage, BOOL wasCanceled);

// DB store filename
extern NSString * const MUZDatabaseFilename;

// API endpoints
extern NSString * const MUZApiBaseUrl;
