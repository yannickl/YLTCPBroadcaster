/*
 * YLTCPBroadcaster
 *
 * Copyright 2014 - present, Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "YLTCPSocket.h"

#include <sys/time.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

const NSUInteger kYLTCPSocketDefaultTimeoutInSeconds = 2;

@interface YLTCPSocket ()
@property (nonatomic, strong) NSString         *hostname;
@property (nonatomic, assign) SInt32           port;
@property (nonatomic, strong) dispatch_queue_t backgroundQueue;

@end

@implementation YLTCPSocket

#pragma mark Creating and Initializing TCP Sockets

- (id)initWithHostname:(NSString *)hostname port:(SInt32)port {
  if ((self = [super init])) {
    NSParameterAssert(hostname);
    NSParameterAssert(port);

    _hostname = hostname;
    _port     = port;

    _backgroundQueue = dispatch_queue_create("com.yannickloriot.tcpsocket.queue", NULL);
  }
  return self;
}

+ (instancetype)socketWithHostname:(NSString *)hostname port:(SInt32)port {
  return [[self alloc] initWithHostname:hostname port:port];
}

#pragma mark - Connecting with Host

- (YLTCPSocketStatus)connectWithTimeoutInterval:(NSTimeInterval)timeout {
  // http://stackoverflow.com/questions/2597608/c-socket-connection-timeout
  // http://developerweb.net/viewtopic.php?id=3196
  int sockfd, res, valopt;
  long arg;
  fd_set fdset;
  socklen_t socklen;
  struct sockaddr_in serv_addr;
  struct hostent *endpoint;
  struct timeval tv;

  // Open the socket
  sockfd = socket(AF_INET, SOCK_STREAM, 0);

  if (sockfd < 0) {
    return YLTCPSocketStatusOpenSocketError;
  }

  // Create the remote endpoint
  endpoint = gethostbyname([_hostname cStringUsingEncoding:NSUTF8StringEncoding]);

  if (endpoint == NULL) {
    close(sockfd);

    return YLTCPSocketStatusNoHostError;
  }

  // Build the socket description
  bzero((char *) &serv_addr, sizeof(serv_addr));
  serv_addr.sin_family = AF_INET;
  bcopy((char *)endpoint->h_addr,
        (char *)&serv_addr.sin_addr.s_addr,
        endpoint->h_length);
  serv_addr.sin_port = htons(_port);

  // Set non-blocking
  if ((arg = fcntl(sockfd, F_GETFL, NULL)) < 0) {
    close(sockfd);

    return YLTCPSocketStatusError;
  }

  arg |= O_NONBLOCK;

  if (fcntl(sockfd, F_SETFL, arg) < 0) {
    close(sockfd);

    return YLTCPSocketStatusError;
  }

  // Trying to connect with timeout
  res = connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr));

  if (res < 0) {
    if (errno == EINPROGRESS) {
      // Set the timeout interval
      double timeoutDecimal = (NSInteger)timeout;
      tv.tv_sec             = timeoutDecimal;
      tv.tv_usec            = (timeout - timeoutDecimal) * 1000;

      FD_ZERO(&fdset);
      FD_SET(sockfd, &fdset);

      res = select(sockfd + 1, NULL, &fdset, NULL, &tv);

      if (res < 0 && errno != EINTR) {
        close(sockfd);

        return YLTCPSocketStatusError;
      }
      else if (res > 0) {
        // Socket selected for write
        socklen = sizeof(socklen_t);

        if (getsockopt(sockfd, SOL_SOCKET, SO_ERROR, (void*)(&valopt), &socklen) < 0) {
          close(sockfd);

          return YLTCPSocketStatusError;
        }

        // Check the returned value...
        if (valopt) {
          close(sockfd);

          return YLTCPSocketStatusError;
        }

        // The endpoint is alive!
        if (valopt == 0) {
          close(sockfd);

          return YLTCPSocketStatusOpened;
        }
      }
      else {
        close(sockfd);

        return YLTCPSocketStatusTimeOutError;
      }
    }
    else {
      close(sockfd);

      return YLTCPSocketStatusError;
    }
  }

  close(sockfd);

  return YLTCPSocketStatusError;
}

- (void)connectWithCompletionHandler:(YLTCPSocketCompletionBlock)completion {
  [self connectWithTimeoutInterval:kYLTCPSocketDefaultTimeoutInSeconds completionHandler:completion];
}

- (void)connectWithTimeoutInterval:(NSTimeInterval)timeout completionHandler:(YLTCPSocketCompletionBlock)completion {
  dispatch_async(_backgroundQueue, ^ {
    YLTCPSocketCompletionBlock performCompletionHandler = ^ (BOOL success, NSString *errorMessage) {
      if (completion) {
        dispatch_async(dispatch_get_main_queue(), ^{
          completion(success, errorMessage);
        });
      }
    };

    YLTCPSocketStatus status = [self connectWithTimeoutInterval:timeout];

    switch (status) {
      case YLTCPSocketStatusError:
        return performCompletionHandler(NO, @"Connection error");
      case YLTCPSocketStatusOpenSocketError:
        return performCompletionHandler(NO, @"Can not opening socket");
      case YLTCPSocketStatusNoHostError:
        return performCompletionHandler(NO, @"No such host");
      case YLTCPSocketStatusTimeOutError:
        return performCompletionHandler(NO, @"Timeout");
      case YLTCPSocketStatusOpened:
        return performCompletionHandler(YES, @"Remote TCP socket opened");
    }
  });
}

@end
