//
//  ItemViewController.h
//  korpokkur
//
//  Created by happy_ryo on 2012/10/13.
//  Copyright (c) 2012年 happy_ryo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

@interface ItemViewController : UIViewController <UIWebViewDelegate>
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil item:(Item *)item;


@end
