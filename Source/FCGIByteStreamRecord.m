//
//  FCGIStdinRecord.m
//  FCGIKit
//
//  Created by Magnus Nordlander on 2011-01-01.
//  Copyright 2011 Smiling Plants HB. All rights reserved.
//

#import "FCGIByteStreamRecord.h"


@implementation FCGIByteStreamRecord

@synthesize data;

- (id)init {
    if ((self = [super init])) {
    }
    
    return self;
}

- (void)dealloc {
  [data release];
    
    [super dealloc];
}

-(void)processContentData:(NSData*)_data
{
  self.data = [_data subdataWithRange:NSMakeRange(0, self.contentLength)];
}

-(NSString*)description
{
  return [NSString stringWithFormat:@"FCGIStdinRecord - Data: %@, %@", self.data, [super description]];
}

-(NSData*)protocolData
{
  NSMutableData* protocolData = [NSMutableData dataWithCapacity:1024];
  [protocolData appendData:[self headerProtocolData]];
  
  [protocolData appendData:self.data];
  
  return protocolData;
}

@end
