//
//  YLTCPSocket.h
//  YLTCPBroadcasterSample
//
//  Created by Yannick Loriot on 27/10/14.
//  Copyright (c) 2014 Yannick Loriot. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSUInteger kTCPSocketDefaultTimeoutInSeconds;

typedef void (^YLTCPSocketCompletionBlock) (BOOL success, NSString *message);

@interface YLTCPSocket : NSObject
@property (nonatomic, strong, readonly) NSString *hostname;
@property (nonatomic, readonly) NSUInteger       port;

- (id)initWithHostname:(NSString *)hostname port:(NSUInteger)port;
+ (instancetype)socketWithHostname:(NSString *)hostname port:(NSUInteger)port;

- (void)connectWithCompletionHandler:(YLTCPSocketCompletionBlock)completion;
- (void)connectWithTimeout:(NSTimeInterval)timeout completionHandler:(YLTCPSocketCompletionBlock)completion;

@end
