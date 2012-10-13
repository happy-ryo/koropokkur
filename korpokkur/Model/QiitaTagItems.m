//
// Created by happy_ryo on 2012/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "QiitaTagItems.h"
#import "QiitaUser.h"
#import "Tag.h"
#import "AppDelegate.h"
#import "Item.h"


@implementation QiitaTagItems {
    NSMutableArray *_items;
    NSInteger _page;
    NSInteger _perPage;

    BOOL _complete;

    Tag *_tag;

    void (^itemsResult)(BOOL status, NSArray *resultArray);

}
@synthesize items = _items;

- (id)initWithTag:(Tag *)tag itemsResult:(void (^)(BOOL, NSArray *))anItemsResult {
    self = [super init];
    if (self) {
        _tag = tag;
        _perPage = 40;
        _page = 1;
        itemsResult = anItemsResult;
    }

    return self;
}

+ (id)objectWithTag:(Tag *)tag itemsResult:(void (^)(BOOL, NSArray *))anItemsResult {
    return [[QiitaTagItems alloc] initWithTag:tag itemsResult:anItemsResult];
}


- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {

    [super load:cachePolicy more:more];
    if (more) {
        ++_page;
    } else {
        _page = 1;
        _complete = NO;
        _items = [NSMutableArray array];
    }

    if (_complete) return;

    NSString *_qiitaTagsAPI = [NSString stringWithFormat:QIITA_TAG_ITEMS, _tag.tagName, _page, _perPage, [QiitaUser token]];
    TTURLRequest *request = [TTURLRequest requestWithURL:_qiitaTagsAPI delegate:self];
    request.httpMethod = @"GET";
    request.cachePolicy = cachePolicy;
    request.cacheExpirationAge = 60 * 5;

    TTURLJSONResponse *response = [[TTURLJSONResponse alloc] init];
    request.response = response;

    [request send];
}

#pragma mark TTURLRequestDelegate

- (void)requestDidFinishLoad:(TTURLRequest *)request {
    [super requestDidFinishLoad:request];
    TTURLJSONResponse *response = (TTURLJSONResponse *) request.response;
    id obj = response.rootObject;
    if (obj == nil || [obj count] == 0) {
        _complete = YES;
        return;
    } else if (_complete) {
        return;
    }
    NSMutableArray *resultArray = [NSMutableArray array];

    if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *responseArray = obj;
        NSDictionary *responseDic;
        NSEnumerator *resultEnumerator = responseArray.objectEnumerator;
        AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;

        responseDic = [resultEnumerator nextObject];
        while (responseDic) {
//            Item *item = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Item class])
//                                                     inManagedObjectContext:appDelegate.managedObjectContext];
//            item.tagName = [responseDic valueForKey:@"name"];
//            item.iconUrl = [responseDic valueForKey:@"icon_url"];
//            NSNumber *itemCount = [responseDic valueForKey:@"item_count"];
//            item.itemCount = itemCount.description;
//            item.urlName = [responseDic valueForKey:@"url_name"];
//            NSNumber *followerCount = [responseDic valueForKey:@"follower_count"];
//            item.followerCount = followerCount.description;
//            NSError *error;
//            if (![appDelegate.managedObjectContext save:&error]) {
//                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                abort();
//            }
//            [resultArray addObject:item];
            Item *item = [[Item alloc] init];
            item.itemsId = [responseDic valueForKey:@"id"];
            item.stockUsers = [responseDic valueForKey:@"stock_users"];
            item.itemTags = [responseDic valueForKey:@"tags"];
            item.stockCount = [responseDic valueForKey:@"stock_count"];
            item.itemTitle = [responseDic valueForKey:@"title"];
            item.updatedAtInWords = [responseDic valueForKey:@"updated_at_in_words"];
            item.itemBody = [responseDic valueForKey:@"body"];
            item.itemUrl = [responseDic valueForKey:@"url"];
            item.updatedAt = [responseDic valueForKey:@"updated_at"];
            item.gistUrl = [responseDic valueForKey:@"gist_url"];
            item.createdAt = [responseDic valueForKey:@"created_at"];
            item.commentCount = [responseDic valueForKey:@"comment_count"];
            item.itemPrivates = [responseDic valueForKey:@"private"];
            item.itemUser = [responseDic valueForKey:@"user"];
            item.createdAtInWords = [responseDic valueForKey:@"created_at_in_words"];
            item.uuid = [responseDic valueForKey:@"uuid"];
            item.createdAtAsSeconds = [responseDic valueForKey:@"created_at_as_seconds"];
            [resultArray addObject:item];
            responseDic = [resultEnumerator nextObject];
        }
    }

    [_items addObjectsFromArray:resultArray];
    itemsResult(YES, resultArray);
}

- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error {
    [super request:request didFailLoadWithError:error];
}

- (void)requestDidCancelLoad:(TTURLRequest *)request {
    [super requestDidCancelLoad:request];
}

@end