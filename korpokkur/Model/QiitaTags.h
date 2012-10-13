//
// Created by happy_ryo on 2012/10/11.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


static NSString *const QIITA_TAGS_API = @"https://qiita.com/api/v1/tags?page=%i&per_page=%i&token=%@";

@interface QiitaTags : TTURLRequestModel <TTURLRequestDelegate>
@property(readonly, nonatomic, strong) NSMutableArray *tags;

- (id)initWithTagsResult:(void (^)(BOOL, NSArray *))aTagsResult;

+ (id)objectWithTagsResult:(void (^)(BOOL, NSArray *))aTagsResult;


@end