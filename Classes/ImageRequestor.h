//
//  ImageRequestor.h
//  TED Mobile
//
//  Created by Andrew Vergara on 8/24/10.
//  Copyright 2010 72andSunny. All rights reserved.
//

/*
 
 The image requestor handles retrieval and caching of images hosted on the server.
 
 GENERAL LOGIC:
 1.  Initialize ImageRequestor with a URL to an image and a callback for delivery of the image
 2.  First, the local image cache will be searched for the image name.
 3.  If the image is cached locally, return the local image
 4.  If not, retrieve the image from the server, cache locally, and return image to the requestor
 
 */

#import <UIKit/UIKit.h>


@interface ImageRequestor : NSOperation {
	NSObject *requestor;
	NSObject *ctxObject;
	SEL requestorCallback;
	NSString *filename;
	NSString *url;
}

@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSString *url;

- (id) startWithURL:(NSString *)url caller:(NSObject *)caller callback:(SEL)callback context:(NSObject *)ctx;
- (BOOL)existsInCache:(NSString *)imageName;
- (void)retrieveImageFromCache:(NSString *)fileName;
- (BOOL)saveToCacheFolder:(NSData *)data withName:(NSString *)filename;
- (void)retrieveImageFromNetwork:(NSString *)url;
@end
