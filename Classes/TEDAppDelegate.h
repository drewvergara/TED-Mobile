//
//  TEDAppDelegate.h
//  TED
//
//  Created by Andrew Vergara on 3/4/11.
//  Copyright 2011 Studio Noodlehouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TEDAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

