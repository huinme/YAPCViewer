//
//  YVTalks.m
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVTalks.h"

#import "HIDataStoreManager.h"

#import "YVModels.h"
#import "YVDateFormatManager.h"

#import "YVAPIEndpoint.h"
#import "YVAPIRequest.h"

@interface YVTalks()

+ (NSFetchRequest *)_defaultYVTalkFetchRequest;

+ (YVTalk *)emptyTalkInMoc:(NSManagedObjectContext *)moc;
+ (YVSpeaker *)emptySpeakerInMoc:(NSManagedObjectContext *)moc;
+ (YVAbstract *)emptyAbstractInMoc:(NSManagedObjectContext *)moc;

- (YVTalk *)_insertTalkWithDict:(NSDictionary *)dict
                        inMoc:(NSManagedObjectContext *)moc;

- (void)_deleteAllMangagedObjectsInMoc:(NSManagedObjectContext *)moc;

@end

@implementation YVTalks

+ (NSFetchRequest *)allTalksFetchRequest
{
    NSFetchRequest *fr = [self _defaultYVTalkFetchRequest];

    NSSortDescriptor *dateSorter = [NSSortDescriptor sortDescriptorWithKey:@"event_date" ascending:YES];
    [fr setSortDescriptors:@[dateSorter]];

    return fr;
}

+ (NSFetchRequest *)talksRequestForDate:(NSString *)eventDate
{
    NSParameterAssert(eventDate);

    NSFetchRequest *fr = [self _defaultYVTalkFetchRequest];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"start_on contains[cd] %@", eventDate];
    [fr setPredicate:predicate];

    NSSortDescriptor *dateSorter = [NSSortDescriptor sortDescriptorWithKey:@"event_date" ascending:YES];
    NSSortDescriptor *titleSorter = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    NSSortDescriptor *enTitleSorter = [NSSortDescriptor sortDescriptorWithKey:@"title_en" ascending:YES];
    [fr setSortDescriptors:@[dateSorter, titleSorter, enTitleSorter]];

    return fr;
}

+ (NSFetchRequest *)_defaultYVTalkFetchRequest
{
    NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([YVTalk class])];

    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [fr setSortDescriptors:@[sorter]];

    [fr setFetchBatchSize:20];

    return fr;
}

+ (YVTalk *)emptyTalkInMoc:(NSManagedObjectContext *)moc
{
    NSParameterAssert(moc);

    NSEntityDescription *talkEntity = [NSEntityDescription entityForName:NSStringFromClass([YVTalk class])
                                                  inManagedObjectContext:moc];
    YVTalk *talk = [[YVTalk alloc] initWithEntity:talkEntity insertIntoManagedObjectContext:moc];

    return talk;
}

+ (YVSpeaker *)emptySpeakerInMoc:(NSManagedObjectContext *)moc
{
    NSParameterAssert(moc);

    NSEntityDescription *speakerEntiry = [NSEntityDescription entityForName:NSStringFromClass([YVSpeaker class])
                                                     inManagedObjectContext:moc];
    YVSpeaker *speaker = [[YVSpeaker alloc] initWithEntity:speakerEntiry
                            insertIntoManagedObjectContext:moc];

    return speaker;
}

+ (YVAbstract *)emptyAbstractInMoc:(NSManagedObjectContext *)moc
{
    NSParameterAssert(moc);

    NSEntityDescription *abstractEntity = [NSEntityDescription entityForName:NSStringFromClass([YVAbstract class])
                                                      inManagedObjectContext:moc];
    YVAbstract *abstract = [[YVAbstract alloc] initWithEntity:abstractEntity
                               insertIntoManagedObjectContext:moc];

    return abstract;
}

- (void)fetchAllTalksWithHandler:(YVTalksHandler)handler
{
    NSURL *url = [YVAPIEndpoint urlForTalkList];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [YVAPIRequest sendRequest:request
            completionHandler:
     ^(NSDictionary *dataDict, NSError *error) {
         if(error) {
             handler ? handler(nil, error) : nil;
             return ;
         }

         NSArray *talksArray = [dataDict valueForKey:@"talks"];
         if(!talksArray || [talksArray isEqual:[NSNull null]]) {
             error = [NSError errorWithDomain:YVTalksSerivceErrorDomain
                                         code:0
                                     userInfo:nil];
             handler ? handler(nil, error) : nil;
             return;
         }

         NSAssert(![NSThread isMainThread], @"This process must be executed on sub thread.");

         NSManagedObjectContext *moc = [HIDataStoreManager sharedManager].subThreadMOC;
         [self _deleteAllMangagedObjectsInMoc:moc]; // data not be saved in this method.

         [talksArray enumerateObjectsUsingBlock:^(NSDictionary *talkDict, NSUInteger idx, BOOL *stop) {
             [self _insertTalkWithDict:talkDict inMoc:moc];
         }];
         [[HIDataStoreManager sharedManager] saveContext:moc error:nil];
         
         handler ? handler(dataDict, nil) : nil;
     }];
}

- (YVTalk *)_insertTalkWithDict:(NSDictionary *)dict
                        inMoc:(NSManagedObjectContext *)moc
{
    NSParameterAssert(dict);
    NSParameterAssert(moc);

    YVTalk *talk = [[self class] emptyTalkInMoc:moc];
    [talk setAttriutesWithDict:dict];

    NSDictionary *speakerDict = [dict valueForKey:@"speaker"];
    if(speakerDict && ![speakerDict isEqual:[NSNull null]]){
        YVSpeaker *speaker = [[self class] emptySpeakerInMoc:moc];
        [speaker setAttriutesWithDict:speakerDict];

        talk.speaker = speaker;
        [speaker addTalksObject:talk];
    }

    id abstractValue = [dict valueForKey:@"abstract"];
    if(abstractValue && ![abstractValue isEqual:[NSNull null]]) {
        YVAbstract *abstract = [[self class] emptyAbstractInMoc:moc];
        abstract.abstract = abstractValue;

        talk.abstract = abstract;
        abstract.talk = talk;
    }

    if(talk.start_on){
        NSDateFormatter *df = [YVDateFormatManager sharedManager].defaultFormatter;
        NSRange range = [YVDateFormatManager sharedManager].HHmmRange;

        talk.event_date = [df dateFromString:talk.start_on];
        talk.start_time = [talk.start_on substringWithRange:range];

        NSCalendarUnit unit = (NSHourCalendarUnit|NSMinuteCalendarUnit);
        NSCalendar *calendar = [YVDateFormatManager sharedManager].defaultCalendar;
        NSDateComponents *components = [calendar components:unit
                                                   fromDate:talk.event_date];

        components.minute += [talk.duration intValue];
        NSDate *endDate = [calendar dateFromComponents:components];
        talk.end_time = [[df stringFromDate:endDate] substringWithRange:range];
    }

    [moc insertObject:talk];
    return talk;
}


- (void)_deleteAllMangagedObjectsInMoc:(NSManagedObjectContext *)moc
{
    NSAssert(moc != [HIDataStoreManager sharedManager].mainThreadMOC, @"");

    NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([YVTalk class])];

    NSArray *fetchedObjects = [moc executeFetchRequest:fr error:nil];
    [fetchedObjects enumerateObjectsUsingBlock:^(YVTalk *talk, NSUInteger idx, BOOL *stop) {
        [moc deleteObject:talk.speaker];
        [moc deleteObject:talk.abstract];
        [moc deleteObject:talk];
    }];
}

@end
