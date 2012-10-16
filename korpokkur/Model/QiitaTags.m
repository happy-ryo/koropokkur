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

    BOOL _loadFlg;

    void (^tagsResult)(BOOL status, NSArray *resultArray);

}
@synthesize tags = _tags;
@synthesize complete = _complete;


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
    if(_loadFlg)return;
    _loadFlg = YES;
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
    request.cacheExpirationAge = 60 * 50;

    TTURLJSONResponse *response = [[TTURLJSONResponse alloc] init];
    request.response = response;

    [request send];

}

#pragma mark TTURLRequestDelegate



- (void)requestDidFinishLoad:(TTURLRequest *)request {
    [super requestDidFinishLoad:request];
    [NSThread detachNewThreadSelector:@selector(request:) toTarget:self withObject:request];

}

- (void)request:(TTURLRequest *)request {
    TTURLJSONResponse *response = (TTURLJSONResponse *) request.response;
    @autoreleasepool {
        id obj = response.rootObject;
        if (obj == nil || [obj count] == 0) {
            _complete = YES;
            tagsResult(YES, nil);
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
                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Tag class])
                                                          inManagedObjectContext:appDelegate.managedObjectContext];
                [request setEntity:entity];
                NSString *predicateCommand = [NSString stringWithFormat:@"urlName = '"];
                predicateCommand = [predicateCommand stringByAppendingString:[responseDic valueForKey:@"url_name"]];
                predicateCommand = [predicateCommand stringByAppendingString:@"'"];

                NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateCommand];
                [request setPredicate:predicate];

                NSArray *fetchedObjects = [[appDelegate managedObjectContext] executeFetchRequest:request error:nil];
                if (fetchedObjects.count) tag = [fetchedObjects objectAtIndex:0];

                tag.tagName = [responseDic valueForKey:@"name"];
                tag.iconUrl = [responseDic valueForKey:@"icon_url"];
                tag.itemCount = [responseDic valueForKey:@"item_count"];
                tag.urlName = [responseDic valueForKey:@"url_name"];
                tag.followerCount = [responseDic valueForKey:@"follower_count"];
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
        _loadFlg = NO;
    }

}

- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error {
    [super request:request didFailLoadWithError:error];
}

- (void)requestDidCancelLoad:(TTURLRequest *)request {
    [super requestDidCancelLoad:request];
}

- (void)dealloc {

}

@end