//
//  NSManagedObject+SafetyMapping.h
//  YAPCViewer
//
//  Created by kshuin on 8/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (SafetyMapping)

- (void)setAttriutesWithDict:(NSDictionary *)dict;

@end
