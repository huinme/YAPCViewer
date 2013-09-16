//
//  YVAPIEndpoints.h
//  YAPCViewer
//
//  Created by kshuin on 8/25/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YVAPIEndpoint : NSObject

+ (NSURL *)urlForTalkListWithDate:(NSString *)dateString;

@end
