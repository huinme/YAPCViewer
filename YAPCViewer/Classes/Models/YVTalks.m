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
#import "YVVenues.h"
#import "YVSpeakers.h"

#import "YVDateFormatManager.h"

#import "YVAPIEndpoint.h"
#import "YVAPIRequest.h"

@interface YVTalks()

+ (NSFetchRequest *)_defaultYVTalkFetchRequest;

+ (YVAbstract *)emptyAbstractInMoc:(NSManagedObjectContext *)moc;

- (YVTalk *)_updateTalkWithDict:(NSDictionary *)dict
                        inMoc:(NSManagedObjectContext *)moc;

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

    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                             ascending:YES];
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

- (void)fetchTalksForDate:(NSString *)dateString
              withHandler:(YVTalksHandler)handler
{
    NSParameterAssert(dateString);

    NSURL *url = [YVAPIEndpoint urlForTalkListWithDate:dateString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [YVAPIRequest sendRequest:request
            completionHandler:
     ^(NSDictionary *dataDict, NSError *error) {
         if(error) {
             handler ? handler(nil, error) : nil;
             return ;
         }

         NSManagedObjectContext *moc = [[HIDataStoreManager sharedManager] subThreadMOC];
         
         NSArray *venuesArray = dataDict[@"venues"];
         [[YVVenues new] updateVenues:venuesArray
                                inMoc:moc];

         NSMutableArray *talksArray = [NSMutableArray array];
         [dataDict[@"talks_by_venue"] enumerateObjectsUsingBlock:^(NSArray *talksInVenue, NSUInteger idx, BOOL *stop) {
             NSAssert([talksInVenue isKindOfClass:[NSArray class]], @"");
             [talksArray addObjectsFromArray:talksInVenue];
         }];

         [talksArray enumerateObjectsUsingBlock:^(NSDictionary *talkDict, NSUInteger idx, BOOL *stop) {
             [self _updateTalkWithDict:talkDict inMoc:moc];
         }];

         NSError *saveError = nil;
         [[HIDataStoreManager sharedManager]  saveContext:moc
                                                    error:&saveError];
         
         handler ? handler(dataDict, nil) : nil;
     }];
}

- (YVTalk *)talkForID:(NSString *)talkID
                 inMoc:(NSManagedObjectContext *)moc
{
    NSParameterAssert(talkID);
    NSParameterAssert(moc);

    NSFetchRequest *fr = [[self class] allTalksFetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", talkID];
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

- (YVTalk *)_updateTalkWithDict:(NSDictionary *)dict
                        inMoc:(NSManagedObjectContext *)moc
{
    NSParameterAssert(dict);
    NSParameterAssert(moc);

    YVTalk *talk = [self talkForID:dict[@"id"] inMoc:moc];
    if(!talk){
        talk = [[self class] emptyTalkInMoc:moc];
    }
    
    [talk setAttriutesWithDict:dict];

    NSDictionary *speakerDict = dict[@"speaker"];
    if(speakerDict && ![speakerDict isEqual:[NSNull null]]){
        YVSpeaker *speaker = [[YVSpeakers new] speakerForID:[speakerDict valueForKey:@"id"]
                                                      inMoc:moc];
        if(!speaker){
            speaker = [YVSpeakers emptySpeakerInMoc:moc];
        }
        
        [speaker setAttriutesWithDict:speakerDict];

        talk.speaker = speaker;
        [speaker addTalksObject:talk];
    }

    id abstractValue = dict[@"abstract"];
    if(abstractValue && ![abstractValue isEqual:[NSNull null]]) {
        if(talk.abstract){
            [moc deleteObject:talk.abstract];
        }

        YVAbstract *abstract = [[self class] emptyAbstractInMoc:moc];

        abstract.abstract = abstractValue;

        talk.abstract = abstract;
        abstract.talk = talk;
    }

    NSNumber *venueID = @([dict[@"venue_id"] intValue]);
    YVVenue *venue = [[YVVenues new] venueForID:venueID inMoc:moc];
    if(venue){
        talk.venue = venue;
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
    
    return talk;
}

@end
