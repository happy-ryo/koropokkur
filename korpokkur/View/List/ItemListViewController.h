//
//  ItemListViewController.h
//  korpokkur
//
//  Created by happy_ryo on 10/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



@class TagItemsController;
@class Tag;
@class Tag;

@interface ItemListViewController : UITableViewController
@property(nonatomic, strong) TagItemsController *tagItemsController;

- (id)initWithTagItemsController:(TagItemsController *)tagItemsController;

- (id)initWithTag:(Tag *)tag;

+ (id)objectWithTag:(Tag *)tag;


+ (id)objectWithTagItemsController:(TagItemsController *)tagItemsController;


@end
