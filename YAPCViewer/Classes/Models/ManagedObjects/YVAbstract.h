//
//  YVAbstract.h
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YVTalk;

@interface YVAbstract : NSManagedObject

@property (nonatomic, retain) NSString * abstract;
@property (nonatomic, retain) YVTalk *talk;

@end
