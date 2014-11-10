//
//  GameCell.h
//  Video Game Search
//
//  Created by Vincent Sam on 11/8/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *reviews;
@property (weak, nonatomic) IBOutlet UILabel *postDate;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end
