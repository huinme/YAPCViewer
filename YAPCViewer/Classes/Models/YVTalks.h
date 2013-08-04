//
//  YVTalks.h
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const YVTalksSerivceErrorDomain;

typedef void (^YVTalksHandler)(NSDictionary *dataDict, NSError *error);

@interface YVTalks : NSObject

+ (NSFetchRequest *)allTalksFetchRequest;
+ (NSFetchRequest *)talksRequestForDate:(NSString *)eventDate;

- (void)fetchAllTalksWithHandler:(YVTalksHandler)handler;

@end
