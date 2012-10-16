//
//  ItemListViewController.m
//  korpokkur
//
//  Created by happy_ryo on 10/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ItemListViewController.h"
#import "TagItemsController.h"
#import "Tag.h"
#import "Item.h"
#import "ItemViewController.h"

@interface ItemListViewController ()

@end

@implementation ItemListViewController {
    TagItemsController *_tagItemsController;
    Tag *_itemTag;
    __weak ItemListViewController *_weakSelf;

}
@synthesize tagItemsController = _tagItemsController;

- (id)initWithTag:(Tag *)tag {
    self = [super init];
    if (self) {
        _itemTag = tag;

    }

    return self;
}

+ (id)objectWithTag:(Tag *)tag {
    return [[ItemListViewController alloc] initWithTag:tag];
}


+ (id)objectWithTagItemsController:(TagItemsController *)tagItemsController {
    return [[ItemListViewController alloc] initWithTagItemsController:tagItemsController];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _itemTag.tagName;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    _weakSelf = self;
    _tagItemsController = [[TagItemsController alloc] initWithTag:_itemTag
                                               tagItemsController:^(NSArray *array) {
                                                   if (array == nil)self.navigationItem.title = _itemTag.tagName;
                                                   NSInteger integer = _tagItemsController.items.count - array.count;
                                                   NSEnumerator *enumerator = array.objectEnumerator;
                                                   NSMutableArray *indexPaths = [NSMutableArray array];
                                                   Item *item = enumerator.nextObject;
                                                   while (item) {
                                                       NSIndexPath *indexPath = [NSIndexPath indexPathForRow:integer inSection:0];
                                                       [indexPaths addObject:indexPath];
                                                       ++integer;
                                                       item = enumerator.nextObject;
                                                   }
                                                   [self insert:indexPaths];
                                               }];
}

- (void)insert:(NSArray *)array {
    self.navigationItem.title = _itemTag.tagName;
    [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
}

- (void)insertRow:(NSIndexPath *)indexPath {
    NSArray *array = [NSArray arrayWithObjects:indexPath, nil];
    [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationBottom];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_tagItemsController.items.count == 0 && _itemTag.itemCount != [NSNumber numberWithChar:0]) {
        self.navigationItem.title = @"読み込み中";
        [_tagItemsController loadItems];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _tagItemsController.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    Item *item = [_tagItemsController.items objectAtIndex:(NSUInteger) indexPath.row];
//    NSString *iconURL =
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = item.itemTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ストック", item.stockCount];
    // Configure the cell...

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tagItemsController.items.count - 1 == indexPath.row) {
        if (_tagItemsController.items.count != [_itemTag.itemCount unsignedIntegerValue]) {
            self.navigationItem.title = @"読み込み中";
            [_tagItemsController moreLoadItems];
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ItemViewController *itemViewController = [[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil item:[_tagItemsController.items objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:itemViewController animated:YES];
}

- (void)dealloc {
    _itemTag = nil;
    _tagItemsController = nil;
    _weakSelf = nil;
}


@end
