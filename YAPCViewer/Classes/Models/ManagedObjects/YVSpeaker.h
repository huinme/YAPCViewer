//
//  YVSpeaker.h
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YVTalk;

@interface YVSpeaker : NSManagedObject

@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * service;
@property (nonatomic, retain) NSSet *talks;

@end

@interface YVSpeaker (CoreDataGeneratedAccessors)

- (void)addTalksObject:(YVTalk *)value;
- (void)removeTalksObject:(YVTalk *)value;
- (void)addTalks:(NSSet *)values;
- (void)removeTalks:(NSSet *)values;

@end


