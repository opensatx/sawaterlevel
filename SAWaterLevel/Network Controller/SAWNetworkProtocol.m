//
//  SAWNetworkProtocol.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWNetworkProtocol.h"

@interface SAWNetworkProtocol ()
@end

@implementation SAWNetworkProtocol

+ (void)registerProtocol {
    [self registerClass:[SAWNetworkProtocol class]];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    
}

- (void)stopLoading {
    
}

@end
