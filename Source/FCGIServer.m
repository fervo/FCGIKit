//
//  FCGIServer.m
//  FCGIKit
//
//  Created by Magnus Nordlander on 2010-12-31.
//  Copyright 2010 Smiling Plants HB. All rights reserved.
//

#import "FCGIServer.h"

@implementation FCGIServer

@synthesize isRunning=_isRunning;
@synthesize paramsAvailableBlock=_paramsAvailableBlock;
@synthesize stdinAvailableBlock=_stdinAvailableBlock;

- (id)initWithPort:(UInt16)port {
  if ((self = [super init])) {
    _port = port;
    self.paramsAvailableBlock = ^(FCGIRequest* request) {};
    self.stdinAvailableBlock = ^(FCGIRequest* request) {};
    
    _socketQueue = dispatch_queue_create("SocketAcceptQueue", NULL);
    _listenSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_socketQueue];
    
    _connectedSockets = [[NSMutableArray alloc] initWithCapacity:5];
    _currentRequests = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    self.isRunning = NO;
  }
  
  return self;
}

- (void)dealloc {
  [_listenSocket release];
  dispatch_release(_socketQueue);
  [_connectedSockets release];
  [_currentRequests release];
  
  [super dealloc];
}

-(BOOL)startWithError:(NSError**)errorPtr
{
  if ([_listenSocket acceptOnPort:_port error:errorPtr])
  {
    self.isRunning = YES;
    return YES;
  }
  else
  {
    return NO;
  }
}

-(void)stop
{
  
}

-(void)handleRecord:(FCGIRecord*)record fromSocket:(GCDAsyncSocket *)socket
{
  //NSLog(@"%@", record);
  if ([record isKindOfClass:[FCGIBeginRequestRecord class]])
  {
    FCGIRequest* request = [[FCGIRequest alloc] initWithBeginRequestRecord:(FCGIBeginRequestRecord*)record];
    request.socket = socket;
    
    NSString* globalRequestId = [NSString stringWithFormat:@"%d-%d", record.requestId, [socket connectedPort]];
    
    @synchronized (_currentRequests)
    {
      [_currentRequests setObject:request forKey:globalRequestId];
    }
    
    [request release];
    
    // Carry on
    [socket readDataToLength:FCGIRecordFixedLengthPartLength withTimeout:FCGITimeout tag:FCGIRecordAwaitingHeaderTag];
  }
  else if ([record isKindOfClass:[FCGIParamsRecord class]])
  {
    NSString* globalRequestId = [NSString stringWithFormat:@"%d-%d", record.requestId, [socket connectedPort]];
    
    FCGIRequest* request;
    
    @synchronized (_currentRequests)
    {
      request = [_currentRequests objectForKey:globalRequestId];
    }
    
    NSDictionary* params = [(FCGIParamsRecord*)record params];
    
    if ([params count] > 0)
    {
      [request.parameters addEntriesFromDictionary:params];
    }
    else
    {
      // We now have enough data in our request to send it to our params available block
      self.paramsAvailableBlock(request);
    }
    
    //NSLog(@"%@", request.parameters);
    
    // Carry on
    [socket readDataToLength:FCGIRecordFixedLengthPartLength withTimeout:FCGITimeout tag:FCGIRecordAwaitingHeaderTag];
  }
  else if ([record isKindOfClass:[FCGIByteStreamRecord class]])
  {
    NSString* globalRequestId = [NSString stringWithFormat:@"%d-%d", record.requestId, [socket connectedPort]];
    
    FCGIRequest* request;
    
    @synchronized (_currentRequests)
    {
      request = [_currentRequests objectForKey:globalRequestId];
    }
    
    [request.stdinData appendData:[(FCGIByteStreamRecord*)record data]];
    
    // We now have enough data in our request to send it to our stdin available block
    self.stdinAvailableBlock(request);
    
    @synchronized (_currentRequests)
    {
      [_currentRequests removeObjectForKey:globalRequestId];
    }
  }
}

#pragma mark -
#pragma mark GCDAsyncSocket Delegate methods

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
  // Looks like a leak, but isn't.
  dispatch_queue_t acceptedSocketQueue = dispatch_queue_create([[@"SocketAcceptQueue-" stringByAppendingFormat:@"%d", [newSocket connectedPort]] cStringUsingEncoding:NSASCIIStringEncoding], NULL);
  [newSocket setDelegateQueue:acceptedSocketQueue];
  
  @synchronized(_connectedSockets)
	{
		[_connectedSockets addObject:newSocket];
	}
  
  [newSocket readDataToLength:FCGIRecordFixedLengthPartLength withTimeout:FCGITimeout tag:FCGIRecordAwaitingHeaderTag];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error
{
  //Looks like an over-release but isn't.
  dispatch_release([sock delegateQueue]);
  @synchronized(_connectedSockets)
  {
    [_connectedSockets removeObject:sock];    
  }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
  if (tag == FCGIRecordAwaitingHeaderTag)
  {
    // Seems like a leak, but isn't. We need retaincount of 1 here.
    FCGIRecord* record = [[FCGIRecord recordWithHeaderData:data] retain];
    
    if (record.contentLength == 0)
    {      
      [self handleRecord:record fromSocket:sock];
      [record release];
    }
    else
    {
      dispatch_set_context([sock delegateQueue], record);
    
      [sock readDataToLength:record.contentLength+record.paddingLength withTimeout:FCGITimeout tag:FCGIRecordAwaitingContentAndPaddingTag];
    }
  }
  else if (tag == FCGIRecordAwaitingContentAndPaddingTag)
  {
    FCGIRecord* record;
    record = dispatch_get_context([sock delegateQueue]);
    
    [record processContentData:data];
    
    [self handleRecord:record fromSocket:sock];
    //Not an over-release
    [record release];
  }
}

@end
