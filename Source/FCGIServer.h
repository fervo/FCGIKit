//
//  FCGIServer.h
//  FCGIKit
//
//  Created by Magnus Nordlander on 2010-12-31.
//  Copyright (C) 2011 by Smiling Plants HB
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "FCGIRecord.h"
#import "FCGIBeginRequestRecord.h"
#import "FCGIParamsRecord.h"
#import "FCGIByteStreamRecord.h"
#import "FCGIRequest.h"

#define FCGIRecordFixedLengthPartLength 8
#define FCGITimeout 5

enum _FCGISocketTag
{
  FCGIRecordAwaitingHeaderTag,
  FCGIRecordAwaitingContentAndPaddingTag
} FCGISocketTag;

@class FCGIRequest;

typedef void(^FCGIRequestHandlerBlock)(FCGIRequest*);

@interface FCGIServer : NSObject {
@private
  UInt16 _port;
  FCGIRequestHandlerBlock _paramsAvailableBlock;
  FCGIRequestHandlerBlock _stdinAvailableBlock;  
  
  dispatch_queue_t _socketQueue;
	GCDAsyncSocket* _listenSocket;
  
  BOOL _isRunning;
  
  NSMutableArray* _connectedSockets;
  NSMutableDictionary* _currentRequests;
}

@property (nonatomic, assign) BOOL isRunning;
@property (readwrite, copy) FCGIRequestHandlerBlock paramsAvailableBlock;
@property (readwrite, copy) FCGIRequestHandlerBlock stdinAvailableBlock;

-(id)initWithPort:(UInt16)port;

-(BOOL)startWithError:(NSError**)errorPtr;
-(void)stop;

-(void)handleRecord:(FCGIRecord*)record fromSocket:(GCDAsyncSocket*)socket;

#pragma mark -
#pragma mark GCDAsyncSocket Delegate methods

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket;
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;

@end
