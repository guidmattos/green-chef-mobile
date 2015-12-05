//
//  HTTPRequest.h
//  Greenchef
//
//  Created by Guilherme Duarte Mattos on 15/12/14.
//  Copyright (c) 2015 Guilherme Duarte Mattos. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface HTTPRequest : AFHTTPRequestOperationManager

-(id)initWithAuthorization:(NSString *)authorization;
-(id)initWithAuthorizationHTTPResponse:(NSString *)authorization;

-(AFHTTPRequestOperation *)POST:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *, id))success
                        failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;
-(AFHTTPRequestOperation *)GET:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(AFHTTPRequestOperation *, id))success
                       failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;
@end
