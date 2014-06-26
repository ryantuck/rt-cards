//
//  CardModel.m
//  Cards
//
//  Created by Ryan Tuck on 6/20/14.
//  Copyright (c) 2014 Ryan Tuck. All rights reserved.
//

#import "CardModel.h"

@implementation CardModel

@synthesize title;
@synthesize identifier;

@synthesize createdDate;
@synthesize dueDate;
@synthesize reminderDate;
@synthesize completedDate;

@synthesize waitingOn;
@synthesize neededFor;

@synthesize project;
@synthesize area;
@synthesize action;
@synthesize notes;
@synthesize tags;

-(id)initWithInfo:(CardInfo*)info
{
	// takes in info from managed object and applies to self, which is simply nsobject
	
	self.title			= info.title;
	self.identifier		= info.identifier;
	self.createdDate	= info.createdDate;
	
	
	return self;
}

@end
