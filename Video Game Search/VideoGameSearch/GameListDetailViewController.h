//
//  DetailViewController.h
//  VideoGameSearch
//
//  Created by Vincent Sam on 11/8/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResult.h"

@interface GameListDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) SearchResult *selectedGame;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

