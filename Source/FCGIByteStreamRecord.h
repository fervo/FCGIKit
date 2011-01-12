//
//  FCGIStdinRecord.h
//  FCGIKit
//
//  Created by Magnus Nordlander on 2011-01-01.
//  Copyright 2011 Smiling Plants HB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCGIRecord.h"
#import <CoreServices/CoreServices.h>

@interface FCGIByteStreamRecord : FCGIRecord {
@private
    NSData* data;
}
@property (nonatomic, retain) NSData* data;

-(NSData*)protocolData;
@end
