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
    
	UIImageView *imgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TED-logo-sm.png"]] autorelease];
	[imgView setContentMode:UIViewContentModeScaleAspectFit];
	[imgView setFrame:CGRectMake(0, 0, 50, 17.5)];
	self.navigationItem.titleView = imgView;	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
   //self.navigationItem.leftBarButtonItem = self.
    
    NSLog(@"selected data: %@", selectedData);

    selectedTalkBg.hidden = YES;
    selectedTalkDescription.text = [selectedData objectForKey:@"description"];
    
    [[OpenNC getInstance] getImage:self callback:@selector(displayMainImage:) imageURL:[selectedData objectForKey:@"overlayURL"] context:nil];
}

- (void)displayMainImage:(NSDictionary *)image {	
    [image retain];
    
    selectedTalkBg.hidden = NO;
    
	UIImage *fullImage = [image objectForKey:@"image"];
	
	[selectedTalkBtn setBackgroundImage:fullImage forState:UIControlStateNormal];
	
	[image release];

    //Click to Play
	UILabel *clickToPlay = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
	clickToPlay.textAlignment = UITextAlignmentCenter;
	clickToPlay.textColor = [UIColor whiteColor];
	clickToPlay.font = [UIFont boldSystemFontOfSize:14.0];
	clickToPlay.backgroundColor = [UIColor clearColor];
    clickToPlay.shadowColor = [UIColor blackColor];
	clickToPlay.text = @"(tap to play)";
	clickToPlay.numberOfLines = 0;
	[self.view addSubview:clickToPlay];    
        
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


- (IBAction)playSelectedTalk:(id)sender
{
	TEDAppDelegate *appdelegate = (TEDAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appdelegate prepMoviePlayer:[selectedData objectForKey:@"videoURL"] loadingView:loadingView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (void)dealloc
{
    [super dealloc];
    [activityIndicator release];
    [selectedTalkBtn release];
    [selectedTalkBg release]; 
    [selectedTalkDescription release];
}

@end