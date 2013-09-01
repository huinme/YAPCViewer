//
//  YVDateFormatManager.m
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/4/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVDateFormatManager.h"

NSString *const YVDateFormatManagerDefaultDateFormat = @"yyyy-MM-dd HH:mm:ss";
NSString *const YVDateFormatManagerShortDateFormat = @"yyyy-MM-dd";
NSString *const YVDateFormatManagerJapaneseDateFormat = @"M月d日(EEEE)";

@implementation YVDateFormatManager

+ (YVDateFormatManager *)sharedManager
{
    static YVDateFormatManager *sharedInstance;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YVDateFormatManager alloc] init];
    });

    return sharedInstance;
}

- (NSCalendar *)defaultCalendar
{
    return [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
}

- (NSDateFormatter *)defaultFormatter
{
    static NSDateFormatter *dateFormatter;

    if(!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.formatterBehavior = NSDateFormatterBehavior10_4;
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Tokyo"];
        dateFormatter.calendar = self.defaultCalendar;
        dateFormatter.locale   = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    }

    dateFormatter.dateFormat = YVDateFormatManagerDefaultDateFormat;
    return dateFormatter;
}

- (NSDateFormatter *)japaneseDateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.formatterBehavior = NSDateFormatterBehavior10_4;
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Tokyo"];
        dateFormatter.calendar = self.defaultCalendar;
        dateFormatter.locale   = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    }

    dateFormatter.dateFormat = YVDateFormatManagerJapaneseDateFormat;
    return dateFormatter;
}


- (NSRange)yyyyMMddRange
{
    return NSMakeRange(0, 10);
}

- (NSRange)HHmmRange
{
    return NSMakeRange(11, 5);
}

@end
