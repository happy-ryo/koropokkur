//
// Created by happy_ryo on 2012/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class Tag;

static NSString *const QIITA_TAG_ITEMS = @"https://qiita.com/api/v1/tags/%@/items?page=%i&per_page=%i&token=%@";

@interface QiitaTagItems : TTURLRequestModel <TTURLRequestDelegate>
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic) BOOL completeFlg;


- (id)initWithTag:(Tag *)tag itemsResult:(void (^)(BOOL, NSArray *))anItemsResult;

+ (id)objectWithTag:(Tag *)tag itemsResult:(void (^)(BOOL, NSArray *))anItemsResult;


@end