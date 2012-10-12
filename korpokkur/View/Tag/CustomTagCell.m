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

    CALayer *caLayer = self.contentView.layer;
    caLayer.borderColor = RGBCOLOR(220, 220, 220).CGColor;
    caLayer.borderWidth = 1.0f;
    caLayer.cornerRadius = 0.5f;

    TTImageView *iconImg = [[TTImageView alloc] initWithFrame:CGRectMake(5, 5, 15, 15)];
    iconImg.urlPath = tag.iconUrl;
    iconImg.delegate = self;
    [self.contentView addSubview:iconImg];

    UILabel *tagName = [[UILabel alloc] initWithFrame:CGRectMake(23, 5, 65, 15)];
    tagName.numberOfLines = 1;
    tagName.font = [UIFont boldSystemFontOfSize:13.0f];
    tagName.textColor = RGBCOLOR(121, 121, 121);
    tagName.minimumFontSize = 11.0f;
    tagName.text = tag.tagName;
    tagName.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:tagName];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(3, tagName.frame.origin.y + tagName.frame.size.height + 5, 94, 1)];
    line.backgroundColor = RGBCOLOR(121, 121, 121);
    [self.contentView addSubview:line];

    TTStyledTextLabel *itemCountLbl = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(5, line.frame.origin.y + line.frame.size.height + 5, 90, 30)];
    itemCountLbl.html = [NSString stringWithFormat:@"<b>%@</b> アイテム", tag.itemCount];
    itemCountLbl.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:itemCountLbl];

    TTStyledTextLabel *followerLbl = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(5, itemCountLbl.frame.origin.y + itemCountLbl.frame.size.height + 5, 90, 30)];
    followerLbl.html = [NSString stringWithFormat:@"<b>%@</b> フォロー", tag.followerCount];
    followerLbl.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:followerLbl];

    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)imageView:(TTImageView *)imageView didFailLoadWithError:(NSError *)error {
    [imageView reload];
}

@end
