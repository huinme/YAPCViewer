//
//  YVAPIRequest.h
//  YAPCViewer
//
//  Created by Koichi Sakata on 8/25/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const YVTalksSerivceErrorDomain;

typedef void (^YVAPIRequestHandler)(NSDictionary *dataDict, NSError *error);

@interface YVAPIRequest : NSObject

// Not implemented yet.
//+ (NSURLRequest *)getRequestWithURL:(NSURL *)url
//                             params:(NSDictionary *)params;

+ (void)sendRequest:(NSURLRequest *)request
  completionHandler:(YVAPIRequestHandler)handler;

@end
