//
//  MUZNetworkManager.m
//  MusicSearch
//
//  Created by Nickolay Migel on 10/09/16.
//  Copyright © 2016 Nickolay Migel. All rights reserved.
//

#include <AFNetworkActivityIndicatorManager.h>

#import "MUZNetworkManager.h"
#import "MUZFetchTracksResponse.h"
#import "MUZSearch.h"

@implementation MUZNetworkManager

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
  self = [super initWithBaseURL:url sessionConfiguration:configuration];
  if (!self) return nil;
  
  [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
  
  self.completionQueue = dispatch_queue_create("com.mignick.musicsearch.net.queue.serial.completions", DISPATCH_QUEUE_SERIAL);
  
  return self;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
  return [self initWithBaseURL:url sessionConfiguration:nil];
}

#pragma mark Search

- (void)fetchTracksWithQuery:(NSString *)query
                   toContext:(NSManagedObjectContext *)context
                successBlock:(void (^)(MUZFetchTracksResponse *))successBlock
                failureBlock:(MUZOpeationFailureBlock)failureBlock
{
  NSParameterAssert(query.length && context && successBlock);
  
  if (!query.length) {
    if (successBlock) {
      dispatch_async(dispatch_get_main_queue(), ^{
        successBlock(nil);
      });
      return;
    }
  }
  
  NSDictionary *params = @{
                           @"term": query,
                           @"media": @"music"
                           };

  [self
   GET:@"search"
   parameters:params
   progress:nil
   success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
     
     MUZFetchTracksResponse *response = [[MUZFetchTracksResponse alloc]
                                         initWithDictionary:responseObject
                                         inContext:context];
     if (successBlock) {
       successBlock(response);
     }
     
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    if (failureBlock) {
      BOOL wasCanceled = ([error.domain isEqualToString:NSURLErrorDomain]) && (NSURLErrorCancelled == error.code);
      dispatch_async(dispatch_get_main_queue(), ^{
        failureBlock(0, [self errorToString:error], wasCanceled);
      });
    }
  }];
}

#pragma mark Private

- (NSString *)errorToString:(NSError *)error
{
  NSParameterAssert(error);
  
  switch (error.code) {
    case NSURLErrorTimedOut:
    case NSURLErrorNetworkConnectionLost:
    case NSURLErrorDNSLookupFailed:
    case NSURLErrorNotConnectedToInternet:
    case NSURLErrorCannotConnectToHost:
      return NSLocalizedString(@"Net.ConnectivityError", nil);
    default:
      return NSLocalizedString(@"Net.APIError", nil);
  }
}

@end
