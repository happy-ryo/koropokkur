//
//  Item.h
//  korpokkur
//
//  Created by happy_ryo on 10/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



@interface Item : NSManagedObject
@property(nonatomic, copy) NSString *itemsId;
@property(nonatomic, strong) NSArray *stockUsers;
@property(nonatomic, strong) NSArray *itemTags;
@property(nonatomic, copy) NSString *stockCount;
@property(nonatomic, copy) NSString *itemTitle;
@property(nonatomic, copy) NSString *updatedAtInWords;
@property(nonatomic, copy) NSString *itemBody;
@property(nonatomic, copy) NSString *itemUrl;
@property(nonatomic, copy) NSString *updatedAt;
@property(nonatomic, copy) NSString *gistUrl;
@property(nonatomic, copy) NSString *createdAt;
@property(nonatomic, copy) NSString *commentCount;
@property(nonatomic, copy) NSString *itemPrivates;
@property(nonatomic, strong) NSDictionary *itemUser;
@property(nonatomic, copy) NSString *createdAtInWords;
@property(nonatomic, copy) NSString *uuid;
@property(nonatomic, copy) NSString *createdAtAsSeconds;


@end
