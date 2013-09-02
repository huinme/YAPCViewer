//
//  YVSectionHeader.h
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/4/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YVSectionHeader : UIView

@property (nonatomic, copy) NSString *sectionTitle;

+ (CGFloat)defaultHeaderHeight;

@end
