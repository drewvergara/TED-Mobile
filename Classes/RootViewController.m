//
//  RootViewController.m
//  TED
//
//  Created by Andrew Vergara on 3/4/11.
//  Copyright 2011 Studio Noodlehouse. All rights reserved.
//

#import "RootViewController.h"
#import "OpenNC.h"


@implementation RootViewController

@synthesize overlayView, videoView, overlayBGImageView;
@synthesize featuredTalk, talk1, talk2;

int counter = 0;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
	self.navigationController.navigationBar.hidden = YES;
	
	UIImageView *imgView;
	imgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TED-logo-sm.png"]] autorelease];
	[imgView setContentMode:UIViewContentModeScaleAspectFit];
	[imgView setFrame:CGRectMake(0, 0, 50, 17.5)];
	self.navigationItem.titleView = imgView;	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

	overlayView.frame = CGRectMake(0, 0, 320, 480);	
	[self.view addSubview:overlayView];
	
	UIImage* overlayBGImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TED-logo" ofType:@"png"]];	
	overlayBGImageView = [[UIImageView alloc] initWithImage:overlayBGImage];
	overlayBGImageView.frame = CGRectMake(0, 0, 320, 480);
	overlayBGImageView.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5 + 10);
	[overlayBGImage release];
	[self.overlayView addSubview:overlayBGImageView];
	
	//videoView = [[UIView alloc] init];
	videoView.frame = CGRectMake(0, 120, videoView.frame.size.width, videoView.frame.size.height);
	
	[[OpenNC getInstance] getFeed:self callback:@selector(showResults:) parameters:nil];
}

- (void)removeOverlay
{
	[UIView beginAnimations:@"removeOverlay" context:nil];
	[UIView setAnimationDelay:0.1];
	[UIView setAnimationDuration:0.75];
	//[UIView setAnimationDelegate:self];
	//[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
	overlayView.alpha = 0.0;	
	videoView.alpha = 1.0;
	
	[UIView commitAnimations];
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];

	self.navigationController.navigationBar.hidden = NO;	
}

- (void)showResults:(NSArray *)data
{
	NSLog(@"connection ended");
	NSLog(@"%@", data);
			
	for (int i = 0; i < 9; i++) {
		NSDictionary *dataDic = [data objectAtIndex:i];
		NSString *imgURL = [dataDic objectForKey:@"thumbnailURL"];

		[[OpenNC getInstance] getImage:self callback:@selector(displayImage:) imageURL:imgURL context:nil];		
	}
	
	[self createTalkView:data];
}

- (void)createTalkView:(NSArray *)data
{
	NSDictionary *dataDic1 = [data objectAtIndex:0];
	NSString *imgURL1 = [dataDic1 objectForKey:@"overlayURL"];
	NSString *titleText = [dataDic1 objectForKey:@"subtitle"];	
	[[OpenNC getInstance] getImage:self callback:@selector(displayMainImage:) imageURL:imgURL1 context:nil];
	
	UILabel *heading = [[UILabel alloc] initWithFrame:CGRectMake(15, 185, 290, 50)];
	heading.textAlignment = UITextAlignmentLeft;
	heading.textColor = [UIColor whiteColor];
	heading.font = [UIFont boldSystemFontOfSize:14.0];
	heading.backgroundColor = [UIColor clearColor];
	heading.text = titleText;
	heading.numberOfLines = 0;
	[videoView addSubview:heading];
	//heading.center = CGPointMake(dialogView.frame.size.width/2, 27.0f);
	
	[self.view addSubview:videoView];
	videoView.alpha = 0.0;
}

- (void)displayImage:(NSDictionary *)image {
	[image retain];
	
	float overlayPointX = 0.0;
	int overlayPointYMultiplier = counter;
	
	if (counter > 4) {
		overlayPointX = 160.0;
		overlayPointYMultiplier = counter - 5;
	}
	
	UIImage *fullImage = [image objectForKey:@"image"];

	UIImageView *bgImageView = [[UIImageView alloc] initWithImage:fullImage];
	bgImageView.frame = CGRectMake(overlayPointX, 120 * overlayPointYMultiplier, 160, 120);
	[self.overlayView insertSubview:bgImageView atIndex:0];
	
	if (counter == 7) {
		[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(removeOverlay) userInfo:nil repeats:NO];
	}
	
	counter ++;
	
	[image release];
}

- (void)displayMainImage:(NSDictionary *)image {
	[image retain];

	UIImage *fullImage = [image objectForKey:@"image"];
	
	//UIImageView *bgImageView = [[UIImageView alloc] initWithImage:fullImage];
	[featuredTalk setBackgroundImage:fullImage forState:UIControlStateNormal];
	[talk1 setBackgroundImage:fullImage forState:UIControlStateNormal];
	[talk2 setBackgroundImage:fullImage forState:UIControlStateNormal];
	//bgImageView.frame = CGRectMake(10, 10, 300, 225);
	//[videoView insertSubview:bgImageView atIndex:1];
	
	[image release];
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

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

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
}


@end

