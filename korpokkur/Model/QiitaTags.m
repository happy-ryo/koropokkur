//
// Created by happy_ryo on 2012/10/11.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "QiitaTags.h"
#import "QiitaUser.h"
#import "Tag.h"
#import "AppDelegate.h"


@implementation QiitaTags {
    NSMutableArray *_tags;
    NSInteger _page;
    NSInteger _perPage;

    BOOL _complete;

    void (^tagsResult)(BOOL status, NSArray *resultArray);

}
@synthesize tags = _tags;

- (id)initWithTagsResult:(void (^)(BOOL, NSArray *))aTagsResult {
    self = [super init];
    if (self) {
        tagsResult = aTagsResult;
        _page = 1;
        _perPage = 20;
        _tags = [NSMutableArray array];
    }

    return self;
}

+ (id)objectWithTagsResult:(void (^)(BOOL, NSArray *))aTagsResult {
    return [[QiitaTags alloc] initWithTagsResult:aTagsResult];
}


- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    if (more) {
        ++_page;
    } else {
        _page = 1;
        _complete = NO;
        _tags = [NSMutableArray array];
    }

    if (_complete) return;

    NSString *_qiitaTagsAPI = [NSString stringWithFormat:QIITA_TAGS_API, _page, _perPage, [QiitaUser token]];
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
    id obj =response.rootObject;
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
            Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Tag class])
                                                     inManagedObjectContext:appDelegate.managedObjectContext];
            tag.tagName = [responseDic valueForKey:@"name"];
            tag.iconUrl = [responseDic valueForKey:@"icon_url"];
            NSNumber *itemCount = [responseDic valueForKey:@"item_count"];
            tag.itemCount = itemCount.description;
            tag.urlName = [responseDic valueForKey:@"url_name"];
            NSNumber *followerCount = [responseDic valueForKey:@"follower_count"];
            tag.followerCount = followerCount.description;
            NSError *error;
            if (![appDelegate.managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            [resultArray addObject:tag];
            responseDic = [resultEnumerator nextObject];
        }
    }

    [_tags addObjectsFromArray:resultArray];
    tagsResult(YES, resultArray);
}

- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error {
    [super request:request didFailLoadWithError:error];
}

- (void)requestDidCancelLoad:(TTURLRequest *)request {
    [super requestDidCancelLoad:request];
}


@end