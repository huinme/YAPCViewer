//
//  YVDogEarView.h
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/26/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YVTalk;
@class YVDogEarView;

@protocol YVDogEarViewDelegate

- (void)dogEarView:(YVDogEarView *)dogEarView
    didChangeState:(BOOL)enabled;

@end

@interface YVDogEarView : UIView

@property (nonatomic, assign, getter = isEnabled) BOOL enabled;
@property (nonatomic, weak) NSObject<YVDogEarViewDelegate> *delegate;

@end
