//
//  YVTalks.h
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YVTalk;

typedef void (^YVTalksHandler)(NSDictionary *dataDict, NSError *error);

@interface YVTalks : NSObject

+ (NSFetchRequest *)allTalksFetchRequest;

+ (YVTalk *)emptyTalkInMoc:(NSManagedObjectContext *)moc;
- (YVTalk *)talkForID:(NSString *)talkID
                inMoc:(NSManagedObjectContext *)moc;

+ (NSFetchRequest *)talksRequestForDate:(NSString *)eventDate;

- (void)fetchTalksForDate:(NSString *)dateString
              withHandler:(YVTalksHandler)handler;

@end
