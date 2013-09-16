//
//  YVAPIRequest.m
//  YAPCViewer
//
//  Created by kshuin on 8/25/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "YVAPIRequest.h"

// Extern Constants
NSString *const YVTalksSerivceErrorDomain = @"YVTalksSerivceErrorDomain";

@interface YVAPIRequest()

@end

@implementation YVAPIRequest

+ (void)sendRequest:(NSURLRequest *)request
  completionHandler:(YVAPIRequestHandler)handler
{
    NSParameterAssert(request);

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         if(error){
             handler ? handler(nil, error) : nil;
             return;
         }

         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         if(httpResponse.statusCode >= 400){
             error = [NSError errorWithDomain:YVTalksSerivceErrorDomain
                                         code:httpResponse.statusCode
                                     userInfo:nil];
             handler ? handler(nil, error) : nil;
             return;
         }

         NSError *jsonError = nil;
         NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:0
                                                                    error:&jsonError];
         if(jsonError || nil == dataDict){
             error = [NSError errorWithDomain:YVTalksSerivceErrorDomain
                                         code:0
                                     userInfo:nil];
             handler ? handler(nil, error) : nil;
             return;
         }

         handler ? handler(dataDict, nil) : nil;
     }];
}

@end
