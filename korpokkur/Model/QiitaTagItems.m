//
// Created by happy_ryo on 2012/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "QiitaTagItems.h"
#import "QiitaUser.h"
#import "Tag.h"
#import "AppDelegate.h"
#import "Item.h"
#import "StockUser.h"
#import "User.h"


@implementation QiitaTagItems {
    NSMutableArray *_items;
    NSInteger _page;
    NSInteger _perPage;

    BOOL _completeFlg;

    Tag *_tag;

    void (^itemsResult)(BOOL status, NSArray *resultArray);

    NSManagedObjectContext *_managedObjectContext;
    NSManagedObjectModel *_managedObjectModel;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}
@synthesize items = _items;
@synthesize completeFlg = _completeFlg;


- (id)initWithTag:(Tag *)tag itemsResult:(void (^)(BOOL, NSArray *))anItemsResult {
    self = [super init];
    if (self) {
        _tag = tag;
        _perPage = 40;
        _page = 1;
        itemsResult = anItemsResult;
    }

    return self;
}

+ (id)objectWithTag:(Tag *)tag itemsResult:(void (^)(BOOL, NSArray *))anItemsResult {
    return [[QiitaTagItems alloc] initWithTag:tag itemsResult:anItemsResult];
}


- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {

    [super load:cachePolicy more:more];
    if (more) {
        ++_page;
    } else {
        _page = 1;
        self.completeFlg = NO;
        _items = [NSMutableArray array];
    }

    if (self.completeFlg) return;

    NSString *_qiitaTagsAPI = [NSString stringWithFormat:QIITA_TAG_ITEMS, _tag.tagName, _page, _perPage, [QiitaUser token]];
    TTURLRequest *request = [TTURLRequest requestWithURL:_qiitaTagsAPI delegate:self];
    request.httpMethod = @"GET";
    request.cachePolicy = cachePolicy;
    request.cacheExpirationAge = 60 * 50;

    TTURLJSONResponse *response = [[TTURLJSONResponse alloc] init];
    request.response = response;

    [request send];
}

#pragma mark TTURLRequestDelegate

- (void)requestDidFinishLoad:(TTURLRequest *)request {
    [super requestDidFinishLoad:request];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [NSThread detachNewThreadSelector:@selector(request:) toTarget:self withObject:request];
//    [self request:request];
}

- (void)request:(TTURLRequest *)request {
    TTURLJSONResponse *response = (TTURLJSONResponse *) request.response;
    @autoreleasepool {
        id obj = response.rootObject;
        if (obj == nil || [obj count] == 0) {
            self.completeFlg = YES;
            itemsResult(YES, nil);
            return;
        } else if (self.completeFlg) {
            return;
        }
        NSMutableArray *resultArray = [NSMutableArray array];

        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *responseArray = obj;
            NSDictionary *responseDic;
            NSEnumerator *resultEnumerator = responseArray.objectEnumerator;
            AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;

            responseDic = [resultEnumerator nextObject];
            while (responseDic) {
                Item *item = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Item class])
                                                           inManagedObjectContext:self.managedObjectContext];
                item.itemsId = [responseDic valueForKey:@"id"];

                NSMutableSet *stockUsers = [NSMutableSet set];
                NSArray *stockUsersArray = [responseDic valueForKey:@"stock_users"];
                NSEnumerator *stockUserEnumerator = [stockUsersArray objectEnumerator];
                NSString *stockUserString = stockUserEnumerator.nextObject;
                while (stockUserString) {
                    NSFetchRequest *request = [[NSFetchRequest alloc] init];
                    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([StockUser class])
                                                              inManagedObjectContext:self.managedObjectContext];
                    [request setEntity:entity];
                    NSString *predicateCommand = [NSString stringWithFormat:@"name = '"];
                    predicateCommand = [predicateCommand stringByAppendingString:stockUserString];
                    predicateCommand = [predicateCommand stringByAppendingString:@"'"];

                    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateCommand];
                    [request setPredicate:predicate];

                    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:request error:nil];
                    if (fetchedObjects.count) {
                        [stockUsers addObject:[fetchedObjects objectAtIndex:0]];
                    } else {
                        StockUser *stockUser = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([StockUser class])
                                                                             inManagedObjectContext:self.managedObjectContext];
                        stockUser.name = stockUserString;
                        [stockUsers addObject:stockUser];
                    }
                    stockUserString = stockUserEnumerator.nextObject;
                }
                item.stockUsers = stockUsers;


                NSMutableSet *tags = [NSMutableSet set];
                NSArray *tagsArray = [responseDic valueForKey:@"tags"];
                NSEnumerator *tagsEnumerator = [tagsArray objectEnumerator];
                NSDictionary *tagsDic = [tagsEnumerator nextObject];
                while (tagsDic) {
                    NSFetchRequest *request = [[NSFetchRequest alloc] init];
                    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Tag class])
                                                              inManagedObjectContext:self.managedObjectContext];
                    [request setEntity:entity];
                    NSString *predicateCommand = [NSString stringWithFormat:@"urlName = '"];
                    predicateCommand = [predicateCommand stringByAppendingString:[tagsDic valueForKey:@"url_name"]];
                    predicateCommand = [predicateCommand stringByAppendingString:@"'"];

                    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateCommand];
                    [request setPredicate:predicate];

                    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:request error:nil];
                    if (fetchedObjects.count) {
                        for (Tag *tag in fetchedObjects) {
                            [tags addObject:tag];
                            [item addTagsObject:tag];
                        }
                    } else {
                        Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Tag class])
                                                                 inManagedObjectContext:self.managedObjectContext];
                        tag.tagName = [responseDic valueForKey:@"name"];
                        tag.iconUrl = [responseDic valueForKey:@"icon_url"];
                        tag.itemCount = [responseDic valueForKey:@"item_count"];
                        tag.urlName = [responseDic valueForKey:@"url_name"];
                        tag.followerCount = [responseDic valueForKey:@"follower_count"];
                        [item addTagsObject:tag];
                    }

                    tagsDic = [tagsEnumerator nextObject];
                }

                item.stockCount = [responseDic valueForKey:@"stock_count"];
                item.itemTitle = [responseDic valueForKey:@"title"];
                item.updatedAtInWords = [responseDic valueForKey:@"updated_at_in_words"];
                item.itemBody = [[responseDic valueForKey:@"body"] isEqual:[NSNull null]] ? @"" : [responseDic valueForKey:@"body"];
                item.itemUrl = [responseDic valueForKey:@"url"];
                item.updatedAt = [responseDic valueForKey:@"updated_at"];
                item.gistUrl = [[responseDic valueForKey:@"gist_url"] isEqual:[NSNull null]] ? @"" : [responseDic valueForKey:@"gist_url"];
                item.createdAt = [responseDic valueForKey:@"created_at"];
                item.commentCount = [responseDic valueForKey:@"comment_count"];
                item.itemPrivates = [responseDic valueForKey:@"private"];

                User *user = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([User class])
                                                           inManagedObjectContext:self.managedObjectContext];
                NSDictionary *userDic = [responseDic valueForKey:@"user"];

                NSFetchRequest *userRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *userEntity = [NSEntityDescription entityForName:NSStringFromClass([User class])
                                                              inManagedObjectContext:self.managedObjectContext];
                [userRequest setEntity:userEntity];
                NSString *userPredicateCommand = [NSString stringWithFormat:@"url_name = '"];
                userPredicateCommand = [userPredicateCommand stringByAppendingString:[userDic valueForKey:@"url_name"]];
                userPredicateCommand = [userPredicateCommand stringByAppendingString:@"'"];

                NSPredicate *userPredicate = [NSPredicate predicateWithFormat:userPredicateCommand];
                [userRequest setPredicate:userPredicate];

                NSArray *userFetchedObjects = [[self managedObjectContext] executeFetchRequest:userRequest error:nil];
                if (userFetchedObjects.count) {
                    user = [userFetchedObjects objectAtIndex:0];
                } else {
                    user.name = [userDic valueForKey:@"name"];
                    user.url_name = [userDic valueForKey:@"url_name"];
                    user.profile_image_url = [userDic valueForKey:@"profile_image_url"];
                }

                item.user = user;
                item.createdAtInWords = [responseDic valueForKey:@"created_at_in_words"];
                item.uuid = [responseDic valueForKey:@"uuid"];
                item.createdAtAsSeconds = [responseDic valueForKey:@"created_at_as_seconds"];

                NSError *error;
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }

                [resultArray addObject:item];
                responseDic = [resultEnumerator nextObject];
            }
        }

        [_items addObjectsFromArray:resultArray];
        itemsResult(YES, resultArray);
    }
}

- (void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error {
    [super request:request didFailLoadWithError:error];
}

- (void)requestDidCancelLoad:(TTURLRequest *)request {
    [super requestDidCancelLoad:request];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"korpokkur" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"korpokkur.sqlite"];

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end