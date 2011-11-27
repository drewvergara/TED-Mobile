//
//  SelectedViewController.h
//  TED
//
//  Created by Andrew Vergara on 4/27/11.
//  Copyright 2011 Studio Noodlehouse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface SelectedViewController : UIViewController {
 	IBOutlet UIView *loadingView;
    
    NSDictionary *selectedData;

    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIButton *talkBtn;
    IBOutlet UIButton *playBtn;
    IBOutlet UIImageView *selectedTalkBtn;
    IBOutlet UIImageView *selectedTalkBg;
    IBOutlet UITextView *selectedTalkDescription;
}
@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIButton *talkBtn;
@property (nonatomic, retain) IBOutlet UIButton *playBtn;
@property (nonatomic, retain) NSDictionary *selectedData;
@property (nonatomic, retain) IBOutlet UIImageView *selectedTalkBtn;
@property (nonatomic, retain) IBOutlet UIImageView *selectedTalkBg;
@property (nonatomic, retain) IBOutlet UITextView *selectedTalkDescription;

- (IBAction)playSelectedTalk:(id)sender;

@end