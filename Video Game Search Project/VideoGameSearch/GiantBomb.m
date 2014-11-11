//
//  GiantBomb.m
//  Video Game Search
//
//  Created by Vincent Sam on 11/8/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import "GiantBomb.h"
#import "VGSConstants.h"

@implementation GiantBomb

+ (instancetype)initWithDictionary:(NSDictionary *)data
{
    return [[self alloc] initWithDictionary:data];
}

- (instancetype)initWithDictionary:(NSDictionary *)data
{
    self = [self init];
    
    if (self) {
        if (data) {
            if ([[data valueForKey:GB_ERROR] isEqualToString: GB_SEARCH_SUCCESS]) {
                NSMutableArray *refinedSearchResults = [@[] mutableCopy];
                id searchResult = [data valueForKey:GB_SEARCH_RESULTS];
                
                if ([searchResult isKindOfClass:[NSArray class]]) {
                    SearchResult *searchRecord = [[SearchResult alloc] init];
                    for (id resultData in searchResult) {
                        if (resultData != (id)[NSNull null] && [resultData isKindOfClass:[NSDictionary class]]) {
                            searchRecord = [SearchResult initWithDicitonary:resultData];
                            [refinedSearchResults addObject:searchRecord];
                        }
                        
                    }
                }
                [self setResults: refinedSearchResults];
            }
        }
    }
    return self;
}

+ (NSDictionary *)gBasebHttpUrlParams
{
    return @{@"api_key": GB_DEVELOPER_KEY,
             @"format": @"json",
             @"resources": @"game"};
}

@end
