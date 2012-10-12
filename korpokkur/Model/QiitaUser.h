//
// Created by happy_ryo on 2012/10/11.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


static NSString *const QIITA_USER_NAME = @"qiita_user_name";

static NSString *const QIITA_TOKEN = @"qiita_token";

@interface QiitaUser : NSObject
+ (NSString *)userName;

+ (NSString *)token;


@end