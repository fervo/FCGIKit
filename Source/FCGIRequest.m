//
//  FCGIRequest.m
//  FCGIKit
//
//  Created by Magnus Nordlander on 2010-12-31.
//  Copyright 2010 Smiling Plants HB. All rights reserved.
//

#import "FCGIRequest.h"


@implementation FCGIRequest
@synthesize requestId, role, keepConnection, parameters, socket, stdinData;

- (id)initWithBeginRequestRecord:(FCGIBeginRequestRecord *)record {
    if ((self = [super init])) {
      self.requestId = record.requestId;
      self.role = record.role;
      self.keepConnection = ((record.flags & FCGI_KEEP_CONN) != 0);
      
      self.parameters = [NSMutableDictionary dictionaryWithCapacity:20];
      self.stdinData = [NSMutableData dataWithCapacity:1024];
    }
    
    return self;
}

-(void)writeDataToStderr:(NSData*)data
{
  FCGIByteStreamRecord* stdErrRecord = [[FCGIByteStreamRecord alloc] init];
  stdErrRecord.version = FCGI_VERSION_1;
  stdErrRecord.type = FCGI_STDERR;
  stdErrRecord.requestId = self.requestId;
  stdErrRecord.contentLength = [data length];
  stdErrRecord.paddingLength = 0;
  stdErrRecord.data = data;
  
  [self.socket writeData:[stdErrRecord protocolData] withTimeout:-1 tag:0];
  [stdErrRecord release];
}

-(void)writeDataToStdout:(NSData*)data
{
  FCGIByteStreamRecord* stdOutRecord = [[FCGIByteStreamRecord alloc] init];
  stdOutRecord.version = FCGI_VERSION_1;
  stdOutRecord.type = FCGI_STDOUT;
  stdOutRecord.requestId = self.requestId;
  stdOutRecord.contentLength = [data length];
  stdOutRecord.paddingLength = 0;
  stdOutRecord.data = data;
  
  [self.socket writeData:[stdOutRecord protocolData] withTimeout:-1 tag:0];
  [stdOutRecord release];
}

-(void)doneWithProtocolStatus:(FCGIProtocolStatus)protocolStatus applicationStatus:(FCGIApplicationStatus)applicationStatus
{
  FCGIEndRequestRecord* endRequestRecord = [[FCGIEndRequestRecord alloc] init];
  endRequestRecord.version = FCGI_VERSION_1;
  endRequestRecord.type = FCGI_END_REQUEST;
  endRequestRecord.requestId = self.requestId;
  endRequestRecord.contentLength = 8;
  endRequestRecord.paddingLength = 0;
  endRequestRecord.applicationStatus = applicationStatus;
  endRequestRecord.protocolStatus = protocolStatus;
    
  [self.socket writeData:[endRequestRecord protocolData] withTimeout:-1 tag:0];
  [endRequestRecord release];
  
  if (!keepConnection)
  {
    [self.socket disconnectAfterWriting];
  }
  else {
    [self.socket readDataToLength:FCGIRecordFixedLengthPartLength withTimeout:FCGITimeout tag:FCGIRecordAwaitingHeaderTag];
  }
}


- (void)dealloc {
    // Clean-up code here.
  [parameters release];
  [socket release];
  [stdinData release];

  [super dealloc];
}

@end
