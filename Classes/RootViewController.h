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
	
	UIImageView *overlayBGImageView;

	IBOutlet UIButton *featuredTalk;
	IBOutlet UIButton *talk1;
	IBOutlet UIButton *talk2;
	
}
@property (nonatomic, retain) IBOutlet UIView *overlayView; 
@property (nonatomic, retain) IBOutlet UIView *videoView;
@property (nonatomic, retain) UIImageView *overlayBGImageView;
@property (nonatomic, retain) IBOutlet UIButton *featuredTalk;
@property (nonatomic, retain) IBOutlet UIButton *talk1;
@property (nonatomic, retain) IBOutlet UIButton *talk2;

- (void)createTalkView:(NSArray *)data;
@end
