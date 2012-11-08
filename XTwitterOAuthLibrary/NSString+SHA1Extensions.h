//
//  NSString+SHA1Extensions.h
//  XTwitterOAuth

#import "XTwitterOAuthMultiPartMITOpenSourceCopyright.h"

#import <Foundation/Foundation.h>

@interface NSString (SHA1Extensions)

- (NSString*)signClearTextWithSecret:(NSString*)secret;

@end
