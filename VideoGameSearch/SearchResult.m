//
//  SearchResult.m
//  Video Game Search
//
//  Created by Vincent Sam on 11/8/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import "SearchResult.h"
#import "VGSConstants.h"

@interface SearchResult() {
    NSDateFormatter *dateFormat;
    NSAttributedString *parsedString;
}
@end

@implementation SearchResult

@synthesize name;
@synthesize desc;
@synthesize gameId;
@synthesize reviews;
@synthesize imageURL;
@synthesize postDate;
@synthesize detailURL;

+ (instancetype)initWithDicitonary:(NSDictionary *)data
{
    return [[self alloc] initWithDictionary:data];
}

- (instancetype)initWithDictionary:(NSDictionary *)data
{
    self = [self init];
    
    if (self) {
        if (data) {
            [self setName:[data valueForKey:SR_NAME]];
            [self setGameId:[data valueForKey:SR_ID]];
            [self setImageURL:[self deriveImageURL:[data valueForKey:SR_IMAGE]]];
            long numberOfReviews = (long)[[data valueForKey:SR_USER_REVIEWS] integerValue];
            NSString *userReviews = [NSString stringWithFormat: @"%@", (numberOfReviews <= 0) ? @"No" : ([NSString stringWithFormat: @"%ld", numberOfReviews])];
            [self setReviews: [NSString stringWithFormat: @"%@ reviews", userReviews]];
            [self setDetailURL:[data valueForKey:SR_SITE_DETAIL_URL]];
            id shortDes = [data valueForKey:SR_DECK];
            if (!VGSValueIsNull(shortDes))
                [self setDesc: [data valueForKey:SR_DECK]];
            else if (!VGSValueIsNull([data valueForKey:SR_DESCRIPTION]) )
                [self setDesc:[data valueForKey:SR_DESCRIPTION]];
            else
                [self setDesc: name]; // default video game title
            [self setDesc:[self parseHtmlString:desc]];
            [self setPostDate: [NSString stringWithFormat:@"Published: %@", [self formatDate:[data valueForKey:SR_DATE_ADDED]]]];
        }
    }
    return self;
}


- (NSString *)formatDate:(NSString*)postedOn
{
    if (!dateFormat) {
        dateFormat = [[NSDateFormatter alloc] init];
    }
    NSString* postedOnDate = [[postedOn componentsSeparatedByString: @" "] objectAtIndex: 0];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *formattedDate = [dateFormat dateFromString:postedOnDate];
    NSString *datePosted = [dateFormat stringFromDate:formattedDate];
    return datePosted;
}

- (NSString *)deriveImageURL:(NSDictionary *)data
{
    NSString * mImageURL = [data valueForKey:SR_IMAGE_TYPES[imageIcon]];
    
    if (VGSValueIsNull(mImageURL) && [data isKindOfClass:[NSNull class]]) {
        return GIANT_BOMB_LOGO;
    }
    
    if (VGSValueIsNull(mImageURL)) {
        for (NSString *image in data) {
            if (!VGSValueIsNull(image)) {
                mImageURL = image;
                break;
            }
        }
    }

    return VGSValueIsNull(mImageURL) ? GIANT_BOMB_LOGO : mImageURL;
}


- (NSString *)parseHtmlString:(NSString*)htmlString
{
    if ([htmlString rangeOfString:@"<"].location == NSNotFound) {
        return htmlString;
    }
    
    parsedString = [[NSAttributedString alloc] initWithData:
                                            [htmlString dataUsingEncoding:NSUTF8StringEncoding]
                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                      NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                             documentAttributes:nil error:nil];
    return parsedString.string;
}

@end
