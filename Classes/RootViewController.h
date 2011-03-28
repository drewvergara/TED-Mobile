//
//  RootViewController.h
//  TED
//
//  Created by Andrew Vergara on 3/4/11.
//  Copyright 2011 Studio Noodlehouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController {
	IBOutlet UIView *overlayView;
	IBOutlet UIView *videoView;
	IBOutlet UIView *loadingView;
    
	UIImageView *overlayBGImageView;

	IBOutlet UIButton *featuredTalk;
    
    IBOutlet UIScrollView *scrollView;
    
    NSMutableArray *dataArray;
    
    NSString *mainMovie;	
}
@property (nonatomic, retain) IBOutlet UIView *overlayView; 
@property (nonatomic, retain) IBOutlet UIView *videoView;
@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) UIImageView *overlayBGImageView;
@property (nonatomic, retain) IBOutlet UIButton *featuredTalk;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSString *mainMovie;

- (void)buildOverlay;
- (void)createTalkView:(NSArray *)data;
- (IBAction)featuredTalk:(id)sender;
@end
