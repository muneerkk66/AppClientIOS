//
//  UserInfo.h
//  ChatRoom
//
//  Created by CEINO on 6/26/13.
//  Copyright (c) 2013 CEINO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostObjects : NSObject<NSCoding>
@property(nonatomic,strong) NSString *postersName;
@property(nonatomic,strong) NSString *description;
@property(nonatomic,strong) NSString *imageurl;
@property(nonatomic,strong) NSDate *createdAt;

@end
