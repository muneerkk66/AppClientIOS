//
//  PostCell.m
//  AppClient
//
//  Created by Muneer on 7/30/14.
//  Copyright (c) 2014 Muneer. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib
{
    // Initialization code
    CALayer * imageLayer = [self.profileimageView layer];
    [imageLayer setMasksToBounds:YES];
    [imageLayer setCornerRadius:42.5];
    
    // You can even add a border
    [imageLayer setBorderWidth:5.0];
    [imageLayer setBorderColor:[[UIColor colorWithRed:108.0/255.0 green:196.0/255.0 blue:22.0/255.0 alpha:1.0]CGColor]];
    
    self.webView.scrollView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
