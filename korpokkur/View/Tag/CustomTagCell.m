//
//  CustomTagCell.m
//  korpokkur
//
//  Created by happy_ryo on 10/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTagCell.h"
#import "Tag.h"

@implementation CustomTagCell



- (void)loadObject :(Tag *)tag {
    NSEnumerator *enumerator = self.contentView.subviews.objectEnumerator;
    UIView *uiView = enumerator.nextObject;
    while (uiView) {
        [uiView removeFromSuperview];
        uiView = enumerator.nextObject;
    }

    TTImageView *iconImg = [[TTImageView alloc] initWithFrame:CGRectMake(5, 5, 15, 15)];
    iconImg.urlPath = tag.iconUrl;
    iconImg.delegate = self;
    [self.contentView addSubview:iconImg];

    UILabel *tagName = [[UILabel alloc] initWithFrame:CGRectMake(23, 5, 65, 15)];
    tagName.font = [UIFont boldSystemFontOfSize:11.0f];
    tagName.text = tag.tagName;
    tagName.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:tagName];


    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)imageView:(TTImageView *)imageView didFailLoadWithError:(NSError *)error {
    [imageView reload];
}

@end
