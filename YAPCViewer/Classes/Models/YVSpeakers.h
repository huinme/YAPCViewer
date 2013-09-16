//
//  YVSpeakers.h
//  YAPCViewer
//
//  Created by kshuin on 8/25/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YVSpeaker;

@interface YVSpeakers : NSObject

+ (NSFetchRequest *)allSpeakersFetchRequest;
+ (YVSpeaker *)emptySpeakerInMoc:(NSManagedObjectContext *)moc;

- (YVSpeaker *)speakerForID:(NSString *)speakerID
                      inMoc:(NSManagedObjectContext *)moc;

@end
