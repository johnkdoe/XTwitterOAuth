//
//  XTwitterLoginViewController.h
//  XTwitterOAuth

#import "XTwitterOAuthMultiPartMITOpenSourceCopyright.h"

#import <UIKit/UIKit.h>

enum {
	XOTwitterLoginStatus_PromptUserData		= 0,	// Step 0. Prompt for user auth data

	XOTwitterLoginStatus_RequestingToken	= 1,	// Step 1. Requesting authorization token
													//		   with user's data
	XOTwitterLoginStatus_TokenReceived		= 2,	// Step 2. Token is received
													//		   (can or can't be valid)
	XOTwitterLoginStatus_VerifyingToken		= 3,	// Step 3. Verifying token authorization

	XOTwitterLoginStatus_TokenVerified		= 4		// Step 4. Token is verified.
													//		   XOTwitterLoginResult handler
													//		   contains data of login or error
};

typedef NSUInteger XOTwitterLoginStatus;

// Blocks handler
typedef void (^XOTwitterLoginCurrentStatus)(XOTwitterLoginStatus currentStatus);
typedef void (^XOTwitterLoginResult)(NSString* screenName, NSString* user_id, NSError* error);

@class XAuthTwitter;

@interface XTwitterLoginViewController : UIViewController

// webView instance of the built-in login view controller
@property (readonly)			UIWebView*	webView;

// assign a value only if you plan to use a custom URL scheme
@property (nonatomic, assign)	NSString*	customURLScheme;

- (id)initWithOAuthSession:(XAuthTwitter *) authObj
           progressHandler:(XOTwitterLoginCurrentStatus)currentProgress
		 completionHandler:(XOTwitterLoginResult)completion;

- (BOOL) handleTokenRequestResponseURL:(NSURL *) url;

@end
