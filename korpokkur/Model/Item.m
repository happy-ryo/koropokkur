//
//  Item.m
//  korpokkur
//
//  Created by happy_ryo on 10/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Item.h"

@implementation Item {
    NSString *_itemsId;
    NSArray *_stockUsers;
    NSArray *_itemTags;
    NSString *_stockCount;
    NSString *_itemTitle;
    NSString *_updatedAtInWords;
    NSString *_itemBody;
    NSString *_itemUrl;
    NSString *_updatedAt;
    NSString *_gistUrl;
    NSString *_createdAt;
    NSString *_commentCount;
    NSString *_itemPrivate;
    NSDictionary *_itemUser;
    NSString *_createdAtInWords;
    NSString *_uuid;
    NSString *_createdAtAsSeconds;
}
@synthesize itemsId = _itemsId;
@synthesize stockUsers = _stockUsers;
@synthesize itemTags = _itemTags;
@synthesize stockCount = _stockCount;
@synthesize itemTitle = _itemTitle;
@synthesize updatedAtInWords = _updatedAtInWords;
@synthesize itemBody = _itemBody;
@synthesize itemUrl = _itemUrl;
@synthesize updatedAt = _updatedAt;
@synthesize gistUrl = _gistUrl;
@synthesize createdAt = _createdAt;
@synthesize commentCount = _commentCount;
@synthesize itemPrivates = _itemPrivate;
@synthesize itemUser = _itemUser;
@synthesize createdAtInWords = _createdAtInWords;
@synthesize uuid = _uuid;
@synthesize createdAtAsSeconds = _createdAtAsSeconds;


@end
