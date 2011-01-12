//
//  FCGIServer.h
//  FCGIKit
//
//  Created by Magnus Nordlander on 2010-12-31.
//  Copyright 2010 Smiling Plants HB. All rights reserved.
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
