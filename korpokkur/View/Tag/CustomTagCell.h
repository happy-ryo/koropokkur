//
//  CustomTagCell.h
//  korpokkur
//
//  Created by happy_ryo on 10/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class Tag;

@interface CustomTagCell : UICollectionViewCell <TTImageViewDelegate>
- (void)loadObject:(Tag *)tag;


@end
