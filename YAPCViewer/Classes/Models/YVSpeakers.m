//
//  YVSpeakers.m
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/25/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVSpeakers.h"

#import "YVModels.h"

@interface YVSpeakers()

@end

@implementation YVSpeakers

+ (NSFetchRequest *)allSpeakersFetchRequest
{
    NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([YVSpeaker class])];
    [fr setFetchBatchSize:20];

    return fr;
}

+ (YVSpeaker *)emptySpeakerInMoc:(NSManagedObjectContext *)moc
{
    NSParameterAssert(moc);

    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([YVSpeaker class])
                                              inManagedObjectContext:moc];
    YVSpeaker *speaker = [[YVSpeaker alloc] initWithEntity:entity
                            insertIntoManagedObjectContext:moc];

    return speaker;
}

- (YVSpeaker *)speakerForID:(NSString *)speakerID
                      inMoc:(NSManagedObjectContext *)moc
{
    NSParameterAssert(speakerID);
    NSParameterAssert(moc);

    NSFetchRequest *fr = [[self class] allSpeakersFetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", speakerID];
    [fr setPredicate:predicate];

    [fr setFetchLimit:1];

    NSError *fetchError = nil;
    NSArray *fetchedObjects = [moc executeFetchRequest:fr
                                                 error:&fetchError];
    if(fetchError || 0 == [fetchedObjects count]){
        return nil;
    }

    return [fetchedObjects lastObject];
}



@end
