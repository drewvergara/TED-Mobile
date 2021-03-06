//
//  TEDAppDelegate.m
//  TED
//
//  Created by Andrew Vergara on 3/4/11.
//  Copyright 2011 Studio Noodlehouse. All rights reserved.
//

#import "TEDAppDelegate.h"
#import "RootViewController.h"


@implementation TEDAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize introOverlay, rootViewControllerHolder;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    navigationController = [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil]];
    //navigationController.navigationBar.tintColor = [UIColor blackColor];
    navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // Add the navigation controller's view to the window and display.	
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    
    
//    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.rootViewControllerHolder resetViewController];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    
    [self.rootViewControllerHolder recreateInterface];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark - View Controller Properties
- (void)saveRootViewControllerHolder:(RootViewController *)controller
{
    self.rootViewControllerHolder = controller;
}

#pragma mark - Intro Overlay
- (void)addOverlay:(UIView *)overlay
{
    introOverlay = overlay;
    [self.window addSubview:introOverlay];
}

- (void)removeOverlay
{
	[UIView beginAnimations:@"removeOverlay" context:nil];
	[UIView setAnimationDelay:0.1];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
	introOverlay.alpha = 0.0;
    introOverlay.transform = CGAffineTransformMakeScale(2.0, 2.0);
	
	[UIView commitAnimations];
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"removeOverlay"]) {
        [introOverlay removeFromSuperview];
    }
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}




@end

