//
//  YVTalkCell.h
//  YAPCViewer
//
//  Created by kshuin on 8/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YVTalk;
@class YVDogEarView;

@interface YVTalkCell : UITableViewCell

@property (nonatomic, strong) YVDogEarView *dogEarView;

+ (CGFloat)cellHeight;
+ (UIColor *)backgroundColor;

- (void)loadDataFromTalk:(YVTalk *)talk;

@end
