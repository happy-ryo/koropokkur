//
//  Item.h
//  korpokkur
//
//  Created by happy_ryo on 2012/10/15.
//  Copyright (c) 2012年 happy_ryo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StockUser, Tag, User;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * createdAtAsSeconds;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSString * createdAtInWords;
@property (nonatomic, retain) NSNumber * itemPrivates;
@property (nonatomic, retain) NSNumber * commentCount;
@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) NSString * gistUrl;
@property (nonatomic, retain) NSString * updatedAt;
@property (nonatomic, retain) NSString * itemUrl;
@property (nonatomic, retain) NSString * itemBody;
@property (nonatomic, retain) NSString * updatedAtInWords;
@property (nonatomic, retain) NSString * itemTitle;
@property (nonatomic, retain) NSNumber * stockCount;
@property (nonatomic, retain) NSNumber * itemsId;
@property (nonatomic, retain) NSSet *stockUsers;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) User *user;
@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addStockUsersObject:(StockUser *)value;
- (void)removeStockUsersObject:(StockUser *)value;
- (void)addStockUsers:(NSSet *)values;
- (void)removeStockUsers:(NSSet *)values;

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
