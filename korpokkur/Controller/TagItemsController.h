//
// Created by happy_ryo on 2012/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class Tag;


@interface TagItemsController : NSObject
- (id)initWithTag:(Tag *)tag tagItemsController:(void (^)(NSArray *))aTagItemsController;

- (void)loadItems;

- (void)moreLoadTags;

- (NSArray *)items;


@end