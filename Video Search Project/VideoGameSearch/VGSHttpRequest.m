//
//  VGSHttpRequest.m
//  Video Game Search
//
//  Created by Vincent Sam on 11/8/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import "VGSHttpRequest.h"
#import "VGSUtils.h"

static BOOL showNetworkActivityIndicator = NO;

@interface VGSHttpRequest ()

@property (nonatomic, readwrite, strong) NSURLConnection *currentConnection;
@property (nonatomic, readwrite, strong) NSHTTPURLResponse *httpResponse;
@property (nonatomic, readwrite, strong) NSMutableData *responseData;
@property (nonatomic, readwrite, strong) NSString *requestStatus;
@property (nonatomic, readwrite, copy) VGSHttpRequestBlock resultBlock;

@end

@implementation VGSHttpRequest

@synthesize currentConnection;
@synthesize httpResponse;
@synthesize responseData;
@synthesize requestStatus;
@synthesize resultBlock;

+ (void) enableNetworkActivityIndicator {
    
    @synchronized([VGSHttpRequest class]) {
        
        showNetworkActivityIndicator = YES;
    }
}

+ (void) disableNetworkActivityIndicator {
    
    @synchronized([VGSHttpRequest class]) {
        
        showNetworkActivityIndicator = NO;
    }
}

+ (VGSHttpRequest *) initGETRequest:(NSString *)httpUrl
                           withData:(NSDictionary *)data
{
    
    [VGSHttpRequest enableNetworkActivityIndicator];
    NSString *urlWithParameters = (data && data.allKeys.count > 0) ? [NSString stringWithFormat:@"%@?%@", httpUrl, [VGSUtils convertDictParamsToString: data]]: httpUrl;
    VGSHttpRequest *request = [VGSHttpRequest initGETRequest:urlWithParameters];
    return request;
}

+ (VGSHttpRequest *) initGETRequest:(NSString *)httpUrl {
    
    VGSHttpRequest *request = [VGSHttpRequest initWithURL:httpUrl];
    [request setHTTPMethod:GET_METHOD];
    return request;
}

- (void) executeWithBlock:(VGSHttpRequestBlock)block {
    
    resultBlock = block;
    
    // Create url connection and fire request
    currentConnection = [NSURLConnection connectionWithRequest:self delegate:self];
}

+ (VGSHttpRequest *) initWithURL:(NSString *)httpUrl {
    
    NSURL *url = [NSURL URLWithString:httpUrl];
    VGSHttpRequest *request = [VGSHttpRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                             timeoutInterval:HTTP_REQUEST_TIMEOUT];
    return request;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    responseData = [[NSMutableData alloc] init];
    httpResponse = (NSHTTPURLResponse *) response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    // Append the new data to the instance variable you declared
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    [VGSHttpRequest disableNetworkActivityIndicator];
    NSError* error;
    NSDictionary* jsonObject = [NSJSONSerialization
                                JSONObjectWithData:responseData //1
                                options:0
                                error:&error];
    
    GiantBomb *gameList = [GiantBomb initWithDictionary:jsonObject];
    [self.delegate updateGameList: gameList];
    VGSLogInfo(@"Connection success!");
    requestStatus = @""; // Success
    [self.delegate disableNetworkIndicatorWithErrorMessage: requestStatus];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    // The request has failed for some reason!
    // Check the error var
    requestStatus = NSLocalizedString(@"Connection failed!", @"Failed Connction text");
    VGSLogError(@"Connection fail: %@", [error description] );
    NSString *errorMessage = [NSString stringWithFormat:@"Failed Request: %@", NSLocalizedString([error.userInfo valueForKey:@"NSLocalizedDescription"], "Error Details")];
    [self.delegate disableNetworkIndicatorWithErrorMessage: errorMessage];
    [VGSHttpRequest disableNetworkActivityIndicator];
}

@end
