//
//  MasterViewController.h
//  VideoGameSearch
//
//  Created by Vincent Sam on 11/8/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameListDetailViewController;

@interface GameListController : UITableViewController

@property (strong, nonatomic) GameListDetailViewController *gameDetailViewController;
@property (strong, nonatomic) IBOutlet UITableView *gameTableView;

@end

