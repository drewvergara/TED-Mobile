//
//  TEDAppDelegate.h
//  TED
//
//  Created by Andrew Vergara on 3/4/11.
//  Copyright 2011 Studio Noodlehouse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "RootViewController.h"

@class MPMoviePlayerController;

@interface TEDAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
 
    UIView *introOverlay;
    
    RootViewController *rootViewControllerHolder;
    
    MPMoviePlayerController *moviePlayer;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) UIView *introOverlay;
@property (nonatomic, retain) RootViewController *rootViewControllerHolder;

- (void)saveRootViewControllerHolder:(RootViewController *)controller;
- (void)addOverlay:(UIView *)overlay;
- (void)removeOverlay;

@end

