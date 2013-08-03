//
//  YVSpeaker.h
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface YVSpeaker : NSManagedObject

@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * service;
@property (nonatomic, retain) NSManagedObject *talks;

@end
