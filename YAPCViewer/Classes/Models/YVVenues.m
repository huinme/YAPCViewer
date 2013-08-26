//
//  YVVenues.m
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/25/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVVenues.h"

#import "YVModels.h"
#import "HIDataStoreManager.h"

@interface YVVenues()


@end

@implementation YVVenues

+ (NSFetchRequest *)allVenuesFetchRequest
{
    NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([YVVenue class])];
    [fr setFetchBatchSize:20];

    return fr;
}

+ (YVVenue *)emptyVenueInMoc:(NSManagedObjectContext *)moc
{
    NSParameterAssert(moc);

    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([YVVenue class])
                                              inManagedObjectContext:moc];

    YVVenue *venue = [[YVVenue alloc] initWithEntity:entity insertIntoManagedObjectContext:moc];

    return venue;
}

- (YVVenue *)venueForID:(NSNumber *)venueID
                  inMoc:(NSManagedObjectContext *)moc
{
    NSFetchRequest *fr = [[self class] allVenuesFetchRequest];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", venueID];
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

+ (NSArray *)fetchAllVenuesInMoc:(NSManagedObjectContext *)moc
{
    NSFetchRequest *fr = [self allVenuesFetchRequest];

    NSError *fetchError = nil;
    NSArray *fetchedObjects = [moc executeFetchRequest:fr
                                                 error:&fetchError];
    if(fetchError){
        NSLog(@"FETCH ERROR : %@", [fetchError description]);
        return @[];
    }

    return fetchedObjects;
}

- (void)updateVenues:(NSArray *)venuesArray
               inMoc:(NSManagedObjectContext *)moc
{
    NSParameterAssert(venuesArray);
    NSParameterAssert(moc);

    [venuesArray enumerateObjectsUsingBlock:^(NSDictionary *venueDict, NSUInteger idx, BOOL *stop) {
        id venueID = venueDict[@"id"];

        if (![venueID isKindOfClass:[NSNumber class]]) {
            return ;
        }

        YVVenue *venue = [self venueForID:venueID inMoc:moc];
        if(!venue){
            venue = [[self class] emptyVenueInMoc:moc];
        }

        [venue setAttriutesWithDict:venueDict];
    }];

    NSError *saveError = nil;
    [[HIDataStoreManager sharedManager] saveContext:moc
                                              error:&saveError];
    if(saveError){
        NSLog(@"SAVE ERROR : %@", saveError);
    }
}

@end
