//
//  YVEventScroller.m
//  YAPCViewer
//
//  Created by kshuin on 9/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVEventScroller.h"

#import "YVDateFormatManager.h"

@interface YVEventScroller()

@property (nonatomic, strong) NSArray *eventDays;

@end

@implementation YVEventScroller

- (id)initWitnEventDays:(NSArray *)eventDays
{
    self = [super init];
    if (self) {
        _eventDays = eventDays;
    }
    return self;
}

static NSString *const kYVEventScrollerDateFormat = @"yyyy-MM-dd HH:mm";

- (NSString *)currentDate
{
    return [[self currentDateTime] substringWithRange:NSMakeRange(0, 10)];
}

- (NSString *)currentDateTime
{
    NSDateFormatter *df = [YVDateFormatManager sharedManager].defaultFormatter;
    df.dateFormat = kYVEventScrollerDateFormat;
    NSString *dateString = [df stringFromDate:[NSDate date]];

    return dateString;
}

- (NSInteger)eventIndexForCurrentDate
{
    NSString *dateString = [self currentDate];
    NSInteger index = [self.eventDays indexOfObject:dateString];

    return index;
}

- (NSInteger)sectionIndexForCurrentTimeWithSections:(NSArray *)sections
{
    NSParameterAssert(sections);

    NSArray *names = [sections valueForKeyPath:@"name"];
    if (0 == names.count) {
        return NSNotFound;
    }

    NSDateFormatter *df = [YVDateFormatManager sharedManager].defaultFormatter;
    df.dateFormat = @"HH:mm";
    NSString *currentTime = [df stringFromDate:[NSDate date]];

    /*
     * [1:11 compare:0:00] => DESC
     * [1:11 compare:2:00] => ASC
     * [1:11 compare:1:11] => SAME
     */
    NSUInteger index = [names indexOfObjectWithOptions:NSEnumerationReverse
                                           passingTest:
                        ^BOOL(NSString *time, NSUInteger idx, BOOL *stop) {
                            NSComparisonResult result = [currentTime compare:time];

                            if (NSOrderedDescending == result) {
                                return YES;
                            }
                            
                            return NO;
                        }];

    return index;
}

@end
