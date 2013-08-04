//
//  YVAppDelegate.m
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVAppDelegate.h"

#import "HIDataStoreManager.h"

@implementation YVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [HIDataStoreManager sharedManager];

    UINavigationBar *barAppearance = [UINavigationBar appearanceWhenContainedIn:[UINavigationController class], nil];
    barAppearance.tintColor = [UIColor colorForHex:@"#eaeaea"];
    [barAppearance setTitleTextAttributes:@{ UITextAttributeFont : [UIFont boldSystemFontOfSize:20.0f],
                                             UITextAttributeTextColor : [UIColor colorForHex:@"#474747"],
                                             UITextAttributeTextShadowColor : [UIColor whiteColor],
                                             UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.5f)]}];

    UITabBar *tabBarAppearance = [UITabBar appearanceWhenContainedIn:[UITabBarController class], nil];
    tabBarAppearance.tintColor = [UIColor colorForHex:@"#eaeaea"];
    tabBarAppearance.shadowImage = nil;

    UITabBarItem *tabBarItemAppearance = [UITabBarItem appearanceWhenContainedIn:[UITabBar class], nil];
    [tabBarItemAppearance setTitleTextAttributes:@{ UITextAttributeFont : [UIFont boldSystemFontOfSize:12.0f],
                                                    UITextAttributeTextColor : [UIColor colorForHex:@"#474747"],
                                                    UITextAttributeTextShadowColor : [UIColor whiteColor],
                                                    UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)]}
                                        forState:UIControlStateNormal];
    [tabBarItemAppearance setTitleTextAttributes:@{ UITextAttributeFont : [UIFont boldSystemFontOfSize:12.0f],
                                                    UITextAttributeTextColor : [UIColor colorForHex:@"#1d6ed2"],
                                                    UITextAttributeTextShadowColor : [UIColor whiteColor],
                                                    UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)]}
                                                                    forState:UIControlStateSelected];

//    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], [UINavigationBar class], nil];
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    [barButtonItem setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor colorForHex:@"#666666"],
                                             UITextAttributeTextShadowColor : [UIColor whiteColor],
                                            UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)]}
                                 forState:UIControlStateNormal];
    [barButtonItem setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor colorForHex:@"#474747"],
                                             UITextAttributeTextShadowColor : [UIColor whiteColor],
                                             UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)]}
                                 forState:UIControlStateHighlighted];


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
