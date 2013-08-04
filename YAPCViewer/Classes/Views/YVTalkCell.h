//
//  YVTalkCell.h
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YVTalk;

@interface YVTalkCell : UITableViewCell

+ (CGFloat)cellHeight;
+ (UIColor *)backgroundColor;

- (void)loadDataFromTalk:(YVTalk *)talk;

@end
