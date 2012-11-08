//
//  XTwitterOAuthExampleViewController.m
//  XTwitterOAuth

#import "XTwitterOAuthMultiPartMITOpenSourceCopyright.h"

#import "XTwitterOAuthExampleViewController.h"
#import "XAuthTwitter.h"
#import "XTwitterCore.h"

@interface XTwitterOAuthExampleViewController ()
{
    IBOutlet    UIButton*       btn_loginLogout;
    IBOutlet    UILabel*        lbl_welcome;
    IBOutlet    UITextView*     tw_userData;
}

- (IBAction)btn_twitterLogin:(id)sender;
+ (NSString *) readableCurrentLoginStatus:(XOTwitterLoginStatus) cstatus;

@end

@implementation XTwitterOAuthExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Twitter OAuth";
	__weak XTwitter* xtwitter = [XTwitter shared];
    if (xtwitter.oauth_token_authorized) {
        [btn_loginLogout setTitle:@"Already Logged, Press to Logout"
						 forState:UIControlStateNormal];
        [lbl_welcome setText:[NSString stringWithFormat:@"You're %@!", xtwitter.screen_name]];
        tw_userData.text = @"";
    }
}

- (IBAction)btn_twitterLogin:(id)sender {
	__block XTwitter* xtwitter = [XTwitter shared];
    if (xtwitter.oauth_token_authorized) {
        // already logged, execute logout
        [xtwitter logout];
        [btn_loginLogout setTitle:@"Twitter Login" forState:UIControlStateNormal];
        [lbl_welcome setText:@"Press \"Twitter Login!\" to start!"];
        tw_userData.text = @"";
    }
	else
	{
		XOTwitterLoginCurrentStatus btn_twitterLogin_currentStatus
		  = ^(XOTwitterLoginStatus currentStatus)
			{
				NSLog(@"current status = %@",
					  [XTwitterOAuthExampleViewController readableCurrentLoginStatus:currentStatus]);
			};
		XOTwitterLoginResult btn_twitterLogin_completion
		  = ^(NSString* screenName, NSString* user_id, NSError* error)
			{
				if (error != nil)
				{
					NSLog(@"Twitter login failed: %@",error);
				}
				else
				{
					NSLog(@"Welcome %@!",screenName);

					[btn_loginLogout setTitle:@"Twitter Logout" forState:UIControlStateNormal];
					[lbl_welcome setText:[NSString stringWithFormat:@"Welcome %@!",screenName]];
					[tw_userData setText:@"Loading your user info..."];

					// store our auth data so we can use later in other sessions
					[xtwitter saveCredentials];

					NSLog(@"Now getting more data...");
					// you can use this call in order to validate your credentials
					// or get more user's info data
					[xtwitter validateTwitterCredentialsWithCompletion:
					 ^(BOOL credentialsAreValid,
					   NSDictionary *userData)
					 {
						 if (credentialsAreValid)
							 tw_userData.text
							 = [NSString stringWithFormat:@"Data for %@ (userid=%@):\n%@",
								screenName,
								user_id,
								userData];
						 else
							 tw_userData.text
							 = @"Cannot get more data. Token is not authorized to get this info.";
					 }];
				}
			};

		// prompt login
        [xtwitter newLoginSessionFrom:self.navigationController
							 progress:btn_twitterLogin_currentStatus
						   completion:btn_twitterLogin_completion];
    }
}

+ (NSString *)readableCurrentLoginStatus:(XOTwitterLoginStatus) cstatus {
    switch (cstatus)
	{
      case XOTwitterLoginStatus_PromptUserData:
		return @"Prompt for user data and request token to server";
	  case XOTwitterLoginStatus_RequestingToken:
		return @"Requesting token for current user's auth data...";
	  case XOTwitterLoginStatus_TokenReceived:
		return @"Token received from server";
	  case XOTwitterLoginStatus_VerifyingToken:
		return @"Verifying token...";
	  case XOTwitterLoginStatus_TokenVerified:
		return @"Token verified";
	  default:
		return @"[unknown]";
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
