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
@synthesize introOverlay;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
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
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
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


#pragma mark -
#pragma mark Intro Overlay
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
    [introOverlay removeFromSuperview];
}

#pragma mark -
#pragma mark MoviePlayer

- (void)prepMoviePlayer:(NSString *)movieName
{
	//NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"LEDHeadlamps" ofType:@"mp4"];
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle) {		
		NSString *moviePath = [bundle pathForResource:movieName ofType:@"mp4"];
		NSLog(@"%@", movieName);
		NSLog(@"%@", moviePath);
		if (movieName){
			
            NSURL* videoURL = [NSURL URLWithString:movieName];
			moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
			[moviePlayer setFullscreen:YES];
			moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
            
			CGAffineTransform transform = CGAffineTransformMakeRotation(90 * (M_PI / 180));
			moviePlayer.view.transform = transform;			
			[moviePlayer.view setFrame:CGRectMake(0, 0, 320 , 480)];
			
			moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
			
			moviePlayer.view.backgroundColor = [UIColor blackColor]; 
			[self.window addSubview:moviePlayer.view];
			
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateChanged:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
		}
	}
}

- (void)moviePlayerLoadStateChanged:(NSNotification *)notification
{
	if ([moviePlayer loadState] != MPMovieLoadStateUnknown) {		
		[moviePlayer play];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
	}		
	
}

- (void)movieDidFinish:(NSNotification*)notification
{
	[moviePlayer.view removeFromSuperview];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
	//[moviePlayer release];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

