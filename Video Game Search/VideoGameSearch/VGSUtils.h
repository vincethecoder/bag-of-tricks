//
//  VGSUtils.h
//  Video Game Search
//
//  Created by Vincent Sam on 11/8/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VGSUtils : NSObject

extern NSString * GameCellIdentifier;
extern NSString * GameDetailIdentifier;
extern NSString * GameSearchDefaultParam;
extern NSString * GameHttpQueryParam;
extern NSString * UserDefaultSearchParams;
extern NSString * GameSettingsMenuDismissed;

+ (NSString *)convertDictParamsToString:(NSDictionary *)dictData;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+ (void)cellImage:(NSString *)imageUrlString withUIImageView:(UIImageView *)imageView;
+ (void)styleNavigationBar:(UINavigationBar*)bar withFontName:(NSString*)navigationTitleFont andColor:(UIColor*)color;

@end
