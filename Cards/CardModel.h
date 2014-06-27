//
//  CardModel.h
//  Cards
//
//  Created by Ryan Tuck on 6/20/14.
//  Copyright (c) 2014 Ryan Tuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardInfo.h"

@interface CardModel : NSObject

@property (retain,readwrite)	NSString*	title;

@property (retain,readwrite)	NSString*	identifier;
@property (retain, readwrite)	NSDate*		createdDate;
@property (retain, readwrite)	NSDate*		completedDate;

@property (retain, readwrite)	NSDate*		dueDate;
@property (retain, readwrite)	NSDate*		reminderDate;
@property (retain, readwrite)	NSDate*		lastEditedDate;

@property (retain, readwrite)	NSString*	waitingOn;
@property (retain, readwrite)	NSString*	neededFor;

@property (retain, readwrite)	NSString*	type;

@property (retain, readwrite)	NSString*	project;
@property (retain, readwrite)	NSString*	action;
@property (retain, readwrite)	NSString*	notes;

@property (retain, readwrite)	NSMutableArray*	tags;


-(id)initWithInfo:(CardInfo*)info;

@end
