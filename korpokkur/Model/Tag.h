//
// Created by happy_ryo on 2012/10/11.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface Tag : NSManagedObject

@property(strong, nonatomic) NSString *tagName;
@property(strong, nonatomic) NSString *iconUrl;
@property(strong, nonatomic) NSString *itemCount;
@property(strong, nonatomic) NSString *urlName;
@property(strong, nonatomic) NSString *followerCount;

@end