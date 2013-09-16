//
//  YVUIThemeManager.m
//  YAPCViewer
//
//  Created by kshuin on 8/25/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVUIThemeManager.h"

@implementation YVUIThemeManager

+ (void)customizeAppearance
{
    UINavigationBar *barAppearance = [UINavigationBar appearanceWhenContainedIn:[UINavigationController class], nil];
    barAppearance.tintColor = [UIColor colorForHex:@"#eaeaea"];
    [barAppearance setTitleTextAttributes:@{ UITextAttributeFont : [UIFont boldSystemFontOfSize:20.0f],
                UITextAttributeTextColor : [UIColor colorForHex:@"#474747"],
          UITextAttributeTextShadowColor : [UIColor whiteColor],
         UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.5f)]}];

    UITabBar *tabBarAppearance = [UITabBar appearanceWhenContainedIn:[UITabBarController class], nil];
    tabBarAppearance.tintColor = [UIColor colorForHex:@"#eaeaea"];
    if([tabBarAppearance respondsToSelector:@selector(setShadowImage:)]){
        tabBarAppearance.shadowImage  = nil;
    }

    UITabBarItem *tabBarItemAppearance = [UITabBarItem appearanceWhenContainedIn:[UITabBar class], nil];
    [tabBarItemAppearance setTitleTextAttributes:@{ UITextAttributeFont : [UIFont boldSystemFontOfSize:10.0f],
                       UITextAttributeTextColor : [UIColor colorForHex:@"#474747"],
                 UITextAttributeTextShadowColor : [UIColor whiteColor],
                UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)]}
                                        forState:UIControlStateNormal];
    [tabBarItemAppearance setTitleTextAttributes:@{ UITextAttributeFont : [UIFont boldSystemFontOfSize:10.0f],
                       UITextAttributeTextColor : [UIColor colorForHex:@"#1d6ed2"],
                 UITextAttributeTextShadowColor : [UIColor whiteColor],
                UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)]}
                                        forState:UIControlStateSelected];

    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    [barButtonItem setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor colorForHex:@"#666666"],
          UITextAttributeTextShadowColor : [UIColor whiteColor],
         UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)]}
                                 forState:UIControlStateNormal];
    [barButtonItem setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor colorForHex:@"#474747"],
          UITextAttributeTextShadowColor : [UIColor whiteColor],
         UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)]}
                                 forState:UIControlStateHighlighted];
}

@end
