//
//  ViewController.h
//  AppClient
//
//  Created by Muneer on 7/30/14.
//  Copyright (c) 2014 Muneer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNMPullToRefreshManager.h"
@interface PostViewController : UIViewController<MNMPullToRefreshManagerClient>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UINib *postCellNib;
@end
