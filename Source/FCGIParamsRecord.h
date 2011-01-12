//
//  FCGIParamsRecord.h
//  FCGIKit
//
//  Created by Magnus Nordlander on 2011-01-01.
//  Copyright 2011 Smiling Plants HB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCGIRecord.h"
#import "FCGITypes.h"

@interface FCGIParamsRecord : FCGIRecord {
@private
  NSMutableDictionary* params;
}
@property (nonatomic, retain) NSMutableDictionary* params;

@end
