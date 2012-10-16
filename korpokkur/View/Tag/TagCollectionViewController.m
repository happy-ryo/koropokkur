//
// Created by happy_ryo on 2012/10/11.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TagCollectionViewController.h"
#import "TagController.h"
#import "Tag.h"
#import "CustomTagCell.h"
#import "QiitaTagItems.h"
#import "ItemListViewController.h"


@implementation TagCollectionViewController {
    UICollectionView *_collectionView;
    TagController *_tagController;
    __weak TagCollectionViewController *_weakSelf;
    QiitaTagItems *_items;
    ItemListViewController *_itemListViewController;
}
@synthesize collectionView = _collectionView;


- (void)loadView {
    [super loadView];
    self.navigationItem.title = @"Koropo";
    [self setUp];
    _weakSelf = self;
    _tagController = [[TagController alloc] initWithTagController:^(NSArray *array) {
        self.navigationItem.title = @"Koropo";
        NSInteger integer = _tagController.tags.count - array.count;
        NSEnumerator *enumerator = array.objectEnumerator;
        NSMutableArray *indexPaths = [NSMutableArray array];
        Tag *tag = enumerator.nextObject;
        while (tag) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:integer inSection:0];
            [indexPaths addObject:indexPath];
            ++integer;
            tag = enumerator.nextObject;
        }
        [self insert:indexPaths];
    }];
    [_tagController loadTags];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)insert:(NSArray *)array {
    [_weakSelf.collectionView insertItemsAtIndexPaths:array];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [_collectionView reloadData];
}


- (void)setUp {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3);
    [flowLayout setItemSize:CGSizeMake(100, 125)];
    [flowLayout setMinimumLineSpacing:7.0f];
    [flowLayout setMinimumInteritemSpacing:3.0f];
    //[flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[CustomTagCell class] forCellWithReuseIdentifier:@"CustomTagCell"];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:_collectionView];
}


#pragma mark UICollection Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%i:%@", indexPath.row, NSStringFromSelector(_cmd));
    Tag *tag = [_tagController.tags objectAtIndex:(NSUInteger) indexPath.row];
    NSLog(@"%@", tag.tagName);
    _itemListViewController = [[ItemListViewController alloc] initWithTag:tag];

    [self.navigationController pushViewController:_itemListViewController animated:YES];
//    _items = [[QiitaTagItems alloc] initWithTag: itemsResult:^(BOOL b, NSArray *array) {
//        NSLog(@"test");

//    }];
//    [_items load:TTURLRequestCachePolicyNone more:NO];
}



#pragma mark dataSource delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[_tagController tags] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomTagCell" forIndexPath:indexPath];
    Tag *tag = [_tagController.tags objectAtIndex:(NSUInteger) indexPath.row];
    [cell loadObject:tag];

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    return nil;
//}

#pragma mark UIScroll delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(CGPoint *)targetContentOffset {
    if ((targetContentOffset->y + scrollView.frame.size.height)/(scrollView.contentSize.height) == 1) {
        self.navigationItem.title = _tagController.complete ? @"Koropo" : @"読み込み中";
        [_tagController moreLoadTags];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end