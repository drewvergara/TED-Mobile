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
@synthesize introOverlay, loadVideoOverlay;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    navigationController = [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil]];
    navigationController.navigationBar.tintColor = [UIColor blackColor];
    
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

    if ([animationID isEqualToString:@"removeOverlay"]) {
        [introOverlay removeFromSuperview];
    }
    
    if ([animationID isEqualToString:@"playVideo"]) {
        [moviePlayer play];
    }
    
    if ([animationID isEqualToString:@"stopVideo"]) {    
        [moviePlayer.view removeFromSuperview];
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
        
        [moviePlayer release];
    }

}

#pragma mark -
#pragma mark MoviePlayer

- (void)prepMoviePlayer:(NSString *)movieName loadingView:(UIView *)loadingOverlay
{
    loadVideoOverlay = loadingOverlay;
    
    loadVideoOverlay.center = CGPointMake(160, 280);
    [self.window addSubview:loadVideoOverlay];
    
    self.window.userInteractionEnabled = NO;
    
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle) {		
		//NSString *moviePath = [bundle pathForResource:movieName ofType:@"mp4"];
//		NSLog(@"%@", movieName);
//		NSLog(@"%@", moviePath);
		if (movieName){
			
            NSURL* videoURL = [NSURL URLWithString:movieName];
			moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
			//[moviePlayer setFullscreen:YES];
			moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
            
			CGAffineTransform transform = CGAffineTransformMakeRotation(90 * (M_PI / 180));
			moviePlayer.view.transform = transform;			
			[moviePlayer.view setFrame:CGRectMake(0, 0, 320 , 480)];
			
			moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
			
			moviePlayer.view.backgroundColor = [UIColor blackColor]; 
            
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateChanged:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
		}
	}
}

- (void)moviePlayerLoadStateChanged:(NSNotification *)notification
{
	if ([moviePlayer loadState] != MPMovieLoadStateUnknown) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
        [self.window addSubview:moviePlayer.view];

        moviePlayer.view.alpha = 0.0;        
        
        self.window.userInteractionEnabled = YES;
        [loadVideoOverlay removeFromSuperview];
        
        [UIView beginAnimations:@"playVideo" context:nil];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        
        moviePlayer.view.alpha = 1.0;
        
        [UIView commitAnimations];

		[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
	}		
	
}

- (void)movieDidFinish:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [moviePlayer stop];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];

    [UIView beginAnimations:@"stopVideo" context:nil];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    moviePlayer.view.alpha = 0.0;
    
    [UIView commitAnimations];
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

