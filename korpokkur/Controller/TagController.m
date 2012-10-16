//
// Created by happy_ryo on 2012/10/11.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TagController.h"
#import "QiitaTags.h"


@implementation TagController {
    QiitaTags *_tags;

    void (^tagController)(NSArray *array);

}
@synthesize tagController;


- (id)init {
    self = [super init];
    if (self) {
        _tags = [[QiitaTags alloc] initWithTagsResult:^(BOOL b, NSArray *array) {
            [self didFinishLoad:b results:array];
        }];
    }

    return self;
}

- (id)initWithTagController:(void (^)(NSArray *))aTagController {
    self = [self init];
    if (self) {
        tagController = aTagController;
    }

    return self;
}

+ (id)objectWithTagController:(void (^)(NSArray *))aTagController {
    return [[TagController alloc] initWithTagController:aTagController];
}


- (void)loadTags {
    [_tags load:TTURLRequestCachePolicyDisk more:NO];
}

- (void)moreLoadTags {
    [_tags load:TTURLRequestCachePolicyDisk more:YES];
}

- (void)didFinishLoad:(BOOL)status results:(NSArray *)array {
    if (status) {
        tagController(array);
    } else {
        // want Core Data から抜いてきた物を返す実装にしたいよね
    }
}

- (NSArray *)tags {
    return _tags.tags;
}

- (BOOL)complete {
    return _tags.complete;
}

- (void)dealloc {
    _tags = nil;
}

@end