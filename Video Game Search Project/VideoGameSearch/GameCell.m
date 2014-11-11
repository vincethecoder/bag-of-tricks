//
//  GameCell.m
//  Video Game Search
//
//  Created by Vincent Sam on 11/8/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import "GameCell.h"

@implementation GameCell

@synthesize title;
@synthesize desc;
@synthesize reviews;
@synthesize postDate;
@synthesize iconView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib {

    UIColor* mainColor = [UIColor colorWithRed:222.0/255 green:59.0/255 blue:47.0/255 alpha:1.0f];
    UIColor* neutralColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    
    UIColor* mainColorLight = [UIColor colorWithRed:50.0/255 green:102.0/255 blue:147.0/255 alpha:0.7f];
    UIColor* lightColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    
    NSString* boldFontName = @"Optima-ExtraBlack";
    NSString* fontName = @"GillSans";
    
    self.title.textColor =  mainColor;
    self.title.font =  [UIFont fontWithName:boldFontName size:20.0f];
    
    self.desc.textColor =  neutralColor;
    self.desc.font =  [UIFont fontWithName:fontName size:16.0f];
    
    self.postDate.textColor = lightColor;
    self.postDate.font =  [UIFont fontWithName:fontName size:12.0f];
    
    self.reviews.textColor = mainColorLight;
    self.reviews.font =  [UIFont fontWithName:fontName size:14.0f];
    
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.clipsToBounds = YES;
    self.iconView.layer.cornerRadius = 2.0f;
    
    self.iconView.backgroundColor = [UIColor whiteColor];
    self.iconView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:0.6f].CGColor;
    self.iconView.layer.borderWidth = 1.0f;
    self.iconView.layer.cornerRadius = 2.0f;
    
    self.iconView.layer.cornerRadius = 10.0f;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
