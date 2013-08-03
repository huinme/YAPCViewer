//
//  RKLDataStoreManager.h
//  RestKitLearning
//
//  Created by kshuin on 7/14/13.
//  Copyright (c) 2013 genesix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HIDataStoreManager : NSObject

+ (HIDataStoreManager *)sharedManager;

- (NSManagedObjectContext *)mainThreadMOC;

- (NSManagedObjectContext *)subThreadMOC;
- (void)saveChildContext:(NSManagedObjectContext *)subMOC;

@end
