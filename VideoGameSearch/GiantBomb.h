//
//  GiantBomb.h
//  Video Game Search
//
//  Created by Vincent Sam on 11/8/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchResult.h"

/// Developer Main Resources
#define GB_BASE_SERVICE_URL     @"http://www.giantbomb.com/api/search/"
#define GB_DEVELOPER_KEY        @"930fffaa3bc433ec0ab8cb9e1e6961531c670f54"

/// JSON keys
#define GB_ERROR                @"error"
#define GB_SEARCH_RESULTS       @"results"
#define GB_TOTOAL_RESULTS       @"number_of_total_results"
#define GG_STATUS_CODE          @"status_code"

#define GB_SEARCH_SUCCESS       @"OK"

@interface GiantBomb : NSObject

@property (nonatomic, readwrite, strong) NSArray *results;

+ (instancetype)initWithDictionary:(NSDictionary *)data;
+ (NSDictionary *)gBasebHttpUrlParams;

@end
