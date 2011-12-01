//
//  RootViewController.h
//  TED
//
//  Created by Andrew Vergara on 3/4/11.
//  Copyright 2011 Studio Noodlehouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UIScrollViewDelegate>{
	IBOutlet UIView *overlayView;
	IBOutlet UIView *videoView;
	IBOutlet UIView *loadingView;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
	UIImageView *overlayBGImageView;

    IBOutlet UIImageView *featuredTalkBg;
    
	IBOutlet UIButton *featuredTalk;
    UILabel *heading;
    
    IBOutlet UIScrollView *scrollView;
    
    NSMutableArray *dataArray;
    NSMutableDictionary *initialMovieDictionary;
    
    NSString *mainMovie;	
}
@property (nonatomic, strong) IBOutlet UIView *overlayView; 
@property (nonatomic, strong) IBOutlet UIView *videoView;
@property (nonatomic, strong) IBOutlet UIView *loadingView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIImageView *overlayBGImageView;
@property (nonatomic, strong) IBOutlet UIImageView *featuredTalkBg;
@property (nonatomic, strong) IBOutlet UIButton *featuredTalk;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *initialMovieDictionary;
@property (nonatomic, strong) NSString *mainMovie;

- (void)recreateInterface;
- (void)createInterface;
- (void)buildOverlay;
- (void)createTalkView:(NSArray *)data;
- (IBAction)featuredTalk:(id)sender;
- (void)resetViewController;

@end
