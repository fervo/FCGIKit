//
//  main.m
//  FCGIKit
//
//  Created by Magnus Nordlander on 2010-12-31.
//  Copyright 2010 E-butik i Norden AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCGIServer.h"
#import "FCGIRequest.h"
#import "FCGITypes.h"

int main (int argc, const char * argv[]) {

  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

  FCGIServer* server = [[FCGIServer alloc] initWithPort:9000];
                        
  server.paramsAvailableBlock = ^(FCGIRequest* request) {
  };
  server.stdinAvailableBlock = ^(FCGIRequest* request) {
    [request writeDataToStdout:[@"HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 8\r\n\r\nTest" dataUsingEncoding:NSASCIIStringEncoding]];
    
    [request writeDataToStdout:[@"Test" dataUsingEncoding:NSASCIIStringEncoding]];
    
    [request doneWithProtocolStatus:FCGI_REQUEST_COMPLETE applicationStatus:0];
  };
  NSError* err;
  
  [server startWithError:&err];
  NSLog(@"%@", err);

  [pool drain];
  
  dispatch_main();
  
  return 0;
}

