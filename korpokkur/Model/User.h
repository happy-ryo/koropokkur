//
//  User.h
//  korpokkur
//
//  Created by happy_ryo on 2012/10/15.
//  Copyright (c) 2012年 happy_ryo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url_name;
@property (nonatomic, retain) NSString * profile_image_url;
@property (nonatomic, retain) NSSet *item;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addItemObject:(Item *)value;
- (void)removeItemObject:(Item *)value;
- (void)addItem:(NSSet *)values;
- (void)removeItem:(NSSet *)values;

@end
