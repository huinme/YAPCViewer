//
//  RKLDataStoreManager.h
//  RestKitLearning
//
//  Created by kshuin on 7/14/13.
//  Copyright (c) 2013 genesix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#warning - Replace to your managed object model file's name ('.momd' files name)
static NSString *const HIManagedObjectModelName = @"Models";

@interface HIDataStoreManager : NSObject

+ (HIDataStoreManager *)sharedManager;

- (NSManagedObjectContext *)mainThreadMOC;

- (NSManagedObjectContext *)subThreadMOC;
- (void)saveChildContext:(NSManagedObjectContext *)subMOC;

@end
