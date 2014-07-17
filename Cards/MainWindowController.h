//
//  MainWindowDelegate.h
//  Cards
//
//  Created by Ryan Tuck on 6/20/14.
//  Copyright (c) 2014 Ryan Tuck. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CardInfo.h"
#import "CardView.h"


@interface MainWindowController : NSWindowController <RTDelegate>

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
@property IBOutlet NSTokenField* tagsBox;
@property IBOutlet NSTextField* notesBox;

@property IBOutlet NSTextField* identifierLabel;

@property IBOutlet NSMatrix* types;

@property IBOutlet NSMatrix* actions;
@property IBOutlet NSButton* dueCheckBox;
@property IBOutlet NSButton* reminderCheckBox;
@property IBOutlet NSDatePicker* duePicker;
@property IBOutlet NSDatePicker* reminderPicker;

@property IBOutlet NSTextField* cardCount;


// radio button handling
-(IBAction)changeType:(id)sender;
-(IBAction)changeAction:(id)sender;

// button press handling
-(IBAction)deleteButtonPressed:(id)sender;
-(IBAction)processButtonPressed:(id)sender;
-(IBAction)doneButtonPressed:(id)sender;


-(void)populateInboxProcessingFields;

// --------------------------------------------------------
// Next UI
// --------------------------------------------------------
@property IBOutlet NSSearchField* searchBox;
@property IBOutlet NSButton* filterCheckBox;
@property IBOutlet NSMatrix* nextActionRadioButtons;

// --------------------------------------------------------
// Card Handling
// --------------------------------------------------------

// Filtered card arrays
@property NSMutableArray* inbox;
@property NSMutableArray* next;
@property NSMutableArray* tracking;
@property NSMutableArray* scheduled;
@property NSMutableArray* someday;
@property NSMutableArray* done;
@property NSMutableArray* projects;

-(void)populateCardsWithStoredData;

// --------------------------------------------------------
// Helpers
// --------------------------------------------------------
-(NSString*)getRandomAlphanumericString;




// =========================================================================================

@property IBOutlet NSCollectionView* currentCollectionView;

@property IBOutlet NSTableView* pTableView;

@property IBOutlet NSView* monoView;	// overall view

@property NSMutableArray* current;		// current cards after filtering

@property int currentType;

@property IBOutlet NSTextField* sectionTitle;
@property IBOutlet NSTextField* sectionCount;


@property NSMutableArray* tagsList;		// lists of available projects and tags
@property NSMutableArray* projectsList;


// card details
@property IBOutlet NSTextField* cardTitleBox;
@property IBOutlet NSTextField* cardIdentifier;

@property IBOutlet NSMatrix* cardActionRadioButtons;
@property IBOutlet NSMatrix* cardTypeRadioButtons;
@property IBOutlet NSButton* cardDueCheckBox;
@property IBOutlet NSButton* cardReminderCheckBox;
@property IBOutlet NSDatePicker* cardDuePicker;
@property IBOutlet NSDatePicker* cardReminderPicker;

@property IBOutlet NSTokenField* cardTags;
@property IBOutlet NSTextField* cardNotes;

@property IBOutlet NSButton* cardDoneButton;
@property IBOutlet NSButton* cardDeleteButton;
@property IBOutlet NSButton* cardEditButton;



// filtering stuff
@property IBOutlet NSSearchField* currentSearchBox;
@property IBOutlet NSButton* actionCheckBox;
@property IBOutlet NSMatrix* actionRadioButtons;
@property IBOutlet NSTableView* tagTable;
@property IBOutlet NSTableView* projectTable;
@property IBOutlet NSButton* clearFiltersButton;

-(void)populateCardDetailsFromSelectedCard;




@end
