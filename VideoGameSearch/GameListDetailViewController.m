//
//  DetailViewController.m
//  VideoGameSearch
//
//  Created by Vincent Sam on 11/8/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import "GameListDetailViewController.h"

@implementation GameListDetailViewController

@synthesize selectedGame;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    self.detailDescriptionLabel.text = @"";
    NSString *strURL = @"http://www.giantbomb.com/404";
    if (selectedGame) {
        strURL = selectedGame.detailURL;
        self.navigationItem.title = selectedGame.name;
    }
    //load url into webview
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
