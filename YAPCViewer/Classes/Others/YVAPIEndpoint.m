//
//  YVAPIEndpoints.m
//  YAPCViewer
//
//  Created by kshuin on 8/25/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVAPIEndpoint.h"

static NSString *const kYVAPIEndpointScheme  = @"http";
static NSString *const kYVAPIEndpointBaseURL = @"yapcasia.org";

static NSString *const kTalkListPathFormat = @"/2013/talk/schedule?date=%@&format=json";

@interface YVAPIEndpoint()

+ (NSString *)_baseURL;

@end

@implementation YVAPIEndpoint

+ (NSString *)_baseURL
{
    return [NSString stringWithFormat:@"%@://%@", kYVAPIEndpointScheme, kYVAPIEndpointBaseURL];
}

+ (NSURL *)urlForTalkListWithDate:(NSString *)dateString
{
    NSString *baseURLString = [self _baseURL];
    NSString *apiURLString = [baseURLString stringByAppendingFormat:kTalkListPathFormat, dateString];

    return [NSURL URLWithString:apiURLString];
}

@end
