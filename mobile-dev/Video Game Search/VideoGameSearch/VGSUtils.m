//
//  VGSUtils.m
//  Video Game Search
//
//  Created by Vincent Sam on 11/8/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import "VGSUtils.h"

#pragma mark - Globals
NSString * GameCellIdentifier       = @"GameCell";
NSString * GameDetailIdentifier     = @"showDetail";
NSString * GameSearchDefaultParam   = @""; //Examples Video Games, Nintendo, xBox ONE, PS4
NSString * GameHttpQueryParam       = @"query";
NSString * UserDefaultSearchParams  = @"userSearchTerms";
NSString * GameSettingsMenuDismissed= @"SettingsMenuDismissed";

@implementation VGSUtils

+ (NSString *)convertDictParamsToString:(NSDictionary *)dictParams
{
    NSMutableString *stringParams = [[NSMutableString alloc] init];
    
    // The block approach avoids running the lookup algorithm for every key:
    [dictParams enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop) {
        [stringParams appendFormat:@"%@=%@&", key, value];
    }];
    
    // Remove last character
    return [stringParams substringToIndex:stringParams.length - 1];
}

+(void)styleNavigationBar:(UINavigationBar*)bar withFontName:(NSString*)navigationTitleFont andColor:(UIColor*)color{
    
    bar.barTintColor = color;
    bar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                NSFontAttributeName : [UIFont fontWithName:navigationTitleFont size:18.0f]};
    
}

+ (void)cellImage:(NSString *)imageUrlString withUIImageView:(UIImageView *)imageView
{
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(q, ^{
        __block UIImage *image = nil;
        
        dispatch_sync(q, ^{
            NSURL *url = [NSURL URLWithString:imageUrlString];
            
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            NSError *downloadError = nil;
            
            NSData *imageData = [NSURLConnection
                                 sendSynchronousRequest:urlRequest
                                 returningResponse:nil
                                 error:&downloadError];
            
            if (downloadError == nil && imageData != nil)
            {
                image = [UIImage imageWithData:imageData];
            }
            
        });
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            image = [self imageWithImage:image scaledToSize:CGSizeMake(20, 15)];
            [imageView setImage:image];
        });
    });
    
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
