//
//  XOAuth.h
//  XTwitterOAuth

#import "XTwitterOAuthMultiPartMITOpenSourceCopyright.h"

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonDigest.h>

#define kXPersistentData_ConsumerKey               @"consumer_key"
#define kXPersistentData_ConsumerSecret            @"consumer_secret"

#define kXPersistentData_AuthToken                 @"auth_token"
#define kXPersistentData_AuthTokenSecret           @"auth_token_secret"
#define kXPersistentData_AuthTokenIsAuthorized     @"auth_token_authorized"


@interface XOAuth : NSObject

@property (copy)    NSString *          oauth_consumer_key;
@property (copy)    NSString *          oauth_consumer_secret;

// YES if this token has been authorized and can be used for production calls.
@property (assign)  BOOL                oauth_token_authorized;

// We obtain these from the provider.
// These may be either request token (oauth 1.0a 6.1.2) or access token (oauth 1.0a 6.3.2);
// determine semantics with oauth_token_authorized and call synchronousVerifyCredentials
// if you want to be really sure.
//
// For OAuth 2.0, the token simply stores the token that the provider issued, and
// token_secret is undefined.

@property (copy)    NSString *          oauth_token;
@property (copy)    NSString *          oauth_token_secret;

- (id)init;

- (id)initWithPersistentData:(NSDictionary *) persistentData;

// You initialize the object with your app (consumer) credentials.
- (id) initWithConsumerKey:(NSString *)aConsumerKey andConsumerSecret:(NSString *)aConsumerSecret;

// This is really the only critical oAuth method you need.
- (NSString *) oAuthHeaderForMethod:(NSString *)method andUrl:(NSString *)url andParams:(NSDictionary *)params;	

// Child classes need this method during initial authorization phase. No need to call during real-life use.
- (NSString *) oAuthHeaderForMethod:(NSString *)method andUrl:(NSString *)url andParams:(NSDictionary *)params
					 andTokenSecret:(NSString *)token_secret;

// If you detect a login state inconsistency in your app, use this to reset the context back to default,
// not-logged-in state.
- (void) resetState;

- (NSDictionary *) sessionPersistentData;
- (void) loadPersistentData:(NSDictionary *) persistentDict;

@end
