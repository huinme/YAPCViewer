//
//  YVTalk.h
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YVAbstract, YVSpeaker;

@interface YVTalk : NSManagedObject

@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * slide_url;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * video_permission;
@property (nonatomic, retain) NSString * video_url;
@property (nonatomic, retain) NSNumber * photo_permission;
@property (nonatomic, retain) NSString * title_en;
@property (nonatomic, retain) NSString * material_level;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * start_on;
@property (nonatomic, retain) NSString * subtitles;
@property (nonatomic, retain) YVAbstract *abstract;
@property (nonatomic, retain) YVSpeaker *speaker;

@property (nonatomic, retain) NSDate *event_date;
@property (nonatomic, retain) NSString *start_date;
@property (nonatomic, retain) NSString *start_time;
@property (nonatomic, retain) NSString *end_time;

@end
