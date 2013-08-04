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

NSString *const YVTalksSerivceErrorDomain = @"YVTalksSerivceErrorDomain";

static NSString *const kYVTalksAPIScheme  = @"http";
static NSString *const kYVTalksAPIBaseURL = @"yapcasia.org";
static NSString *const kYVTalksAPITalkListPath = @"/2013/api/talk/list";

@interface YVTalks()

+ (NSFetchRequest *)_defaultYVTalkFetchRequest;

+ (YVTalk *)emptyTalkInMoc:(NSManagedObjectContext *)moc;
+ (YVSpeaker *)emptySpeakerInMoc:(NSManagedObjectContext *)moc;
+ (YVAbstract *)emptyAbstractInMoc:(NSManagedObjectContext *)moc;

- (void)_fetchRemoteTalksWithHandler:(YVTalksHandler)handler;
- (YVTalk *)_saveTalkWithDict:(NSDictionary *)dict
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
    void (^saveDataBlock)(NSDictionary *, NSError *) = ^(NSDictionary *dataDict, NSError *error) {
        if(error){
            handler(nil, error);
            return ;
        }

        NSArray *talksArray = [dataDict valueForKey:@"talks"];
        if(!talksArray || [talksArray isEqual:[NSNull null]]) {
            error = [NSError errorWithDomain:YVTalksSerivceErrorDomain
                                        code:0
                                    userInfo:nil];
            handler(nil, error);
            return;
        }

        NSAssert(![NSThread isMainThread], @"This process must be executed on sub thread.");

        NSManagedObjectContext *moc = [HIDataStoreManager sharedManager].subThreadMOC;
        [self _deleteAllMangagedObjectsInMoc:moc]; // data not be saved in this method.

        [talksArray enumerateObjectsUsingBlock:^(NSDictionary *talkDict, NSUInteger idx, BOOL *stop) {
            [self _saveTalkWithDict:talkDict inMoc:moc];
        }];

        [[HIDataStoreManager sharedManager] saveChildContext:moc];
        handler(dataDict, nil);
    };

    [self _fetchRemoteTalksWithHandler:saveDataBlock];
}

- (void)_fetchRemoteTalksWithHandler:(YVTalksHandler)handler
{
    NSString *urlString = [NSString stringWithFormat:@"%@://%@%@",
                                                     kYVTalksAPIScheme,
                                                     kYVTalksAPIBaseURL,
                                                     kYVTalksAPITalkListPath];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         if(error){
             handler(nil, error);
             return ;
         }

         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         if(httpResponse.statusCode >= 400){
             error = [NSError errorWithDomain:YVTalksSerivceErrorDomain
                                         code:httpResponse.statusCode
                                     userInfo:nil];
             handler(nil, error);
             return;
         }

         NSError *jsonError = nil;
         NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:0
                                                                    error:&jsonError];
         if(jsonError || nil == dataDict){
             error = [NSError errorWithDomain:YVTalksSerivceErrorDomain
                                         code:0
                                     userInfo:nil];
             handler(nil, error);
             return;
         }

         handler(dataDict, nil);
     }];
}

- (YVTalk *)_saveTalkWithDict:(NSDictionary *)dict
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
