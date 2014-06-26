//
//  MainWindowDelegate.h
//  Cards
//
//  Created by Ryan Tuck on 6/20/14.
//  Copyright (c) 2014 Ryan Tuck. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainWindowController : NSWindowController

// Toolbar Sections
@property IBOutlet NSView* entryView;
@property IBOutlet NSView* inboxView;

@property IBOutlet NSView* nextView;
@property IBOutlet NSView* projectsView;

@property IBOutlet NSView* trackingView;
@property IBOutlet NSView* scheduledView;
@property IBOutlet NSView* somedayView;

@property IBOutlet NSView* doneView;

@property int currentViewTag;

// Inbox Processing Shit
@property IBOutlet NSTextField* titleBox;
@property IBOutlet NSTextField* tagsBox;
@property IBOutlet NSMatrix* types;
@property IBOutlet NSMatrix* actions;
@property IBOutlet NSDatePicker* duePicker;
@property IBOutlet NSDatePicker* reminderPicker;




// All cards array
@property NSMutableArray* cards;
// Filtered card arrays
@property NSMutableArray* inbox;
@property NSMutableArray* next;
@property NSMutableArray* tracking;
@property NSMutableArray* scheduled;
@property NSMutableArray* someday;
@property NSMutableArray* done;


@property IBOutlet NSTextField* entryInput;

-(IBAction)switchView:(id)sender;

-(IBAction)addToDo:(id)sender;

-(void)createNewCardWithTitle:(NSString*)title;
-(void)populateCardsWithStoredData;
-(NSString*)getRandomAlphanumericString;

-(void)deleteCardWithIdentifier:(NSString*)myIdentifier;
-(void)editCardTitleWithIdentifier:(NSString*)myIdentifier toNewTitle:(NSString*)newTitle;

-(IBAction)buttonPressed:(id)sender;

@end
