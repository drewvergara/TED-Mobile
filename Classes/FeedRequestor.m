//
//  FeedRequestor.m
//  TED Mobile
//
//  Created by Andrew Vergara on 8/24/10.
//  Copyright 2010 Studio Noodlehouse. All rights reserved.
//

#import "FeedRequestor.h"
#import "OpenNC.h"

@implementation FeedRequestor

@synthesize item, itemContents, currentStringValue, itemElementInProgress; ;


- (id)initForFeed:(NSObject *)caller callback:(SEL)callback{
	if (self == [super init])
	{
		// Initialization code
		requestor = caller;
		  //Retain the requestor in case it gets popped off while being retrieved (or go 'boom').
		requestorCallback = callback;
		
	}
	
    return self;
}

- (void)cancel {
	if (requestor != nil) {
		requestor = nil;
	} 

	//NSLog(@"%@", @"Requestor cancelled.");
}

- (void) main {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSString *strURL = [NSString stringWithFormat:@"http://feeds.feedburner.com/tedtalks_video"];
	NSURL *sourceURL = [NSURL URLWithString:strURL];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init]; 
	[request setURL:sourceURL]; 
	[request setHTTPMethod:@"GET"]; 
	
	//This is a synchronous network call but is performed asynch to the main thread because this is a subclass of NSOperation
	NSHTTPURLResponse *response = nil;
	NSError *error = nil;
	NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	NSMutableDictionary *dicResponse = [[NSMutableDictionary alloc] init];
	if (error){
		[dicResponse setObject:[NSString stringWithFormat:@"Error requesting saved rewards: %@", [error localizedDescription]] forKey:@"error"];
	}else{
		
		BOOL success;
		//NSURL *xmlURL = [NSURL fileURLWithPath:pathToFile];
		addressParser = [[NSXMLParser alloc] initWithData:receivedData];
		[addressParser setDelegate:self];
		[addressParser setShouldResolveExternalEntities:YES];
		success = [addressParser parse]; // return value not used
		//NSLog(@"%@", item);
		// if not successful, delegate is informed of error
		
		
		
//		NSString *results = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
//		NSLog(@"YouTubeRequestor Response: Status code %d - Data: %@", [response statusCode], results);
		
		//Parse response into dictionary
//		SBJSON *json = [SBJSON new];
//		NSDictionary *dicJSON = [json objectWithString:results error:&error];
//		if (nil == dicJSON){
//			//NSLog(@"JSON parsing failed: %@",[error localizedDescription]);
//			[dicResponse setObject:[NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]] forKey:@"error"];
//		}else{
//			[dicResponse setObject:dicJSON forKey:@"ytDictionary"];
//		}
//		[json release];
		
	}
	
	//Send data back to the caller
	if (requestor != nil){
		[requestor performSelectorOnMainThread:requestorCallback withObject:item waitUntilDone:YES];
	}
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict 
{	
	if (self.itemElementInProgress) {
		if ([elementName isEqualToString:@"media:content"]) {
			NSString *thisOwner = [attributeDict objectForKey:@"url"];
			[itemContents setObject:thisOwner forKey:@"videoURL"];
		}

		if ([elementName isEqualToString:@"media:thumbnail"]) {
			NSString *thisOwner = [attributeDict objectForKey:@"url"];
			[itemContents setObject:thisOwner forKey:@"thumbnailURL"];
		}

		if ([elementName isEqualToString:@"itunes:image"]) {
			NSString *thisOwner = [attributeDict objectForKey:@"url"];
			[itemContents setObject:thisOwner forKey:@"overlayURL"];
		}
		
		
	}
    
	if ( [elementName isEqualToString:@"item"]) {
        // addresses is an NSMutableArray instance variable
		[self setItemElementInProgress:YES];
		if (!itemContents) {
			itemContents = [[NSMutableDictionary alloc] init];
		}
		
		if (!item)
			item = [[NSMutableArray alloc] init];
        return;
    }
}	

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentStringValue) {
        currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
    }	
    [currentStringValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
    if ( [elementName isEqualToString:@"item"] ) {
		[self setItemElementInProgress:NO];
		[item addObject:itemContents];
		itemContents = nil;
	}
	
	if (self.itemElementInProgress) {

		if ([elementName isEqualToString:@"itunes:author"]) {
			currentStringValue = (NSMutableString *)[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			[itemContents setObject:currentStringValue forKey:@"author"];
		}
		
		if ([elementName isEqualToString:@"itunes:summary"]) {
			currentStringValue = (NSMutableString *)[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			[itemContents setObject:currentStringValue forKey:@"description"];
		}

		if ([elementName isEqualToString:@"itunes:subtitle"]) {
			currentStringValue = (NSMutableString *)[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			[itemContents setObject:currentStringValue forKey:@"subtitle"];
		}

		if ([elementName isEqualToString:@"itunes:duration"]) {
			currentStringValue = (NSMutableString *)[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			[itemContents setObject:currentStringValue forKey:@"duration"];
		}		
		
		// currentStringValue is an instance variable		
		currentStringValue = nil;
	}

}

@end
