//
//  FeedRequestor.h
//  TED Mobile
//
//  Created by Andrew Vergara on 8/24/10.
//  Copyright 2010 72andSunny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedRequestor : NSOperation <NSXMLParserDelegate> {
	NSObject *requestor;
	SEL requestorCallback;
	NSDate *timestamp;
	
	NSXMLParser *addressParser;
	BOOL itemElementInProgress;
	NSMutableArray *item;
	NSMutableDictionary *itemContents;
	NSMutableString *currentStringValue;
}
@property BOOL itemElementInProgress;
@property (nonatomic, strong) NSMutableArray *item;
@property (nonatomic, strong) NSMutableDictionary *itemContents;
@property (nonatomic, strong) NSMutableString *currentStringValue;

- (id)initForFeed:(NSObject *)caller callback:(SEL)callback;

@end
