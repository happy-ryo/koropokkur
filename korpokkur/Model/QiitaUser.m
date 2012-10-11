//
// Created by happy_ryo on 2012/10/11.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "QiitaUser.h"


@implementation QiitaUser {

}

+ (NSString *)userName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:QIITA_USER_NAME];
}

+ (NSString *)token {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:QIITA_TOKEN];
}

@end