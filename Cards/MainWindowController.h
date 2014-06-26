//
//  MainWindowDelegate.h
//  Cards
//
//  Created by Ryan Tuck on 6/20/14.
//  Copyright (c) 2014 Ryan Tuck. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CardInfo.h"

@interface MainWindowController : NSWindowController

// --------------------------------------------------------
// Toolbar
// --------------------------------------------------------
@property IBOutlet NSView* entryView;
@property IBOutlet NSView* inboxView;
@property IBOutlet NSView* nextView;
@property IBOutlet NSView* projectsView;
@property IBOutlet NSView* trackingView;
@property IBOutlet NSView* scheduledView;
@property IBOutlet NSView* somedayView;
@property IBOutlet NSView* doneView;

@property int currentViewTag;

-(IBAction)switchView:(id)sender;


// --------------------------------------------------------
// Entry UI
// --------------------------------------------------------
@property IBOutlet NSTextField* entryInput;

-(IBAction)addToDo:(id)sender;
-(void)createNewCardWithTitle:(NSString*)title;


// --------------------------------------------------------
// Inbox UI
// --------------------------------------------------------
@property IBOutlet NSTextField* titleBox;
@property IBOutlet NSTextField* tagsBox;
@property IBOutlet NSMatrix* types;
@property IBOutlet NSMatrix* actions;
@property IBOutlet NSDatePicker* duePicker;
@property IBOutlet NSDatePicker* reminderPicker;
@property IBOutlet NSTextField* identifierLabel;
@property IBOutlet NSTextField* cardCount;

// radio button handling
-(IBAction)changeType:(id)sender;
-(IBAction)changeAction:(id)sender;

// button press handling
-(IBAction)deleteButtonPressed:(id)sender;
-(IBAction)processButtonPressed:(id)sender;


-(void)populateInboxProcessingFields;

// --------------------------------------------------------
// Card Handling
// --------------------------------------------------------
@property NSMutableArray* cards; // can prob delete?

// Filtered card arrays
@property NSMutableArray* inbox;
@property NSMutableArray* next;
@property NSMutableArray* tracking;
@property NSMutableArray* scheduled;
@property NSMutableArray* someday;
@property NSMutableArray* done;
@property NSMutableArray* projects;

-(CardInfo*)firstCard;	// what's this referring to?

-(void)populateCardsWithStoredData;

// switch these to take in a card
-(void)deleteCardWithIdentifier:(NSString*)myIdentifier;
-(void)editCardTitleWithIdentifier:(NSString*)myIdentifier toNewTitle:(NSString*)newTitle;

// --------------------------------------------------------
// Helpers
// --------------------------------------------------------
-(NSString*)getRandomAlphanumericString;



// =========================================================================================






@end
