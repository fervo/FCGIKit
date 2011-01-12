//
//  FCGIRecord.h
//  FCGIKit
//
//  Created by Magnus Nordlander on 2010-12-31.
//  Copyright 2010 Smiling Plants HB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCGITypes.h"
#import <CoreServices/CoreServices.h>

/*typedef struct {
  unsigned char version;
  unsigned char type;
  unsigned char requestIdB1;
  unsigned char requestIdB0;
  unsigned char contentLengthB1;
  unsigned char contentLengthB0;
  unsigned char paddingLength;
  unsigned char reserved;
  unsigned char contentData[contentLength];
  unsigned char paddingData[paddingLength];
} FCGI_Record;*/

@interface FCGIRecord : NSObject {
@protected
  FCGIVersion version;
  FCGIRecordType type;
  FCGIRequestId requestId;
  FCGIContentLength contentLength;
  FCGIPaddingLength paddingLength;
}

@property (nonatomic, assign) FCGIVersion version;
@property (nonatomic, assign) FCGIRecordType type;
@property (nonatomic, assign) FCGIRequestId requestId;
@property (nonatomic, assign) FCGIContentLength contentLength;
@property (nonatomic, assign) FCGIPaddingLength paddingLength;

+(id)recordWithHeaderData:(NSData*)data;
-(void)processContentData:(NSData*)data;
-(NSData*)headerProtocolData;

@end
