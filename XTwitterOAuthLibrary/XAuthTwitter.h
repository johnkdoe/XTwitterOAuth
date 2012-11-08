//
//  XOAuthTwitter.h
//  XTwitterOAuth

#import "XTwitterOAuthMultiPartMITOpenSourceCopyright.h"

#import "XOAuth.h"
#import "XTwitterLoginViewController.h"

#define kXPersistentData_ScreenName                @"twitter_screenname"
#define kXPersistentData_ScreenID                  @"twitter_screenid"

// Blocks Handlers
typedef void (^XOAuthTwitterTokenRequestResult)(NSString* token,
												NSHTTPURLResponse* response,
												NSError* error);
typedef void (^XOAuthTwitterTokenAuthorizationResult)(NSString*screenName,
													  NSString* user_id,
													  NSHTTPURLResponse* response,
													  NSError* error);
typedef void (^XOAuthTwitterCredentialValidationResult)(BOOL credentialsAreValid,
														NSDictionary* userData);

@class XTwitterLoginViewController;
@interface XAuthTwitter : XOAuth

@property (copy)		NSString *	user_id;        // Twitter User ID
@property (copy)		NSString *  screen_name;	// Twitter Screen Name  (ie. @twitteruser)

// If you have presented a login panel this contains a reference to it
@property (readonly)	XTwitterLoginViewController*	currentLoginController;

#pragma mark - LOGIN VIA BUILT-IN VIEW CONTROLLER

// Use this method to start a new login session using the standard way via built-in interface
// You can also specify an handler to follow your currentProgress and a completion handler
// to get the final login result data
- (BOOL) newLoginSessionFrom:(UIViewController *)parentController
                    progress:(XOTwitterLoginCurrentStatus)currentProgress
				  completion:(XOTwitterLoginResult)completion;

// Logout current session.
- (void) logout;

#pragma mark - LOGIN METHODS (You should use it only if you plan to make a custom view-controller)

/**
 * Given a request URL, request an unauthorized OAuth token from that URL.
 * This starts the process of getting permission from user.
 * This operation uses blocks to notify you about the final operation result.
 *
 * This is the request/response specified in OAuth Core 1.0A section 6.1.
 */
- (void)requestTwitterTokenWithCallbackUrl:(NSString *) callbackUrl
								completion:(XOAuthTwitterTokenRequestResult)tokenReqResult;

/**
 * When you call this method you have your token and you need to verify authorization.
 * (only for PIN support)
 * This is the request/response specified in OAuth Core 1.0A section 6.3.
 */
- (void)verifyTwitterAuthorizationToken:(NSString *) oauth_verifier
							 completion:(XOAuthTwitterTokenAuthorizationResult)completion;


/**
 * You can use this method to validate your authorization token or get user's profile data.
 */
- (void)validateTwitterCredentialsWithCompletion:(XOAuthTwitterCredentialValidationResult)completion;

@end
