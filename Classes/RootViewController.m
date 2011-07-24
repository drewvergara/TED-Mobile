//
//  RootViewController.m
//  TED
//
//  Created by Andrew Vergara on 3/4/11.
//  Copyright 2011 Studio Noodlehouse. All rights reserved.
//

#import "RootViewController.h"
#import "OpenNC.h"
#import "TEDAppDelegate.h"
#import "SelectedViewController.h"

@implementation RootViewController

@synthesize overlayView, videoView, overlayBGImageView, loadingView;
@synthesize featuredTalk;
@synthesize mainMovie, scrollView;
@synthesize dataArray, initialMovieDictionary;

int counter = 1;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.navigationController.navigationBar.hidden = NO;
	    
	UIImageView *imgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TED-logo-sm.png"]] autorelease];
	[imgView setContentMode:UIViewContentModeScaleAspectFit];
	[imgView setFrame:CGRectMake(0, 0, 50, 17.5)];
	self.navigationItem.titleView = imgView;	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

	[self buildOverlay];

	videoView.frame = CGRectMake(0, 60, videoView.frame.size.width, videoView.frame.size.height);
	
    scrollView.contentSize = CGSizeMake(videoView.frame.size.width, 3700.0);

	[[OpenNC getInstance] getFeed:self callback:@selector(showResults:) parameters:nil];
}

- (void)buildOverlay
{
	overlayView.frame = CGRectMake(0, 0, 320, 480);	
	//[self.view addSubview:overlayView];
	
	UIImage* overlayBGImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TED-logo" ofType:@"png"]];	
	overlayBGImageView = [[UIImageView alloc] initWithImage:overlayBGImage];
	overlayBGImageView.frame = CGRectMake(0, 0, 320, 480);
	overlayBGImageView.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5 + 10);
	[overlayBGImage release];
	[overlayView addSubview:overlayBGImageView];
    
	TEDAppDelegate *appdelegate = (TEDAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appdelegate addOverlay:overlayView];
}

- (void)removeOverlay
{
    TEDAppDelegate *appdelegate = (TEDAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appdelegate removeOverlay];
        
	[UIView beginAnimations:@"removeOverlay" context:nil];
	[UIView setAnimationDelay:0.1];
	[UIView setAnimationDuration:0.75];
	//[UIView setAnimationDelegate:self];
	//[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
	videoView.alpha = 1.0;
	
	[UIView commitAnimations];
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
}

- (void)showResults:(NSArray *)data
{
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(removeOverlay) userInfo:nil repeats:NO];
    
//	NSLog(@"connection ended");
//	NSLog(@"%@", data);

    dataArray = [[NSMutableArray alloc] init];
    
	for (int i = 1; i < 61; i++) {
        NSMutableDictionary *contextDict = [[NSMutableDictionary alloc] init];
        
		NSDictionary *dataDic = [data objectAtIndex:i];
		NSString *imgURL = [dataDic objectForKey:@"thumbnailURL"];        
        [contextDict setObject:imgURL forKey:@"thumbnailURL"];

		NSString *overlayImgURL = [dataDic objectForKey:@"overlayURL"];        
        [contextDict setObject:overlayImgURL forKey:@"overlayURL"];

		NSString *author = [dataDic objectForKey:@"author"];        
        [contextDict setObject:author forKey:@"author"];
                
        NSString *subtitle = [dataDic objectForKey:@"subtitle"];
        [contextDict setObject:subtitle forKey:@"subtitle"];
        
        NSString *urlMovie = [dataDic objectForKey:@"videoURL"];
        [contextDict setObject:urlMovie forKey:@"videoURL"];
        
        NSString *description = [dataDic objectForKey:@"description"];
        [contextDict setObject:description forKey:@"description"];
        
        NSString *duration = [dataDic objectForKey:@"duration"];
        [contextDict setObject:duration forKey:@"duration"];
        
		[[OpenNC getInstance] getImage:self callback:@selector(displayImage:) imageURL:imgURL context:contextDict];
        
        [contextDict release];
	}
	
	[self createTalkView:data];
}

- (void)createTalkView:(NSArray *)data
{
	NSDictionary *dataDic1 = [data objectAtIndex:0];
	NSString *imgURL1 = [dataDic1 objectForKey:@"overlayURL"];
	NSString *titleText = [dataDic1 objectForKey:@"subtitle"];
    mainMovie = (NSString *)[dataDic1 objectForKey:@"videoURL"];
	[[OpenNC getInstance] getImage:self callback:@selector(displayMainImage:) imageURL:imgURL1 context:nil];
	
	UILabel *heading = [[UILabel alloc] initWithFrame:CGRectMake(15, 175, 290, 50)];
	heading.textAlignment = UITextAlignmentLeft;
	heading.textColor = [UIColor whiteColor];
	heading.font = [UIFont boldSystemFontOfSize:14.0];
	heading.backgroundColor = [UIColor clearColor];
	heading.text = titleText;
	heading.numberOfLines = 0;
	[scrollView addSubview:heading];
	
	[self.view addSubview:videoView];
	videoView.alpha = 0.0;
    
    initialMovieDictionary = [[NSMutableDictionary alloc] init];
    
    NSString *imgURL = [dataDic1 objectForKey:@"thumbnailURL"];        
    [initialMovieDictionary setObject:imgURL forKey:@"thumbnailURL"];

    NSString *overlayImgURL = [dataDic1 objectForKey:@"overlayURL"];        
    [initialMovieDictionary setObject:overlayImgURL forKey:@"overlayURL"];

    NSString *author = [dataDic1 objectForKey:@"author"];        
    [initialMovieDictionary setObject:author forKey:@"author"];

    NSString *subtitle = [dataDic1 objectForKey:@"subtitle"];
    [initialMovieDictionary setObject:subtitle forKey:@"subtitle"];
    
    NSString *urlMovie = [dataDic1 objectForKey:@"videoURL"];
    [initialMovieDictionary setObject:urlMovie forKey:@"videoURL"];
    
    NSString *description = [dataDic1 objectForKey:@"description"];
    [initialMovieDictionary setObject:description forKey:@"description"];
    
    NSString *duration = [dataDic1 objectForKey:@"duration"];
    [initialMovieDictionary setObject:duration forKey:@"duration"];
}

- (void)displayImage:(NSDictionary *)image {
	[image retain];
    
	float overlayPointX = 10.0;
	float overlayPointYMultiplier = counter;
	
	if ((counter % 2) == 0) {
		overlayPointX = 162.0;
		overlayPointYMultiplier = counter - 1;
	}
    
    if (counter >= 3) {
        overlayPointYMultiplier = ((float)counter / 2) + 0.5;
        
        if ((counter % 2) == 0) {
            overlayPointYMultiplier = ((float)counter / 2);
        }
    }
	    
	UIImage *fullImage = [image objectForKey:@"image"];
    
    UIButton *videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	videoButton.frame = CGRectMake(overlayPointX, 131 + (115.0 * overlayPointYMultiplier), 148.0, 111.0);
	[videoButton setBackgroundImage:fullImage forState:UIControlStateNormal];
    videoButton.tag = counter;
	[videoButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:videoButton];
    
    UIImage *miniHeadingImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"miniHeading-bg" ofType:@"png"]];
	UIImageView *miniHeadingImageView = [[UIImageView alloc] initWithImage:miniHeadingImage];
	miniHeadingImageView.frame = CGRectMake(overlayPointX, 211 + (115.0 * overlayPointYMultiplier), 148.0, 30.0);

	[scrollView addSubview:miniHeadingImageView];
    
    [miniHeadingImage release];
    [miniHeadingImageView release];
    
	UILabel *miniHeading = [[UILabel alloc] initWithFrame:CGRectMake(overlayPointX + 3, 211 + (115.0 * overlayPointYMultiplier), 142.0, 30.0)];
	miniHeading.textAlignment = UITextAlignmentLeft;
	miniHeading.textColor = [UIColor whiteColor];
	miniHeading.font = [UIFont boldSystemFontOfSize:10.0];
	miniHeading.backgroundColor = [UIColor clearColor];
	miniHeading.text = (NSString *)[[image objectForKey:@"context"] objectForKey:@"subtitle"];
	miniHeading.numberOfLines = 0;
    [scrollView addSubview:miniHeading];
    
    
    [dataArray addObject:[image objectForKey:@"context"]];
	
	counter ++;
    
	[image release];
}

- (void)displayMainImage:(NSDictionary *)image {
	[image retain];

	UIImage *fullImage = [image objectForKey:@"image"];
	
	[featuredTalk setBackgroundImage:fullImage forState:UIControlStateNormal];
	
	[image release];
}

- (IBAction)featuredTalk:(id)sender
{
//	TEDAppDelegate *appdelegate = (TEDAppDelegate *)[[UIApplication sharedApplication] delegate];
//	[appdelegate prepMoviePlayer:mainMovie loadingView:loadingView];
    
    //NSLog(@"data from tap: %@", initialMovieDictionary);
        
    SelectedViewController *selectedView = [[SelectedViewController alloc] initWithNibName:@"SelectedViewController" bundle:[NSBundle mainBundle]];
    
    selectedView.selectedData = initialMovieDictionary;
	[self.navigationController pushViewController:selectedView animated:YES];
	[selectedView release];    
}

- (void)playVideo:(id)sender
{
	UIButton *button = (id)sender;
        
    NSDictionary *contextDictionary = [dataArray objectAtIndex:(button.tag - 1)];
    //NSLog(@"data from tap: %@", contextDictionary);
    //NSString *urlMovie = (NSString *)[contextDictionary objectForKey:@"videoURL"];

    
    SelectedViewController *selectedView = [[SelectedViewController alloc] initWithNibName:@"SelectedViewController" bundle:[NSBundle mainBundle]];
    selectedView.selectedData = contextDictionary;
	[self.navigationController pushViewController:selectedView animated:YES];
	[selectedView release];    
    
//	TEDAppDelegate *appdelegate = (TEDAppDelegate *)[[UIApplication sharedApplication] delegate];
//	[appdelegate prepMoviePlayer:urlMovie loadingView:loadingView];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/


 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
    
    [overlayView release]; 
    [videoView release];
    [overlayBGImageView release]; 
    [loadingView release];
    [featuredTalk release];
    [mainMovie release]; 
    [scrollView release];
    [dataArray release];

}


@end

