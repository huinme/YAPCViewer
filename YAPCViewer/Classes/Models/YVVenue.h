//
//  YVVenue.h
//  YAPCViewer
//
//  Created by kshuin on 8/25/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YVTalk;

@interface YVVenue : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *talks;
@end

@interface YVVenue (CoreDataGeneratedAccessors)

- (void)addTalksObject:(YVTalk *)value;
- (void)removeTalksObject:(YVTalk *)value;
- (void)addTalks:(NSSet *)values;
- (void)removeTalks:(NSSet *)values;

@end
