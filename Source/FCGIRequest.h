//
//  FCGIRequest.h
//  FCGIKit
//
//  Created by Magnus Nordlander on 2010-12-31.
//  Copyright 2010 Smiling Plants HB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCGITypes.h"
#import "FCGIBeginRequestRecord.h"
#import "FCGIByteStreamRecord.h"
#import "FCGIEndRequestRecord.h"
#import "GCDAsyncSocket.h"
#import "FCGIServer.h"

@interface FCGIRequest : NSObject {
@private
  FCGIRequestId requestId;
  FCGIRequestRole role;
  BOOL keepConnection;
  NSMutableDictionary* parameters;
  GCDAsyncSocket* socket;
  NSMutableData* stdinData;
}
@property (nonatomic, assign) FCGIRequestId requestId; 
@property (nonatomic, assign) FCGIRequestRole role; 
@property (nonatomic, assign) BOOL keepConnection;
@property (nonatomic, retain) NSMutableDictionary* parameters;
@property (nonatomic, retain) GCDAsyncSocket* socket;
@property (nonatomic, retain) NSMutableData* stdinData;

-(id)initWithBeginRequestRecord:(FCGIBeginRequestRecord*)record;

-(void)writeDataToStdout:(NSData*)data;
-(void)writeDataToStderr:(NSData*)data;
-(void)doneWithProtocolStatus:(FCGIProtocolStatus)protocolStatus applicationStatus:(FCGIApplicationStatus)applicationStatus;
@end
