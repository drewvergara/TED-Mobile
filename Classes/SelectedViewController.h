//
//  SelectedViewController.h
//  TED
//
//  Created by Andrew Vergara on 4/27/11.
//  Copyright 2011 Studio Noodlehouse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "Reachability.h"

@class MPMoviePlayerViewController, MPMoviePlayerController;

@interface SelectedViewController : UIViewController {
 	IBOutlet UIView *loadingView;
    
    NSDictionary *selectedData;

    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIButton *talkBtn;
    IBOutlet UIButton *playBtn;
    IBOutlet UIImageView *selectedTalkBtn;
    IBOutlet UIImageView *selectedTalkBg;
    IBOutlet UITextView *selectedTalkDescription;

    UIView *loadVideoOverlay;    
    
    MPMoviePlayerController *moviePlayer;
    MPMoviePlayerViewController *moviePlayerController;
}
@property (nonatomic, strong) IBOutlet UIView *loadingView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UIButton *talkBtn;
@property (nonatomic, strong) IBOutlet UIButton *playBtn;
@property (nonatomic, strong) NSDictionary *selectedData;
@property (nonatomic, strong) IBOutlet UIImageView *selectedTalkBtn;
@property (nonatomic, strong) IBOutlet UIImageView *selectedTalkBg;
@property (nonatomic, strong) IBOutlet UITextView *selectedTalkDescription;
@property (nonatomic, strong) UIView *loadVideoOverlay;

- (IBAction)playSelectedTalk:(id)sender;
- (void)prepMoviePlayer:(NSString *)movieName loadingView:(UIView *)loadingOverlay;

@end