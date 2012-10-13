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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Koropo";
    [self setUp];
    _weakSelf = self;
    _tagController = [[TagController alloc] initWithTagController:^(NSArray *array) {
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

}

- (void)insert:(NSArray *)array{
    [_weakSelf.collectionView insertItemsAtIndexPaths:array];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_tagController loadTags];
}


- (void)setUp {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    [flowLayout setItemSize:CGSizeMake(100, 125)];
    [flowLayout setMinimumLineSpacing:5.0f];
    [flowLayout setMinimumInteritemSpacing:5.0f];
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
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    NSLog(@"%i:%@", indexPath.row, NSStringFromSelector(_cmd));
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%i:%@", indexPath.row, NSStringFromSelector(_cmd));
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%i:%@", indexPath.row, NSStringFromSelector(_cmd));
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%i:%@", indexPath.row, NSStringFromSelector(_cmd));
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%i:%@", indexPath.row, NSStringFromSelector(_cmd));
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%i:%@", indexPath.row, NSStringFromSelector(_cmd));
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%i:%@", indexPath.row, NSStringFromSelector(_cmd));
    Tag *tag = [_tagController.tags objectAtIndex:(NSUInteger) indexPath.row];
    NSLog(@"%@",tag.tagName);
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
    if (targetContentOffset->y - scrollView.frame.size.height / scrollView.contentSize.height > 0.7) {
        [_tagController moreLoadTags];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end