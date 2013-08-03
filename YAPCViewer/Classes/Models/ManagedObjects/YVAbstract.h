//
//  YVAbstract.h
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface YVAbstract : NSManagedObject

@property (nonatomic, retain) NSString * abstract;
@property (nonatomic, retain) NSManagedObject *talk;

@end
