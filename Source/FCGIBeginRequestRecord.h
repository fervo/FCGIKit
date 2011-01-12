//
//  FCGIBeginRequestRecord.h
//  FCGIKit
//
//  Created by Magnus Nordlander on 2011-01-01.
//  Copyright 2011 Smiling Plants HB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCGIRecord.h"
#import "FCGITypes.h"

@interface FCGIBeginRequestRecord : FCGIRecord {
@private
  FCGIRequestRole role;
  FCGIRequestFlags flags;
}

@property (nonatomic, assign) FCGIRequestRole role;
@property (nonatomic, assign) FCGIRequestFlags flags;

@end
