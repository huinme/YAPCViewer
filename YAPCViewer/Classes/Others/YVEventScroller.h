//
//  YVEventScroller.h
//  YAPCViewer
//
//  Created by kshuin on 9/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YVEventScroller : NSObject

- (id)initWitnEventDays:(NSArray *)eventDays;

- (NSString *)currentDate;
- (NSString *)currentDateTime;

- (NSInteger)eventIndexForCurrentDate;
- (NSInteger)sectionIndexForCurrentTimeWithSections:(NSArray *)sections;

@end
