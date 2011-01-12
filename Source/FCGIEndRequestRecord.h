//
//  FCGIEndRequestRecord.h
//  FCGIKit
//
//  Created by Magnus Nordlander on 2011-01-01.
//  Copyright 2011 Smiling Plants HB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCGIRecord.h"
#import <CoreServices/CoreServices.h>

@interface FCGIEndRequestRecord : FCGIRecord {
@private
  FCGIApplicationStatus applicationStatus;
  FCGIProtocolStatus protocolStatus;
}
@property (nonatomic, assign) FCGIApplicationStatus applicationStatus;
@property (nonatomic, assign) FCGIProtocolStatus protocolStatus;

-(NSData*)protocolData;

@end
