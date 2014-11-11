//
//  GameBaseTableController.h
//  VideoGameSearch
//
//  Created by Vincent Sam on 11/9/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCell.h"
#import "SearchResult.h"

@interface GameBaseTableController : UITableViewController

- (void)configureGameCell:(GameCell *)cell forVideoGame:(SearchResult *)videoGame;

@end
