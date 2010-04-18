//
//  SpinWheelAppDelegate.m
//  SpinWheel
//
#import "SpinWheelAppDelegate.h"
#import "SpinWheelViewController.h"

@implementation SpinWheelAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
