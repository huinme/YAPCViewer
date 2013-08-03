//
//  RKLDataStoreManager.m
//  RestKitLearning
//
//  Created by kshuin on 7/14/13.
//  Copyright (c) 2013 genesix, Inc. All rights reserved.
//

#import "HIDataStoreManager.h"

#import <CoreData/CoreData.h>

@interface  HIDataStoreManager()

@property (nonatomic, strong) NSManagedObjectContext *mainThreadMOC;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (NSString *)dataModelName;
+ (NSURL *)dataModelURL;

+ (NSString *)dataStoreName;
+ (NSURL *)dataStoreURL;

+ (NSURL *)applicationDocumentDirecotory;

@end

@implementation HIDataStoreManager

+ (HIDataStoreManager *)sharedManager
{
  static HIDataStoreManager *sharedManager;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedManager = [[HIDataStoreManager alloc] init];
  });

  return sharedManager;
}

+ (NSString *)dataModelName
{
  return HIManagedObjectModelName;
}

+ (NSURL *)dataModelURL
{
  NSURL *url = [[NSBundle mainBundle] URLForResource:[self dataModelName] withExtension:@"momd"];
  NSAssert(url, @"url must not be nil. Is .xcdatamodeld name correct?");
  return url;
}

+ (NSString *)dataStoreName
{
  return [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
}

+ (NSURL *)dataStoreURL
{
  NSString *filename = [[self dataStoreName] stringByAppendingString:@".sqlite"];

  return [[self applicationDocumentDirecotory] URLByAppendingPathComponent:filename];
}

+ (NSURL *)applicationDocumentDirecotory
{
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                 inDomains:NSUserDomainMask] lastObject];
}

-  (id)init
{
  self = [super init];
  if(self){
    [self mainThreadMOC];
  }

  return self;
}

- (NSManagedObjectContext *)mainThreadMOC
{
  if(nil != _mainThreadMOC){
    return _mainThreadMOC;
  }

  NSAssert([NSThread isMainThread], @"Suceeded process must be executed on main thread.");
  _mainThreadMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  [_mainThreadMOC setPersistentStoreCoordinator:self.persistentStoreCoordinator];

  NSAssert(_mainThreadMOC, @"_mainThreadMOC must not be nil.");
  return _mainThreadMOC;
}

- (NSManagedObjectContext *)subThreadMOC
{
  NSAssert(![NSThread isMainThread], @"must be called on sub thread.");

  NSManagedObjectContext *subMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
  [subMOC setParentContext:self.mainThreadMOC];

  return subMOC;
}

- (void)saveChildContext:(NSManagedObjectContext *)subMOC
{
  NSParameterAssert(subMOC);
  
  if(self.mainThreadMOC == subMOC){
    return;
  }

  [subMOC performBlock:^{
    NSError *childError = nil;
    if(![subMOC save:&childError]){
      NSLog(@"CHILD SAVE ERROR : %@", [childError description]);
    }

    [self.mainThreadMOC performBlock:^{
      NSError *parentError = nil;
      if(![self.mainThreadMOC save:&parentError]){
        NSLog(@"PARENT SAVE ERROR : %@", [parentError description]);
      }
    }];
  }];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
  if(nil != _persistentStoreCoordinator){
    return _persistentStoreCoordinator;
  }

  NSURL *storeURL = [[self class] dataStoreURL];

  NSError *storeError = nil;
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
  NSPersistentStore *persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                                 configuration:nil
                                                                                           URL:storeURL
                                                                                       options:nil
                                                                                         error:&storeError];
  if(nil == persistentStore){
    NSLog(@"UNRESOLVED ERROR : %@", [storeError description]);
    abort();
  }

  NSAssert(_persistentStoreCoordinator, @"");
  return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
  if(nil != _managedObjectModel){
    return _managedObjectModel;
  }

  NSURL *url = [[self class] dataModelURL];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];

  NSAssert(_managedObjectModel, @"_managedObjectModel must not be nil.");
  return _managedObjectModel;
}

@end
