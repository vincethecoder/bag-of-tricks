//
//  GameSearchResultsController.m
//  VideoGameSearch
//
//  Created by Vincent Sam on 11/9/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import "GameSearchResultsController.h"
#import "SearchResult.h"
#import "GameCell.h"
#import "VGSUtils.h"

@implementation GameSearchResultsController

@synthesize filteredGameList;

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return filteredGameList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GameCell *cell = [tableView dequeueReusableCellWithIdentifier:GameCellIdentifier forIndexPath:indexPath];
    assert(cell != nil);    // we should always have a cell
    [self configureGameCell:cell forVideoGame:filteredGameList[indexPath.row]];
    return cell;
}



@end
