//
//  TEDAppDelegate.h
//  TED
//
//  Created by Andrew Vergara on 3/4/11.
//  Copyright 2011 Studio Noodlehouse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class MPMoviePlayerController;

@interface TEDAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
 
    UIView *introOverlay;
    UIView *loadVideoOverlay;
    
    MPMoviePlayerController *moviePlayer;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) UIView *introOverlay;
@property (nonatomic, retain) UIView *loadVideoOverlay;

- (void)addOverlay:(UIView *)overlay;
- (void)removeOverlay;
- (void)prepMoviePlayer:(NSString *)movieName loadingView:(UIView *)loadingOverlay;

@end

