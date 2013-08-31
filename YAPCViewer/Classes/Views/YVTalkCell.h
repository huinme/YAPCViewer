//
//  YVTalkCell.h
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YVTalk;

@protocol YVTalkCellDelegate

- (void)tappedFavorite:(UITapGestureRecognizer *)sender;

@end

@interface YVTalkCell : UITableViewCell

+ (CGFloat)cellHeight;
+ (UIColor *)backgroundColor;

- (void)loadDataFromTalk:(YVTalk *)talk;
- (NSString *)talkId;

@property (nonatomic, weak) NSObject<YVTalkCellDelegate> *delegate;

@end
