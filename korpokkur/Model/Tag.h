//
//  Tag.h
//  korpokkur
//
//  Created by happy_ryo on 2012/10/15.
//  Copyright (c) 2012年 happy_ryo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSNumber * followerCount;
@property (nonatomic, retain) NSString * iconUrl;
@property (nonatomic, retain) NSNumber * itemCount;
@property (nonatomic, retain) NSString * tagName;
@property (nonatomic, retain) NSString * urlName;
@property (nonatomic, retain) NSSet *item;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addItemObject:(Item *)value;
- (void)removeItemObject:(Item *)value;
- (void)addItem:(NSSet *)values;
- (void)removeItem:(NSSet *)values;

@end
