//
//  VGSConstants.h
//  Video Game Search
//
//  Created by Vincent Sam on 11/8/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Typedeffed result blocks that are call back functions
typedef void (^VGSHttpRequestBlock)(NSHTTPURLResponse *httpResponse, NSData *data, NSError *error);

/// Http request time out - in seconds
#define HTTP_REQUEST_TIMEOUT 60

/// Macros for Http Methods (String values)
#define GET_METHOD      @"GET"
#define POST_METHOD     @"POST"
#define PUT_METHOD      @"PUT"
#define DELETE_METHOD   @"DELETE"

// Macros to detect the device's orientation
#define VGSDeviceOrientationPortrait() ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
#define VGSDeviceOrientationLandscape() (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) ||  ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight))

#define VGSLogInfo(A, ...) \
fprintf(stderr, "I: (%s) (%s:%d): ", __PRETTY_FUNCTION__, \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] cStringUsingEncoding:NSUTF8StringEncoding], \
__LINE__); \
NSLog((A), ##__VA_ARGS__);

#define VGSLogWarning(A, ...) \
fprintf(stderr, "W: (%s) (%s:%d): ", __PRETTY_FUNCTION__, \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] cStringUsingEncoding:NSUTF8StringEncoding], \
__LINE__); \
NSLog((A), ##__VA_ARGS__);

#define VGSLogError(A, ...) \
fprintf(stderr, "E: (%s) (%s:%d): ", __PRETTY_FUNCTION__, \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] cStringUsingEncoding:NSUTF8StringEncoding], \
__LINE__); \
NSLog((A), ##__VA_ARGS__);

/// For when you need a weak reference of an object, example: `VGSBlockWeakObject(obj) wobj = obj;`
#define VGSBlockWeakObject(o) __typeof__(o) __weak

/// For when you need a weak reference to self, example: `VGSBlockWeakSelf wself = self;`
#define VGSBlockWeakSelf VGSBlockWeakObject(self)

/// Macros to urlencode unsafe strings
#define VGSUrlEncodeString(A) \
(__bridge NSString *) (CFURLCreateStringByAddingPercentEscapes ( NULL, (CFStringRef)(A), NULL, CFSTR("/%&=?$#+-~@<>|\\*,.()[]{}^!"), kCFStringEncodingUTF8))

/// Macros to detect null values
#define VGSValueIsNull(value) \
(!value || value == (id)[NSNull null])

#define VGSParseString(A) \
[NSString stringWithFormat: "%s", (A isKindOfClass:[NSString class]) ? A : ""]

#define STATUSBAR_HEIGHT 20
#define SCREEN_HEIGHT (( double )[ [ UIScreen mainScreen ] bounds ].size.height - STATUSBAR_HEIGHT)
#define SCREEN_WIDTH (( double )[ [ UIScreen mainScreen ] bounds ].size.width)

@interface VGSConstants : NSObject

@end
