//
//  HTTPRequest.m
//  Timetable
//
//  Created by Alex Lima on 15/12/14.
//  Copyright (c) 2014 Alex Lima. All rights reserved.
//

#import "HTTPRequest.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation HTTPRequest

-(AFHTTPRequestOperation *)POST:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *, id))success
                        failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    return [super POST:URLString
            parameters:parameters
               success:success
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   if (operation.response.statusCode == 409) {
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"INVALID_USER" object:nil userInfo:nil];
                   }
                   failure(operation, error);
    }];
}

-(AFHTTPRequestOperation *)GET:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(AFHTTPRequestOperation *, id))success
                       failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    return [super GET:URLString
           parameters:parameters
              success:success
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if (operation.response.statusCode == 409) {
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"INVALID_USER" object:nil userInfo:nil];
                  }
                  failure(operation, error);
    }];
}

@end
