//
//  XTwitter.m
//  XTwitterOAuth

#import "XTwitterOAuthMultiPartMITOpenSourceCopyright.h"

#import "XTwitter.h"

#define kXTwitterSingleton_PersistentData  @"kXTwitterSingleton_PersistentData"

@implementation XTwitter

+ (XTwitter *) shared {
    static dispatch_once_t _pred;
    static XTwitter* _shared = nil;
    
    dispatch_once(&_pred, ^{
        NSData* saved_credentials
		  = [[NSUserDefaults standardUserDefaults] objectForKey:kXTwitterSingleton_PersistentData];
        if (saved_credentials != nil)
            _shared = [[XTwitter alloc] initWithPersistentData:[NSKeyedUnarchiver unarchiveObjectWithData:saved_credentials]];
        else
            _shared = [[XTwitter alloc] initWithConsumerKey:kXTwitterSingleton_ConsumerKey
										 andConsumerSecret:kXTwitterSingleton_SecretKey];
    });
    return _shared;
}

- (void) logout {
    [super logout];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXTwitterSingleton_PersistentData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) saveCredentials {
    if (self.oauth_token_authorized == NO)
		return NO;
	NSData* session = [NSKeyedArchiver archivedDataWithRootObject:[self sessionPersistentData]];
    [[NSUserDefaults standardUserDefaults] setObject:session
                                              forKey:kXTwitterSingleton_PersistentData];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

@end
