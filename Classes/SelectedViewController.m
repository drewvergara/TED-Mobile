//
//  SelectedViewController.m
//  TED
//
//  Created by Andrew Vergara on 4/27/11.
//  Copyright 2011 Studio Noodlehouse. All rights reserved.
//

#import "SelectedViewController.h"
#import "OpenNC.h"

@implementation SelectedViewController

@synthesize selectedData;
@synthesize selectedTalkBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super viewDidLoad];
    
	self.navigationController.navigationBar.hidden = NO;
    
	UIImageView *imgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TED-logo-sm.png"]] autorelease];
	[imgView setContentMode:UIViewContentModeScaleAspectFit];
	[imgView setFrame:CGRectMake(0, 0, 50, 17.5)];
	self.navigationItem.titleView = imgView;	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
   //self.navigationItem.leftBarButtonItem = self.
    
        
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"selected data: %@", selectedData);
    
    [[OpenNC getInstance] getImage:self callback:@selector(displayMainImage:) imageURL:[selectedData objectForKey:@"overlayURL"] context:nil];
}

- (void)displayMainImage:(NSDictionary *)image {
	[image retain];
    
	UIImage *fullImage = [image objectForKey:@"image"];
	
	[selectedTalkBtn setBackgroundImage:fullImage forState:UIControlStateNormal];
	
	[image release];
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

@end
