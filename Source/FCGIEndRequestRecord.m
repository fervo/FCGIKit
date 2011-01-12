//
//  FCGIEndRequestRecord.m
//  FCGIKit
//
//  Created by Magnus Nordlander on 2011-01-01.
//  Copyright 2011 Smiling Plants HB. All rights reserved.
//

#import "FCGIEndRequestRecord.h"


@implementation FCGIEndRequestRecord

@synthesize applicationStatus, protocolStatus;

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    // Clean-up code here.
    
    [super dealloc];
}

-(NSData*)protocolData
{
  NSMutableData* protocolData = [NSMutableData dataWithCapacity:1024];
  [protocolData appendData:[self headerProtocolData]];
  
  uint32 bigEndianApplicationStatus = EndianU32_NtoB(self.applicationStatus);
  [protocolData appendBytes:&bigEndianApplicationStatus length:4];
  
  [protocolData appendBytes:&protocolStatus length:1];
  
  unsigned char reserved = 0x00;
  [protocolData appendBytes:&reserved length:1];
  [protocolData appendBytes:&reserved length:1];
  [protocolData appendBytes:&reserved length:1];
  
  return protocolData;
}

@end
