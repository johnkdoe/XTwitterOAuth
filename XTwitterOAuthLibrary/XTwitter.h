//
//  XTwitter.h
//  XTwitterOAuth

#import "XTwitterOAuthMultiPartMITOpenSourceCopyright.h"

#import <Foundation/Foundation.h>
#import "XAuthTwitter.h"

/*
 XTwitter is a singleton for an XOAuthTwitter object.

 If you don't plan on using multiple authentication sessions in a program,
 it should be possible to safely use the singleton rather than creating a custom
 instance of XAuthTwitter.

 Generally, this class will be used in the built-in Twitter Login View Controller.
 (To see an example to work from to implement a custom panel, see XOAuthTwitter).

 Before doing anything you need to follow these simple steps:
 
    #STEP 1. REGISTER YOUR APP'S CUSTOM URL SCHEME
    ==============================================
    This library uses Callback OAuth Authentication Method,
	so Twitter Login Panel need to know how to handle response from twitter's server.

    You need to register your custom Twitter login scheme in your App Info.plist file.
	(Each app should have an unique login scheme.)

    Create key CFBundleURLTypes key (array) and add a new item (a dictionary):
	(The types above should default when created via the plist editor.)

	It should have 3 keys:
        CFBundleTypeRole    = "Editor"
        CFBundleURLName     = <your custom url identifier> (ie com.firelabsw.xtwitteroauth)
        CFBundleURLSchemes  = an array with one item, your custom scheme (*)

	(*) You can create a custom scheme and assign it to XTwitterLoginViewController instance's
		customScheme property.

		You can also use our default notation: [tw]+[your app identifier] .
		E.g. if your app identifier is "com.firelabsw.XTwitterOAuth" (as this example),
		then your custom scheme is "twxtwitteroauth" (all *lowercase*).
        
        In this sample app named XTwitterOAuth our scheme is twxtwitteroauth 
		(and we have not assigned any custom scheme)
 
    #STEP 2. ASSIGN YOUR CONSUMER/SECRET KEY
    ========================================
	After creating a twitter app at http://dev.twitter.com , two keys will be assigned:
        - Consumer Key
        - Consumer Secret Key
    Edit the #defines kXTwitterSingleton_ConsumerKey and kXTwitterSingleton_SecretKey below .
 
    #STEP 3. HANDLE TWITTER AUTH URL REQUESTS
    =========================================
    In your App Delegate file (XTwitterOAuthExampleAppDelegate.m in the example project) 
	catch the handle:
        - (BOOL)application:(UIApplication *)application 
					openURL:(NSURL *)url
		  sourceApplication:(NSString *)sourceApplication
				 annotation:(id)annotation;
 
    You need to pass this URL (if it's related to your custom Twitter Auth URL Scheme) 
	to XOAuthTwitter instance.

	If you use XTwitter singleton it's very easy. Just put:
 
        return [[XTwitter shared].currentLoginController handleTokenRequestResponseURL:url];
 
    #STEP 4. PRESENT TWITTER LOGIN PANEL TO THE USER
    ================================================
    You are now ready. Everything is ok for your login!

    Use:
        [[XTwitter shared] newLoginSessionFrom:progress:completion:]
 
    in order to show you login session window and allow user's authentication.
    Thanks to blocks you'll be informed about current login progress by progress handler and
	completion inside completion handler.

	Just one line of code and you have implemented your Twitter login!

 
                                                            OTHER INFOS...
 
 
 
    HOW TO SAVE USER'S CREDENTIALS
    ==============================
    If you use XTwitter singleton you can save user's authentication data using:
        [[XTwitter shared] saveCredentials];
    
    Credentials will stored inside application's NSUserDefaults and at next app's startup will 
	be loaded automatically.

	(If you want to implement your custom saving methods use -sessionPersistentData to get
	credentials and -loadPersistentData: to reload them in a XOAuthTwitter object.
 
 
    LOGOUT
    ======
    To logout from an authenticated session just use -logout method.
 */

#define kXTwitterSingleton_ConsumerKey		@"sKqZceKiOP2U4bJkiq9tDg"
#define kXTwitterSingleton_SecretKey		@"43VY1XtzcCQSbodzq3KxoKB3YhRFlVCpqKUnMsF6ajk"

@interface XTwitter : XAuthTwitter

// If you don't plan to use more than an XOAuthTwitter object in your app you can use this singleton. It will save to you a lot of time!
+ (XTwitter *) shared;

// Allows to save credentials (if are valid). These data will be restored automatically between app's session.
- (BOOL) saveCredentials;

@end
