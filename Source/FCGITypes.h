//
//  FCGITypes.h
//  FCGIKit
//
//  Created by Magnus Nordlander on 2010-12-31.
//  Copyright 2010 E-butik i Norden AB. All rights reserved.
//

typedef uint8 FCGIVersion;
typedef uint8 FCGIRecordType;
typedef uint16 FCGIRequestRole;
typedef uint8 FCGIRequestFlags;
typedef uint16 FCGIRequestId;
typedef uint16 FCGIContentLength;
typedef uint8 FCGIPaddingLength;
typedef uint8 FCGIShortNameLength;
typedef uint32 FCGILongNameLength;
typedef uint8 FCGIShortValueLength;
typedef uint32 FCGILongValueLength;
typedef uint32 FCGIApplicationStatus;
typedef uint8 FCGIProtocolStatus;

#define FCGI_VERSION_1           1

#define FCGI_RESPONDER  1
#define FCGI_AUTHORIZER 2
#define FCGI_FILTER     3

#define FCGI_KEEP_CONN  1

#define FCGI_REQUEST_COMPLETE 0
#define FCGI_CANT_MPX_CONN    1
#define FCGI_OVERLOADED       2
#define FCGI_UNKNOWN_ROLE     3

#define FCGI_BEGIN_REQUEST       1
#define FCGI_ABORT_REQUEST       2
#define FCGI_END_REQUEST         3
#define FCGI_PARAMS              4
#define FCGI_STDIN               5
#define FCGI_STDOUT              6
#define FCGI_STDERR              7
#define FCGI_DATA                8
#define FCGI_GET_VALUES          9
#define FCGI_GET_VALUES_RESULT  10
#define FCGI_UNKNOWN_TYPE       11
#define FCGI_MAXTYPE (FCGI_UNKNOWN_TYPE)