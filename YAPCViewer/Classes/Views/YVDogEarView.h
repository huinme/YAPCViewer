//
//  YVDogEarView.h
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/26/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YVTalk;

@protocol YVDogEarViewDelegate

- (void)tappedFavorite:(UITapGestureRecognizer *)sender;

@end

@interface YVDogEarView : UIView

- (void)loadDataFromTalk:(YVTalk *)talk;

@property (nonatomic, assign, getter = isEnabled) BOOL enabled;
@property (nonatomic, weak) NSObject<YVDogEarViewDelegate> *delegate;
@property (nonatomic, strong) NSString *talkId;

@end
