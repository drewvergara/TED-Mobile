//
//  OpenNC.m
//  TED Mobile
//
//  Created by Andrew Vergara on 8/24/10.
//  Copyright 2010 72andSunny. All rights reserved.
//

#import "OpenNC.h"
#import "ImageRequestor.h"
#import "FeedRequestor.h"

static OpenNC *sharedInstance = nil;

@implementation OpenNC

@synthesize imageCache, masterSettings;
@synthesize ready;

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


+ (OpenNC *)getInstance {
	
	@synchronized(self)
	{
		if (sharedInstance == nil){
			//Initialize self
			sharedInstance = [[self alloc] init];
		}
	}
	return(sharedInstance);
}

//This is intended to be a private method (not called directly).  Use getInstance to maintain it's singleton behavior.
- (id) init {
	
	if (self = [super init])
	{
		
		//Use default value if missing from AppSettings file
		if (baseURL == nil)
			[baseURL setString:@"http://ec2-184-73-5-132.compute-1.amazonaws.com/v1/mobile/"];
		
		
		//Setupoperation queues
		queue = [[NSOperationQueue alloc] init];
		//Cache of images already retrieved from network or disk...no need to do it twice
		NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
		self.imageCache = dic;
		
		//Register to receive memory warnings, so the image cache can be flushed to free memory
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMemoryWarning:) name: UIApplicationDidReceiveMemoryWarningNotification object:nil];		
	}
	
    return self;
}

- (void) handleMemoryWarning:(NSNotification *)notification {
	NSLog(@"%@", @"MEMORY WARNING handled in OpenNC!");
	
	[self.imageCache removeAllObjects];

}


#pragma mark - Model Data Provider Methods
- (NSString *) getBaseUrl {
	return baseURL;
}

- (void)getImage:(NSObject *)caller callback:(SEL)callback imageURL:(NSString *)url context:(NSObject *)context {
	if ([imageCache objectForKey:url]){
		//Already in memory, return this reference
		UIImage *image = [imageCache objectForKey:url];
		//Package for sending back
		NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
		if (image != nil)
			[result setObject:image forKey:@"image"];
		if (context != nil)
			[result setObject:context forKey:@"context"];
		//Send data back to the caller
		[caller performSelector:callback withObject:result];
	}else{
		//Get asynchronously from disk or network
		ImageRequestor *imgRequest = [[ImageRequestor alloc] startWithURL:url caller:caller callback:callback context:context];
		[queue addOperation:imgRequest];
	}
}

//    OpenNC creates and allocates new objects and lets them go off and do work:
//    This is essentially a callback that the object calls when it is finished with it's work 
//    to let OpenNC know it can be 'released'.

- (void) releaseMe:(NSObject *)retainedObject {
}

#pragma mark - TED Feed Data
//Feed Data
- (void)getFeed:(NSObject *)caller callback:(SEL)callback parameters:(NSDictionary *)parameters {
	FeedRequestor *feedRequestor = [[FeedRequestor alloc] initForFeed:caller callback:callback];
	[queue addOperation:feedRequestor];
}

@end
