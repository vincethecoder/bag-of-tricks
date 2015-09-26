//
//  GameBaseTableController.m
//  VideoGameSearch
//
//  Created by Vincent Sam on 11/9/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import "GameBaseTableController.h"
#import "VGSUtils.h"

@interface GameBaseTableController ()

@end

@implementation GameBaseTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[GameCell class] forCellReuseIdentifier:@"GameCell"];
}

- (void)configureGameCell:(GameCell *)cell forVideoGame:(SearchResult *)videoGame
{
    cell.title.text             = videoGame.name;
    cell.desc.text              = videoGame.desc;
    cell.postDate.text          = videoGame.postDate;
    cell.reviews.text           = videoGame.reviews;
    
    [VGSUtils cellImage:videoGame.imageURL withUIImageView:cell.iconView];
}

@end
