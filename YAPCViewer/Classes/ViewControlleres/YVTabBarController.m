//
//  YVTabBarController.m
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/25/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVTabBarController.h"

#import <FontAwesomeKit/FontAwesomeKit.h>

@interface YVTabBarController ()

@end

@implementation YVTabBarController

- (void)awakeFromNib
{
    self.tabBar.clipsToBounds = YES;

    NSArray *icons = @[FAKIconMicrophone, FAKIconMapMarker, FAKIconComment, FAKIconInfo];
    NSDictionary *shadowAttr = @{FAKShadowAttributeColor : [UIColor whiteColor],
                                 FAKShadowAttributeOffset : [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)],
                                 FAKShadowAttributeBlur : [NSNumber numberWithFloat:1.0f]};
    NSDictionary *unselectedIconAttrs = @{FAKImageAttributeForegroundColor : [UIColor colorForHex:@"#474747"],
                                          FAKImageAttributeBackgroundColor : [UIColor clearColor],
                                          FAKImageAttributeShadow : shadowAttr};
    NSMutableDictionary *selectedIconAttrs = unselectedIconAttrs.mutableCopy;
    selectedIconAttrs[FAKImageAttributeForegroundColor] = [UIColor colorForHex:@"#1d6ed2"];

    CGSize iconSize = CGSizeMake(30.0f, 30.0f);
    CGFloat iconFontSize = 26.0f;

    [icons enumerateObjectsUsingBlock:^(NSString *icon, NSUInteger idx, BOOL *stop) {
        UIImage *unselectedIconImage = [FontAwesomeKit imageForIcon:icon
                                                          imageSize:iconSize
                                                           fontSize:iconFontSize
                                                         attributes:unselectedIconAttrs];
        UIImage *selectedIconImage = [FontAwesomeKit imageForIcon:icon
                                                        imageSize:iconSize
                                                         fontSize:iconFontSize
                                                       attributes:selectedIconAttrs];
        
        UITabBarItem *tab = self.tabBar.items[idx];
        [tab setFinishedSelectedImage:selectedIconImage
          withFinishedUnselectedImage:unselectedIconImage];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
