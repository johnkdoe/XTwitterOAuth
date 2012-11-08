//
//  NSString+SHA1Extensions.m
//  XTwitterOAuth

#import "XTwitterOAuthMultiPartMITOpenSourceCopyright.h"

#import "NSString+SHA1Extensions.h"
#import "Base64Transcoder.h"
#import "sha1.h"
#import "hmac.h"

@implementation NSString (SHA1Extensions)

- (NSString *)signClearTextWithSecret:(NSString *)secret
{
	NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
	NSData *clearTextData = [self dataUsingEncoding:NSUTF8StringEncoding];
	unsigned char result[20];
	hmac_sha1((unsigned char *)[clearTextData bytes], [clearTextData length],
			  (unsigned char *)[secretData bytes], [secretData length],
			  result);

    //Base64 Encoding

    char base64Result[32];
    size_t theResultLength = 32;
    Base64EncodeData(result, 20, base64Result, &theResultLength);
    NSData* theData = [NSData dataWithBytes:base64Result length:theResultLength];

	return [NSString stringWithUTF8String:theData.bytes];
}

@end
