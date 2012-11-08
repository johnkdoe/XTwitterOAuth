# XTwitterOAuth 

An Objective-C library made using blocks implementing OAuth protocol plus an example iOS (iPhone) app demonstrating its use.

(based on Daniele Margutti's DMTwitterOAuth git://github.com/malcommac/DMTwitterOAuth.git .)

Daniele Margutti, <http://www.danielem.org>
First original work by Jaanus Kase

## How to get started

1. Register your app with Twitter at http://dev.twitter.com/apps
1. Get the XTwitterOAuth source.
1. Register your app scheme and implement iOS's handle URL delegate (see XTwitter.h for a complete doc)
1. Edit XTwitter.h with your consumer key and secret that Twitter gives you
1. (You need to drag files under 'XTwitterOAuth Library' XCode group folder, register a custom scheme URL and handle openURL app delegate method in order to use this library in your project ... although there is code to auto-handle the custom-scheme if you look carefully.)

## To test

1. Compile and run our example.

Daniele tested it under XCode 4.1 and iOS 5.1 both on device and simulator.
I've tested it under XCode 4.5 and iOS 5.1.1 on device.

## Change log

### November 8, 2012

* Removed reliance on JSONKit and use NSJSONSerialization instead
* Re-organized the library files and example files in the filesystem to live
  in distinct sub-folders, and re-organize the Project similarly
* added XTwitterDanieleMarguttiCopyright.h to most files that had his original confusing copyright
* remove the "don't compile with ARC" flag from the NSString+
* fixed some member name manglings (i.e. hanlder to handler, completition to completion)
* changed project/class/filename prefixes from DM to H


### May 13, 2012

* Original version from Daniele Margutti

## Donations

If you found this project useful, please donate.
There’s no expected amount and I don’t require you to.

<a href='https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=GS3DBQ69ZBKWJ">CLICK THIS LINK TO DONATE USING PAYPAL</a>

## License (MIT)

Copyright (c) 2010 Jaanus Kase

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
