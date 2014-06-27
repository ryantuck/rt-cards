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
@synthesize lastEditedDate;

@synthesize waitingOn;
@synthesize neededFor;

@synthesize project;
@synthesize action;
@synthesize notes;
@synthesize tags;
@synthesize type;

-(id)initWithInfo:(CardInfo*)info
{
	// takes in info from managed object and applies to self, which is simply nsobject
	
	self.title			= info.title;
	self.identifier		= info.identifier;
	self.createdDate	= info.createdDate;
	self.dueDate		= info.dueDate;
	self.reminderDate	= info.reminderDate;
	self.completedDate	= info.completedDate;
	self.lastEditedDate = info.lastEditedDate;
	self.waitingOn		= info.waitingOn;
	self.neededFor		= info.neededFor;
	self.project		= info.project;
	self.action			= info.action;
	self.type			= info.type;
	self.tags			= info.tags;
	self.notes			= info.notes;
	
	return self;
}

@end
