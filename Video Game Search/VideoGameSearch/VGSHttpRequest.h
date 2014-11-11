//
//  VGSHttpRequest.h
//  VideoGameSearch
//
//  Created by Vincent Sam on 11/8/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VGSConstants.h"
#import "GiantBomb.h"

@protocol VGSDataModificationDelegate;

@interface VGSHttpRequest : NSMutableURLRequest<NSURLConnectionDataDelegate, NSURLConnectionDataDelegate>

+ (void) enableNetworkActivityIndicator;
+ (void) disableNetworkActivityIndicator;


+ (VGSHttpRequest *) initWithURL:(NSString *)httpUrl;
+ (VGSHttpRequest *) initGETRequest:(NSString *)httpUrl;
+ (VGSHttpRequest *) initGETRequest:(NSString *)httpUrl
                           withData:(NSDictionary *)data;


@property (nonatomic, readwrite, weak) id<VGSDataModificationDelegate> delegate;
- (void) executeWithBlock:(VGSHttpRequestBlock)block;
@end

@protocol VGSDataModificationDelegate <NSObject>
- (void) updateGameList:(GiantBomb *)searchResults;
- (void) disableNetworkIndicatorWithErrorMessage:(NSString*)message;
@end