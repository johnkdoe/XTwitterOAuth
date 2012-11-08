//
//  XTwitterLoginViewController.m
//  XTwitterOAuth

#import "XTwitterOAuthMultiPartMITOpenSourceCopyright.h"

#import "XTwitterLoginViewController.h"
#import "XAuthTwitter.h"

@interface XTwitterLoginViewController () <UIAlertViewDelegate, UIWebViewDelegate>
{
                UIActivityIndicatorView*	activityIndicator;
    IBOutlet    UIWebView*					webView;
    
                XAuthTwitter*				OAuthTwitter;
                XOTwitterLoginCurrentStatus	handler_currentStatus;
                XOTwitterLoginResult		handler_loginFinalResult;
}

- (void) urlcallback_requestTokenWithCallbackUrl:(NSString *)callbackUrl;

- (void) handleResultFromTwitterTokenRequest:(NSString *) token response:(NSHTTPURLResponse *) response error:(NSError *) error;
- (void) handleOAuthVerifier:(NSString *) key;

- (void) startLoginRequest;

@end

@implementation XTwitterLoginViewController

@synthesize webView;
@synthesize customURLScheme;

#pragma mark - default initializer

- (id)initWithOAuthSession:(XAuthTwitter *)authObj
           progressHandler:(XOTwitterLoginCurrentStatus)currentProgress
		 completionHandler:(XOTwitterLoginResult)completion
{
    self = [super initWithNibName:@"XTwitterLoginViewController" bundle:nil];
    if (self) {
        OAuthTwitter = authObj;
        handler_currentStatus = currentProgress;
        handler_loginFinalResult = completion;
    }
    return self;
}

#pragma mark - view controller life cycle implementation overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Twitter Login";
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.navigationItem.leftBarButtonItem
	  = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem
	  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
													  target:self
													  action:@selector(btn_cancelLoginSession:)];

    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    webView.scalesPageToFit = YES;
    webView.delegate = self;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    handler_currentStatus(XOTwitterLoginStatus_PromptUserData);
    [self startLoginRequest];
}

- (void)viewDidDisappear:(BOOL)animated {
    webView.delegate = nil;
    [webView stopLoading];
	[super viewDidDisappear:animated];
}

#pragma mark - button actions

- (IBAction)btn_cancelLoginSession:(id)sender {
    [activityIndicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [OAuthTwitter logout];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void) startLoginRequest
{
    NSString *callback_url = self.customURLScheme;
    
    if (self.customURLScheme == nil) {
        NSString* appID
		  = [[NSBundle.mainBundle.bundleIdentifier componentsSeparatedByString:@"."] lastObject];
        callback_url
		  = [[NSString stringWithFormat:@"tw%@://handleOAuthLogin", appID] lowercaseString];
    }
    [self urlcallback_requestTokenWithCallbackUrl:callback_url];
}

- (void) urlcallback_requestTokenWithCallbackUrl:(NSString *)callbackUrl
{
    handler_currentStatus(XOTwitterLoginStatus_RequestingToken);
    XOAuthTwitterTokenRequestResult callbackCompletion
	  = ^(NSString *token, NSHTTPURLResponse *response, NSError *error)
		{
			[self handleResultFromTwitterTokenRequest:token response:response error:error];
		};
    [OAuthTwitter requestTwitterTokenWithCallbackUrl:callbackUrl completion:callbackCompletion];
}

- (BOOL)handleTokenRequestResponseURL:(NSURL *) url
{
    NSArray* urlComponents = [[url absoluteString] componentsSeparatedByString:@"?"];
    NSArray* requestParameterChunks
	  = [[urlComponents objectAtIndex:1] componentsSeparatedByString:@"&"];
    for (NSString *chunk in requestParameterChunks)
	{
        NSArray *keyVal = [chunk componentsSeparatedByString:@"="];
        
        if ([[keyVal objectAtIndex:0] isEqualToString:@"oauth_verifier"])
            [self handleOAuthVerifier:[keyVal objectAtIndex:1]];
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *button_title = (buttonIndex < 0 ? nil : [alertView buttonTitleAtIndex:buttonIndex]);
    
    if (alertView.tag == XOTwitterLoginStatus_TokenReceived) {
        if ([button_title isEqualToString:@"Cancel"])
            [self.navigationController dismissModalViewControllerAnimated:YES];
        else if ([button_title isEqualToString:@"Try Again"])
            [self startLoginRequest];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - UIWebViewDelegate protocol implementation
#pragma mark @optional

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicator startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - EVENTS HANDLER

#define kXOAuthAuthorizeOAuthTokenURL @"https://api.twitter.com/oauth/authorize?oauth_token="

- (void) handleResultFromTwitterTokenRequest:(NSString*)token
									response:(NSHTTPURLResponse*)response
									   error:(NSError*)error
{
    handler_currentStatus(XOTwitterLoginStatus_TokenReceived);
    
    if (error != nil) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Failed to get token"
															message:[error domain]
														   delegate:self
												  cancelButtonTitle:@"Cancel"
												  otherButtonTitles:@"Try Again", nil];
        alertView.tag = XOTwitterLoginStatus_TokenReceived;
        [alertView show];
    }
	else
	{
		NSString* oauthTokenURL = [kXOAuthAuthorizeOAuthTokenURL stringByAppendingString:token];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:oauthTokenURL]]];
    }
}

- (void) handleOAuthVerifier:(NSString *) key
{
    handler_currentStatus(XOTwitterLoginStatus_VerifyingToken);
    XOAuthTwitterTokenAuthorizationResult verifyAuthTokenCompletion
	  = ^(NSString *screenName, NSString *user_id, NSHTTPURLResponse *response, NSError *error)
		{
			handler_currentStatus(XOTwitterLoginStatus_TokenVerified);
			handler_loginFinalResult(screenName,user_id,error);
			[self.navigationController dismissModalViewControllerAnimated:YES];
		};
    [OAuthTwitter verifyTwitterAuthorizationToken:key completion:verifyAuthTokenCompletion];
}

@end
