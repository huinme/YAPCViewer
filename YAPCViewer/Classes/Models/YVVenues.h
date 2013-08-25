//
//  YVVenues.h
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/25/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  YVVenue;

@interface YVVenues : NSObject

+ (NSFetchRequest *)allVenuesFetchRequest;
+ (YVVenue *)emptyVenueInMoc:(NSManagedObjectContext *)moc;
- (YVVenue *)venueForID:(NSNumber *)venueID
                  inMoc:(NSManagedObjectContext *)moc;

+ (NSArray *)fetchAllVenuesInMoc:(NSManagedObjectContext *)moc;

- (void)updateVenues:(NSArray *)venuesArray
               inMoc:(NSManagedObjectContext *)moc;

@end
