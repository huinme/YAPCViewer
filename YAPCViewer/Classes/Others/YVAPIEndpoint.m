//
//  YVAPIEndpoints.m
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/25/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVAPIEndpoint.h"

static NSString *const kYVAPIEndpointScheme  = @"http";
static NSString *const kYVAPIEndpointBaseURL = @"yapcasia.org";
static NSString *const kYVAPIEndpointTalkListPath = @"/2013/api/talk/list";

static NSString *const kTalkListPathFormat = @"/2013/talk/schedule?date=%@&format=json";

@interface YVAPIEndpoint()

+ (NSString *)_baseURL;

+ (NSString *)_talkListPath;

@end

@implementation YVAPIEndpoint

+ (NSString *)_baseURL
{
    return [NSString stringWithFormat:@"%@://%@", kYVAPIEndpointScheme, kYVAPIEndpointBaseURL];
}

+ (NSString *)_talkListPath
{
    return kYVAPIEndpointTalkListPath;
}

+ (NSURL *)urlForTalkList
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [self _baseURL], [self _talkListPath]];

    return [NSURL URLWithString:urlString];
}

+ (NSURL *)urlForTalkListWithDate:(NSString *)dateString
{
    NSString *baseURLString = [self _baseURL];
    NSString *apiURLString = [baseURLString stringByAppendingFormat:kTalkListPathFormat, dateString];

    return [NSURL URLWithString:apiURLString];
}

@end
