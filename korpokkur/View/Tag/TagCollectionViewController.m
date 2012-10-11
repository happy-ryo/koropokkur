//
// Created by happy_ryo on 2012/10/11.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TagCollectionViewController.h"
#import "TagController.h"
#import "Tag.h"
#import "CustomTagCell.h"


@implementation TagCollectionViewController {
    UICollectionView *_collectionView;
    TagController *_tagController;
}

- (void)loadView {
    [super loadView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUp];
    _tagController = [[TagController alloc] initWithTagController:^(NSArray *array) {
        __block NSInteger integer = _tagController.tags.count - array.count;
        __block NSEnumerator *enumerator = array.objectEnumerator;
        __block NSMutableArray *indexPaths = [NSMutableArray array];
        __block Tag *tag = enumerator.nextObject;
        while (tag) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:integer inSection:0];
            [indexPaths addObject:indexPath];
            integer++;
            tag = enumerator.nextObject;
        }
        [_collectionView insertItemsAtIndexPaths:indexPaths];
    }];
    [_tagController loadTags];
}


- (void)setUp {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(150, 125)];
    [flowLayout setMinimumLineSpacing:5.0f];
    [flowLayout setMinimumInteritemSpacing:5.0f];
    //[flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
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
    return NO;
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
}


#pragma mark dataSource delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[_tagController tags] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomTagCell" forIndexPath:indexPath];
//    CustomTagCell *cell =
//            (CustomTagCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CustomTagCell" forIndexPath:indexPath];
//            [collectionView dequeueReusableSupplementaryViewOfKind:@"CustomTagCell" withReuseIdentifier:@"CustomTagCell" forIndexPath:indexPath];

    Tag *tag = [_tagController.tags objectAtIndex:indexPath.row];
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