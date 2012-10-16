//
// Created by happy_ryo on 2012/10/11.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface TagController : NSObject
@property(nonatomic, copy) void (^tagController)(NSArray *);

- (id)initWithTagController:(void (^)(NSArray *))aTagController;

+ (id)objectWithTagController:(void (^)(NSArray *))aTagController;

- (void)loadTags;

- (void)moreLoadTags;


- (NSArray *)tags;

- (BOOL)complete;


@end