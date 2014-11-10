//
//  GameSearchResultsController.h
//  VideoGameSearch
//
//  Created by Vincent Sam on 11/9/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameListController.h"
#import "GameBaseTableController.h"

@interface GameSearchResultsController : GameBaseTableController

@property (nonatomic, strong) NSArray *filteredGameList;

@end
