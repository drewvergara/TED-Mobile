//
//  OpenNC.h
//  TED Mobile
//
//  Created by Andrew Vergara on 8/24/10.
//  Copyright 2010 Studio Noodlehouse. All rights reserved.
//

@protocol OpenNCListener
@required
- (void)openNCReady:(BOOL)ready;

@end
typedef id <OpenNCListener> OpenNCListenerRef;

@interface OpenNC : NSObject {
	NSOperationQueue *queue;
	NSMutableDictionary *imageCache;  //holds any images already retrieved via instance of ImageRequestor, no need to get the same image twice
	NSMutableString *baseURL;
	NSDictionary *masterSettings;
			
	NSMutableData *responseData;
	BOOL ready;
	OpenNCListenerRef owner;
	NSObject *callerToCall;
	SEL callbackToCall;
	
}
@property (nonatomic, strong) NSDictionary *masterSettings;
@property (nonatomic, strong) NSMutableDictionary *imageCache;
@property (readonly) BOOL ready;


+ (OpenNC *)getInstance;
- (void) releaseMe:(NSObject *)retainedObject;

//- (void) handleMemoryWarning:(NSNotification *)notification;

//*********************************************************

//General helper to retrieve a single image from the network/cache
- (void)getImage:(NSObject *)caller callback:(SEL)callback imageURL:(NSString *)url context:(NSObject *)context;
//Get YouTube Videos
- (void)getFeed:(NSObject *)caller callback:(SEL)callback parameters:(NSDictionary *)parameters;



//*********************************************************
@end
