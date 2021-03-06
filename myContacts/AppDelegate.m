//
//  AppDelegate.m
//  myContacts
//
//  Created by DmitrJuga on 25.05.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

#import "AppDelegate.h"
#import "AppConstants.h"
#import "DDCoreDataHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Пример данных
    NSManagedObject *contact;
    DDCoreDataHelper *coreData = [DDCoreDataHelper sharedInstance];
    if ([coreData fetchObjectsForEntity:ENTITY_NAME_CONTACT].count == 0) {

        contact = [coreData addObjectForEntity:ENTITY_NAME_CONTACT];
        [contact setValue:@"Долотенко" forKey:ATT_LAST_NAME];
        [contact setValue:@"Дмитрий" forKey:ATT_FIRST_NAME];
        [contact setValue:@"+7 918 464-02-63" forKey:ATT_PHONE];
        [contact setValue:@"dmitrjuga@gmail.com" forKey:ATT_EMAIL];
        [contact setValue:@"I wish I can fly ;)" forKey:ATT_STATUS];
        [contact setValue:UIImagePNGRepresentation([UIImage imageNamed:@"me"]) forKey:ATT_IMAGE];
        [coreData save];

        contact = [coreData addObjectForEntity:ENTITY_NAME_CONTACT];
        [contact setValue:@"Иванов" forKey:ATT_LAST_NAME];
        [contact setValue:@"Иван" forKey:ATT_FIRST_NAME];
        [contact setValue:@"+7 933 555-44-33" forKey:ATT_PHONE];
        [contact setValue:@"ivanov@mail.ru" forKey:ATT_EMAIL];
        [contact setValue:@"руссо туристо!" forKey:ATT_STATUS];
        [coreData save];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}


@end
