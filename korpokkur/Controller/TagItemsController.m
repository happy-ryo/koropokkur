//
// Created by happy_ryo on 2012/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TagItemsController.h"
#import "QiitaTagItems.h"
#import "Tag.h"


@implementation TagItemsController {
    QiitaTagItems *_tagItems;
    Tag *_tag;

    void (^tagItemsController)(NSArray *array);

}

- (id)init {
    self = [super init];
    if (self) {
    }

    return self;
}

- (id)initWithTag:(Tag *)tag tagItemsController:(void (^)(NSArray *))aTagItemsController {
    self = [self init];
    if (self) {
        tagItemsController = aTagItemsController;
        _tag = tag;
        _tagItems = [[QiitaTagItems alloc] initWithTag:_tag itemsResult:^(BOOL b, NSArray *array) {
            NSLog(@"result");
            [self didFinishLoad:b results:array];
        }];
    }

    return self;
}

- (void)loadItems {
    [_tagItems load:TTURLRequestCachePolicyDefault more:NO];
}

- (void)moreLoadTags {
    [_tagItems load:TTURLRequestCachePolicyDefault more:YES];
}

- (void)didFinishLoad:(BOOL)status results:(NSArray *)array {
    if (status) {
        tagItemsController(array);
    } else {
        // want Core Data から抜いてきた物を返す実装にしたいよね
    }
}

- (NSArray *)items {
    return _tagItems.items;
}


@end