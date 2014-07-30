//
//  UserInfo.m
//  ChatRoom
//
//  Created by CEINO on 6/26/13.
//  Copyright (c) 2013 CEINO. All rights reserved.
//

#import "PostObjects.h"

@implementation PostObjects

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.postersName = [decoder decodeObjectForKey:@"name"];
    self.description = [decoder decodeObjectForKey:@"description"];
    self.imageurl = [decoder decodeObjectForKey:@"url"];
    
    
  
    
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.postersName forKey:@"name"];
    [encoder encodeObject:self.description forKey:@"description"];
    [encoder encodeObject:self.imageurl forKey:@"url"];


    
    
}

@end
