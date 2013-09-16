//
//  YVDateFormatManager.h
//  YAPCViewer
//
//  Created by kshuin on 8/4/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const YVDateFormatManagerDefaultDateFormat;
extern NSString *const YVDateFormatManagerShortDateFormat;
extern NSString *const YVDateFormatManagerJapaneseDateFormat;

@interface YVDateFormatManager : NSObject

+ (YVDateFormatManager *)sharedManager;

@property (nonatomic, strong, readonly) NSDateFormatter *defaultFormatter;
@property (nonatomic, strong, readonly) NSDateFormatter *japaneseDateFormatter;

@property (nonatomic, strong, readonly) NSCalendar *defaultCalendar;
@property (nonatomic, assign, readonly) NSRange yyyyMMddRange;
@property (nonatomic, assign, readonly) NSRange HHmmRange;

@end
