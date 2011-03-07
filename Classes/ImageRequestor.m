//
//  ImageRequestor.m
//  TED Mobile
//
//  Created by Andrew Vergara on 8/24/10.
//  Copyright 2010 72andSunny. All rights reserved.
//

#import "ImageRequestor.h"
#import "OpenNC.h";

@implementation ImageRequestor

@synthesize filename, url;

- (void)dealloc {
	[url release];
	[filename release];
    [super dealloc];
}

- (id) startWithURL:(NSString *)imageurl caller:(NSObject *)caller callback:(SEL)callback context:(NSObject *)ctx {
    if (self = [super init]) {
        // Initialization code
		
		self.url = imageurl;
		
		requestor = caller;
		if (requestor)
			[requestor retain];  //Retain the requestor in case it gets popped off while image is being retrieved (or go 'boom').
		
		requestorCallback = callback;
		
		if (ctx){
			ctxObject = ctx;
		}
		[ctxObject retain];
		
		
	}
	return self;
}

- (void) main {
	@try {
		//Get image name from URL
		NSURL *validate = [NSURL URLWithString:url];
		
		if (validate){
			NSArray *myArray = [url componentsSeparatedByString: @"/"];
			self.filename = (NSString*)[myArray lastObject];
			
			if ([self existsInCache:self.filename]){
				[self retrieveImageFromCache:self.filename];
			}else{
				[self retrieveImageFromNetwork:url];
			}
		}
		
	}
	@catch (NSException * e) {
		NSString *strError = [NSString stringWithFormat:@"OpenNC ImageRequestor: Caught %@: %@", [e name], [e reason]];
		//NSLog(@"%@", strError);
		//Send data back to the caller
		if (requestor){
			[requestor performSelectorOnMainThread:requestorCallback withObject:[NSDictionary dictionaryWithObject:strError forKey:@"error"] waitUntilDone:NO];
			[requestor release];
		}
		
	}
	
}

- (BOOL)existsInCache:(NSString *)imageName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cacheDirectory = [paths objectAtIndex:0];
	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:[cacheDirectory stringByAppendingPathComponent:imageName]];
	return exists;
}

- (void)retrieveImageFromCache:(NSString *)fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cacheDirectory = [paths objectAtIndex:0];
	
	if (!cacheDirectory) {
		//NSLog(@"Cache directory not found!");
		return;
	}
	NSString *newFile = [cacheDirectory stringByAppendingPathComponent:filename];
	
	//Create UIimage from file name
	UIImage *image = [UIImage imageWithContentsOfFile:newFile];
	//Add it to OpenNC's image cache (so it does not have to be retrieved again this session)
	[[OpenNC getInstance].imageCache setObject:image forKey:self.url];
	
	//Package for sending back
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	if (image != nil)
		[result setObject:image forKey:@"image"];
	if (ctxObject != nil)
		[result setObject:ctxObject forKey:@"context"];
	
	//Send data back to the caller
	[requestor performSelectorOnMainThread:requestorCallback withObject:result waitUntilDone:NO];
	[requestor release];
	[result release];
	
	
	
	
	
}

- (BOOL)saveToCacheFolder:(NSData *)data withName:(NSString *)imagename {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cacheDirectory = [paths objectAtIndex:0];
	
	if (!cacheDirectory) {
		//NSLog(@"Cache directory not found!");
		return NO;
	}
	
	NSString *newFile = [cacheDirectory stringByAppendingPathComponent:self.filename];
	return ([data writeToFile:newFile atomically:YES]);
}


- (void)retrieveImageFromNetwork:(NSString *)imageurl {
	
	
	NSURL *sourceURL = [NSURL URLWithString:imageurl];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	//This is a synchronous network call but is performed asynch to the main thread because ImageRequestor is a subclass of NSOperation
	NSData *imageData = [NSData dataWithContentsOfURL:sourceURL];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	
	if(imageData != nil) {
		UIImage *image = [[UIImage alloc] initWithData:imageData];
		// Set error if no image was created
		if( !image ) {
			[result setObject:@"Unrecognized image format. Cannot create image from data." forKey:@"error"];
		}else{
			[self saveToCacheFolder:imageData withName:self.filename];
			//Add it to OpenNC's image cache (so it does not have to be retrieved again this session)
			[[OpenNC getInstance].imageCache setObject:image forKey:self.url];
			[result setObject:image forKey:@"image"];
		}
		
	}else{
		[result setObject:@"Error retrieving image or image does not exist." forKey:@"error"];
	}
	
	//Attached the context object to send back to caller
	if (ctxObject)
		[result setObject:ctxObject forKey:@"context"];
	
	//Send data back to the caller
	if (requestor){
		//[requestor performSelector:requestorCallback withObject:result];
		[requestor performSelectorOnMainThread:requestorCallback withObject:result waitUntilDone:NO];
		[requestor release];
	}
	
	[ctxObject release];
	[result release];
	
	
}



@end
