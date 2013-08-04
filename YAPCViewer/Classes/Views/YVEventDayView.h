//
//  YVEventDayView.h
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/4/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YVEventDayView;

@protocol YVEventDayViewDelegate

- (void)eventDayView:(YVEventDayView *)eventDayView
       dayDidChanged:(NSString *)dayString;

@end


@interface YVEventDayView : UIView

@property (nonatomic, weak) NSObject<YVEventDayViewDelegate> *delegate;

@property (nonatomic, strong) NSArray *eventDays;

@end
