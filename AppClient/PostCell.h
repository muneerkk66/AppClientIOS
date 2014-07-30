//
//  PostCell.h
//  AppClient
//
//  Created by Muneer on 7/30/14.
//  Copyright (c) 2014 Muneer. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileimageView;
@property (weak, nonatomic) IBOutlet UILabel *postersNameLabel;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
