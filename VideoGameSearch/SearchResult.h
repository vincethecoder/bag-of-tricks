//
//  SearchResult.h
//  Video Game Search
//
//  Created by Vincent Sam on 11/8/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SearchResult : NSObject

#define SR_ID                   @"id"
#define SR_NAME                 @"name"
#define SR_IMAGE                @"image"
#define SR_DESCRIPTION          @"description"
#define SR_API_DETAIL_URL       @"api_detail_url"
#define SR_SITE_DETAIL_URL      @"site_detail_url"

#define SR_DECK                 @"deck"
#define SR_ALIASES              @"aliases"
#define SR_DATE_ADDED           @"date_added"
#define SR_LAST_UPDATED         @"date_last_updated"

#define SR_PLATFORMS            @"platforms"
#define SR_GAME_RATING          @"original_game_rating"
#define SR_RELEASE_DATE         @"original_release_date"
#define SR_USER_REVIEWS         @"number_of_user_reviews"

#define SR_IMAGE_TYPES          @[@"icon_url", @"medium_url", @"screen_url",\
                                @"small_url", @"super_url", @"thumb_url", @"tiny_url"]

#define GIANT_BOMB_LOGO         @"http://static.giantbomb.com/uploads/original/11/118911/2217295-gb_logo.png" 

/// Enumerations for image types
typedef NS_ENUM(NSInteger, ImageTypes) {
    imageIcon = 0,
    imageMedium,
    imageScreen,
    imageSmall,
    imageSuper,
    imageThumb,
    imageTiny
};

@property (nonatomic, readwrite, strong) NSString *name;
@property (nonatomic, readwrite, strong) NSString *desc;
@property (nonatomic, readwrite, strong) NSString *gameId;
@property (nonatomic, readwrite, strong) NSString *reviews;
@property (nonatomic, readwrite, strong) NSString *postDate;
@property (nonatomic, readwrite, strong) NSString *imageURL;
@property (nonatomic, readwrite, strong) NSString *detailURL;

+(instancetype)initWithDicitonary:(NSDictionary *)data;

@end
