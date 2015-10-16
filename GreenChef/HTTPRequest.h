//
//  HTTPRequest.h
//  Timetable
//
//  Created by Alex Lima on 15/12/14.
//  Copyright (c) 2014 Alex Lima. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface HTTPRequest : AFHTTPRequestOperationManager

-(AFHTTPRequestOperation *)POST:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *, id))success
                        failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;
-(AFHTTPRequestOperation *)GET:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(AFHTTPRequestOperation *, id))success
                       failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;
@end
