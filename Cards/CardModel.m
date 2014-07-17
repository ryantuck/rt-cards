//
//  CardModel.m
//  Cards
//
//  Created by Ryan Tuck on 6/20/14.
//  Copyright (c) 2014 Ryan Tuck. All rights reserved.
//

#import "CardModel.h"
#import "Tag.h"

@implementation CardModel

@synthesize title;
@synthesize identifier;

@synthesize createdDate;
@synthesize completedDate;
@synthesize lastEditedDate;
@synthesize dueDate;
@synthesize reminderDate;

@synthesize type;
@synthesize action;

@synthesize notes;
@synthesize tags;

@synthesize project;
@synthesize waitingOn;
@synthesize neededFor;

-(id)init
{
	self.tags = [[NSMutableSet alloc] init];
	return self;
}

-(id)initWithInfo:(CardInfo*)cInfo
{
	// takes in info from managed object and applies to self, which is simply nsobject
	
	self = [self init];
	
	self.title			= cInfo.title;
	self.identifier		= cInfo.identifier;
	
	self.createdDate	= cInfo.createdDate;
	self.completedDate	= cInfo.completedDate;
	self.lastEditedDate	= cInfo.lastEditedDate;
	self.dueDate		= cInfo.dueDate;
	self.reminderDate	= cInfo.reminderDate;
	
	self.type			= cInfo.type;
	self.action			= cInfo.action;
	
	self.notes			= cInfo.notes;
	
	for (Tag* tag in cInfo.tags)
	{
		[self.tags addObject:tag.name];
	}
	
	// here, tags are registered as strings
	
	self.project		= cInfo.project;
	self.waitingOn		= cInfo.waitingOn;
	self.neededFor		= cInfo.neededFor;
	
	return self;
}

-(void)logInfo
{
	NSLog(@"== Card Info ==========");
	NSLog(@"Title:          %@",self.title);
	NSLog(@"Identifier:     %@",self.identifier);
	NSLog(@"Dates");
	NSLog(@"-- created:     %@",self.createdDate);
	NSLog(@"-- completed:   %@",self.completedDate);
	NSLog(@"-- edited:      %@",self.lastEditedDate);
	NSLog(@"-- due:         %@",self.dueDate);
	NSLog(@"-- reminder:    %@",self.reminderDate);
	NSLog(@"Type:           %@",self.type);
	NSLog(@"Action:         %@",self.action);
	NSLog(@"Notes:          %@",self.notes);
	NSLog(@"Tags ( %lu )",[self.tags count]);
	for (NSString* tag in self.tags)
	{
		NSLog(@"-- %@",tag);
	}
	NSLog(@"Project:        %@",self.project);
	NSLog(@"Waiting on:     %@",self.waitingOn);
	NSLog(@"Needed for:     %@",self.neededFor);
	NSLog(@"");
}

@end
