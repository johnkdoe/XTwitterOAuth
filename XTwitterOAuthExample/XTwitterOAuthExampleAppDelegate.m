//
//  XTwitterOAuthExampleAppDelegate.m
//  XTwitterOAuth

#import "XTwitterOAuthMultiPartMITOpenSourceCopyright.h"

#import "XTwitterOAuthExampleAppDelegate.h"
#import "XTwitterOAuthExampleViewController.h"

#import "XTwitterCore.h"

@implementation XTwitterOAuthExampleAppDelegate

- (BOOL)				application:(UIApplication *)application
	  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[XTwitterOAuthExampleViewController alloc]
									initWithNibName:@"XTwitterOAuthExampleViewController"
											 bundle:nil];

    self.navigationController
	  = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    // restore session if available
    [XTwitter shared];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
			openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
		 annotation:(id)annotation
{
    return [[XTwitter shared].currentLoginController handleTokenRequestResponseURL:url];
}

@end
