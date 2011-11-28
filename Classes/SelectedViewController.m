//
//  SelectedViewController.m
//  TED
//
//  Created by Andrew Vergara on 4/27/11.
//  Copyright 2011 Studio Noodlehouse. All rights reserved.
//

#import "SelectedViewController.h"
#import "OpenNC.h"
#import "TEDAppDelegate.h"

@implementation SelectedViewController

@synthesize loadingView;
@synthesize selectedData;
@synthesize activityIndicator, selectedTalkBtn, selectedTalkBg, selectedTalkDescription;
@synthesize talkBtn, playBtn, loadVideoOverlay;

-(BOOL)reachable {
    Reachability *r = [Reachability reachabilityWithHostName:@"google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus != ReachableViaWiFi) {
        return NO;
    }
	return NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.navigationController.navigationBar.hidden = NO;
    
	UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TED-logo-sm.png"]];
	[imgView setContentMode:UIViewContentModeScaleAspectFit];
	[imgView setFrame:CGRectMake(0, 0, 50, 17.5)];
	self.navigationItem.titleView = imgView;
    
    playBtn.alpha = 0.0;
    playBtn.hidden = YES;
    selectedTalkBg.hidden = YES;
    selectedTalkDescription.text = [selectedData objectForKey:@"description"];
    
    playBtn.userInteractionEnabled = NO;
    talkBtn.userInteractionEnabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"selected data: %@", selectedData);
    [[OpenNC getInstance] getImage:self callback:@selector(displayMainImage:) imageURL:[selectedData objectForKey:@"overlayURL"] context:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)displayMainImage:(NSDictionary *)image {	
    
    playBtn.hidden = NO;
    selectedTalkBg.hidden = NO;
    
	UIImage *fullImage = [image objectForKey:@"image"];

	[selectedTalkBtn setImage:fullImage];
	

    UILabel *noToPlay = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 300, 20)];    
    
    NSArray* durationSplit = [[selectedData objectForKey:@"duration"] componentsSeparatedByString: @":"];
    NSString* durationMinute = [durationSplit objectAtIndex: 1];
    int minuteInt = [durationMinute intValue];
    
    //Click to Play
    if ([self reachable] || minuteInt < 10) {
        playBtn.userInteractionEnabled = YES;
        talkBtn.userInteractionEnabled = YES;        
    }else {
        noToPlay.textAlignment = UITextAlignmentCenter;
        noToPlay.textColor = [UIColor whiteColor];
        noToPlay.font = [UIFont boldSystemFontOfSize:14.0];
        noToPlay.backgroundColor = [UIColor clearColor];
        noToPlay.shadowColor = [UIColor blackColor];
        noToPlay.shadowOffset = CGSizeMake(1.0, 1.0);
        noToPlay.text = @"(video unavailable over cellular network)";
        noToPlay.numberOfLines = 0;
        [self.view addSubview:noToPlay];
        noToPlay.alpha = 0.0;
        
        UIImage *noPlayBtnImage = [UIImage imageNamed:@"noplay-btn.png"];
        [playBtn setImage:noPlayBtnImage forState:UIControlStateNormal];        
    }

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDelay:0.2];
    playBtn.transform = CGAffineTransformMakeTranslation(0, 10.0);
    playBtn.alpha = 1.0;
    noToPlay.alpha = 1.0;
    [UIView commitAnimations];
    
    
    //Talk Subtitle
	UILabel *heading = [[UILabel alloc] initWithFrame:CGRectMake(15, 182, 290, 50)];
	heading.textAlignment = UITextAlignmentLeft;
	heading.textColor = [UIColor whiteColor];
	heading.font = [UIFont boldSystemFontOfSize:14.0];
	heading.backgroundColor = [UIColor clearColor];
	heading.text = [selectedData objectForKey:@"subtitle"];
	heading.numberOfLines = 0;
	[self.view addSubview:heading];
    
    activityIndicator.hidden = YES;
}


#pragma mark - User Interactions
- (IBAction)playSelectedTalk:(id)sender
{    
    [self prepMoviePlayer:[selectedData objectForKey:@"videoURL"] loadingView:loadingView];
}


#pragma mark - MoviePlayer
- (void)prepMoviePlayer:(NSString *)movieName loadingView:(UIView *)loadingOverlay
{
    loadVideoOverlay = loadingOverlay;
    
    loadVideoOverlay.center = CGPointMake(160, 226);
    [self.view addSubview:loadVideoOverlay];
    
    loadVideoOverlay.alpha = 0.0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    loadVideoOverlay.transform = CGAffineTransformMakeTranslation(0, -20.0);
    loadVideoOverlay.alpha = 1.0;
    [UIView commitAnimations];    
    
    self.view.userInteractionEnabled = NO;
    
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle) {		
		//NSString *moviePath = [bundle pathForResource:movieName ofType:@"mp4"];
        //		NSLog(@"%@", movieName);
        //		NSLog(@"%@", moviePath);
		if (movieName){
			
            NSURL* videoURL = [NSURL URLWithString:movieName];

            moviePlayerController= [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
            moviePlayer = [moviePlayerController moviePlayer];
			[moviePlayer setFullscreen:YES];
			moviePlayer.scalingMode = MPMovieScalingModeAspectFit;			
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

        moviePlayer.view.alpha = 0.0;
        
        self.view.userInteractionEnabled = YES;
        [loadVideoOverlay removeFromSuperview];
        
        [UIView beginAnimations:@"playVideo" context:nil];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        
        moviePlayer.view.alpha = 1.0;
        
        [UIView commitAnimations];

        [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
        
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Memory Management
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


@end