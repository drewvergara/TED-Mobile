//
//  VideoListViewController.h
//  TED
//
//  Created by Andrew Vergara on 11/28/11.
//  Copyright (c) 2011 Studio Noodlehouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoListViewDelegate <NSObject>

- (IBAction)featuredTalk:(id)sender;

@end


@interface VideoListViewController : UIViewController
{
    id <VideoListViewDelegate> delegate;
    
	IBOutlet UIButton *featuredTalk;
}

@property (nonatomic, strong) id <VideoListViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIButton *featuredTalk;

@end
