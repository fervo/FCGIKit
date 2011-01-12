//
//  FCGIBeginRequestRecord.m
//  FCGIKit
//
//  Created by Magnus Nordlander on 2011-01-01.
//  Copyright 2011 Smiling Plants HB. All rights reserved.
//

#import "FCGIBeginRequestRecord.h"


@implementation FCGIBeginRequestRecord

@synthesize flags, role;

-(NSString*)description
{
  return [NSString stringWithFormat:@"FCGIBeginRequestRecord - Role: %d, Flags: %d, %@", self.role, self.flags, [super description]];
}

-(void)processContentData:(NSData*)data
{
  uint16 bigEndianRole;
  [data getBytes:&bigEndianRole range:NSMakeRange(0, 2)];
  self.role = EndianU16_BtoN(bigEndianRole);

  [data getBytes:&flags range:NSMakeRange(2, 1)];
}

@end
