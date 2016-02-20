# FCGIKit

FCGIKit is a Grand Central Dispatch enabled FastCGI framework for Cocoa.

## Caveat
*This project is no longer actively developed by Fervo. We're still willing to merge PRs, but we're moving away from this internally. If you have a vested interest in this project and want to adopt it, contact us at magnus@fervo.se.*

## Requirements

* Mac OS X 10.6

## Known limitations

* Only TCP socket connections are supported. UNIX socket support is not planned.
* Only supports the FastCGI responder role.

## Sample usage

Take a look at main.m. It contains a small sample FCGI server.
