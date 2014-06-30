//
//  MainWindowController.m
//  Cards
//
//  Created by Ryan Tuck on 6/20/14.
//  Copyright (c) 2014 Ryan Tuck. All rights reserved.
//

#import "MainWindowController.h"
#import "CardModel.h"
#import "AppDelegate.h"
#import "CardInfo.h"
#import "Tag.h"

@interface MainWindowController ()

@end

@implementation MainWindowController



// --------------------------------------------------------
// Top Level Shit
// --------------------------------------------------------
-(id)init
{
	self = [super initWithWindowNibName:@"MainWindow"];
	return self;
}

- (void)windowDidLoad
{
	NSLog(@"Window Did Load");
	
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
	[[self window] setContentSize:[entryView frame].size];
	[[[self window] contentView] addSubview:entryView];
	[[[self window] contentView] setWantsLayer:YES];
}

// --------------------------------------------------------
// Setup
// --------------------------------------------------------
-(void)awakeFromNib {
	
	NSLog(@"Awake From NIB");
	
	// set entry view as first view
	[[self window] setContentSize:[entryView frame].size];
	[[[self window] contentView] addSubview:entryView];
	
	// set cards from stored data
	[self populateCardsWithStoredData];
	
	// set up field to create new card upon hitting enter
	[entryInput setTarget:self];
	[entryInput setAction:@selector(addToDo:)];
}


// --------------------------------------------------------
// Toolbar
// --------------------------------------------------------
@synthesize entryView;
@synthesize inboxView;
@synthesize nextView;
@synthesize projectsView;
@synthesize trackingView;
@synthesize scheduledView;
@synthesize somedayView;
@synthesize doneView;

@synthesize currentViewTag;

-(NSView*)viewForTag:(int)tag
{
	NSView* view = nil;
	switch (tag)
	{
		case 0: view = entryView;		break;
		case 1: view = inboxView;		break;
		case 2: view = nextView;		break;
		case 3: view = trackingView;	break;
		case 4: view = scheduledView;	break;
		case 5: view = projectsView;	break;
		case 6: view = somedayView;		break;
		case 7: view = doneView;		break;

		default: view = entryView;		break;
	}
	
	return view;
}

-(BOOL)validateToolbarItem:(NSToolbarItem *)item
{
	if ([item tag] == currentViewTag) return NO;
	else return YES;
}

-(IBAction)switchView:(id)sender
{
	int tag = (int)[sender tag];
	NSView* view = [self viewForTag:tag];
	NSView* previousView = [self viewForTag:currentViewTag];
	currentViewTag = tag;
	
	[[[self window] contentView] replaceSubview:previousView with:view];
}


// --------------------------------------------------------
// Entry
// --------------------------------------------------------
@synthesize entryInput;

-(IBAction)addToDo:(id)sender
{
	if (![self.entryInput.stringValue isEqual:@""])
	{
		[self createNewCardWithTitle:entryInput.stringValue];
		[self populateCardsWithStoredData];
		[entryInput setStringValue:@""];
	}
}

-(void)createNewCardWithTitle:(NSString *)title
{
	// create new entity and add it to our context
	NSManagedObjectContext* context = ((AppDelegate*)[NSApplication sharedApplication].delegate).managedObjectContext;
	CardInfo* cardInfo = [NSEntityDescription
						  insertNewObjectForEntityForName:@"CardInfo"
						  inManagedObjectContext:context];
	
	cardInfo.title			= title;
	cardInfo.identifier		= [self getRandomAlphanumericString];
	cardInfo.createdDate	= [NSDate date];
	cardInfo.type			= @"inbox";
	
	// save!
	NSError* error;
	if (![context save:&error])
	{
		NSLog(@"fuck - couldn't save: %@",[error localizedDescription]);
	}
}


// --------------------------------------------------------
// Inbox
// --------------------------------------------------------
-(void)updateCardCount
{
	[[self cardCount] setStringValue:[NSString stringWithFormat:@"%lu",(unsigned long)[[self inbox] count]]];
}

-(IBAction)deleteButtonPressed:(id)sender
{
	[self deleteCard:[self firstInboxCard]];
	[self populateCardsWithStoredData];
}

-(IBAction)processButtonPressed:(id)sender
{
	// set processing stuff to card model
	[self firstInboxCard].title		= [[self titleBox] stringValue];
	[self firstInboxCard].type		= [self typeFromNumber:(int)[[self types] selectedRow] + 1];
	[self firstInboxCard].action	= [self actionFromNumber:(int)[[self actions] selectedRow]];
	[self firstInboxCard].notes		= [[self notesBox] stringValue];
	
	// set dates if dates are specified
	if (self.dueCheckBox.state == NSOnState){
		[self firstInboxCard].dueDate = [[self duePicker] dateValue];
	}
	if (self.reminderCheckBox.state == NSOnState){
		[self firstInboxCard].reminderDate = [[self reminderPicker] dateValue];
	}
	
	// add tags from tagsBox to the card
	NSSet* tmpTags = [self.tagsBox objectValue];
	for (NSString* string in tmpTags)
	{
		[self.firstInboxCard.tags addObject:string];
	}

	// save to core data
	[self editCard:[self firstInboxCard]];
	
	// repopulate view
	[self populateCardsWithStoredData];
	[self populateInboxProcessingFields];
}

-(IBAction)doneButtonPressed:(id)sender
{
	
}

-(void)logAllNextActionCards
{
	for (CardModel* card in self.next)
	{
		[card logInfo];
	}
}

-(IBAction)changeType:(id)sender
{
	int x = (int)[[self types] selectedRow];

	switch (x)
	{
		case 0:
			// next
			
			// hide 'remind me'
			[self showActions:YES];
			[self showDueStuff:YES];
			[self showReminderStuff:NO];
			
			
			break;
		case 1:
			// scheduled
			
			// show 'remind me'
			[self showActions:YES];
			[self showDueStuff:YES];
			[self showReminderStuff:YES];

			
			break;
		case 2:
			// tracking
			
			// hide all
			[self showActions:NO];
			[self showDueStuff:NO];
			[self showReminderStuff:NO];
			
			break;
		case 3:
			// someday
			
			// hide all
			[self showActions:NO];
			[self showDueStuff:NO];
			[self showReminderStuff:NO];
			
			break;
		case 4:
			// projects
			
			// hide all (for now)
			[self showActions:NO];
			[self showDueStuff:NO];
			[self showReminderStuff:NO];
			
			break;
		default:
			NSLog(@"no case chosen");
			break;
	}
}

-(IBAction)changeAction:(id)sender
{
	// ***
	// currently doesn't do anything - can probably delete
	
	int x = (int)[[self types] selectedRow];
	
	switch (x)
	{
		case 0:
			// do
			break;
		case 1:
			// brainstorm
			break;
		case 2:
			// research
			break;
		case 3:
			// buy
			break;
		case 4:
			// review
			break;
		case 5:
			// contact
			break;
		default:
			NSLog(@"no case chosen");
			break;
	}
}

-(void)populateInboxProcessingFields
{
	CardModel* currentCard = [self firstInboxCard];
	
	if (currentCard != nil)
	{
		[self.titleBox setStringValue:currentCard.title];
		[self.identifierLabel setStringValue:currentCard.identifier];
		[self updateCardCount];
	}
	else
	{
		NSLog(@"inbox is empty!");
	}
	
	[self showActions:YES];
	[self showDueStuff:YES];
	[self showReminderStuff:NO];
	self.tagsBox.stringValue = @"";
	
	[[self types] selectCellAtRow:0 column:0];
}

-(void)showReminderStuff:(BOOL)show
{
	[self reminderCheckBox].hidden	= !show;
	[self reminderPicker].hidden	= !show;
	
	[self resetReminderStuff];
}

-(void)showDueStuff:(BOOL)show
{
	[self dueCheckBox].hidden	= !show;
	[self duePicker].hidden		= !show;
	
	[self resetDueStuff];
}

-(void)enableDatePicker:(NSDatePicker*)picker active:(BOOL)active
{
	//[picker setEnabled:active];
	picker.enabled = active;
}

-(void)enableCheckBox:(NSButton*)checkbox active:(BOOL)active
{
	checkbox.enabled = active;
}

-(IBAction)dueCheckBoxClicked:(id)sender
{
	BOOL isActive = NO;
	if ([[self dueCheckBox] state] == NSOnState) isActive = YES;
	
	[self enableDatePicker:[self duePicker] active:isActive];
}

-(IBAction)reminderCheckBoxClicked:(id)sender
{
	BOOL isActive = NO;
	if ([[self reminderCheckBox] state] == NSOnState) isActive = YES;
	[self enableDatePicker:[self reminderPicker] active:isActive];
}

-(void)showActions:(BOOL)show
{
	[self actions].hidden = !show;
}

-(void)resetDueStuff
{
	[self dueCheckBox].state	= NSOffState;
	[self duePicker].enabled	= NO;
}

-(void)resetReminderStuff
{
	[self reminderCheckBox].state	= NSOffState;
	[self reminderPicker].enabled	= NO;
}

-(NSString*)typeFromNumber:(int)n
{
	NSString* type;
	
	switch (n)
	{
		case 0: type = @"inbox";		break;
		case 1: type = @"next";			break;
		case 2: type = @"scheduled";	break;
		case 3: type = @"tracking";		break;
		case 4: type = @"someday";		break;
		case 5: type = @"projects";		break;
		case 6: type = @"done";			break;
			
		default: type = @"inbox";		break;
	}
	
	return type;
}

-(NSString*)actionFromNumber:(int)n
{
	NSString* action;
	
	switch (n)
	{
		case 0: action = @"do";				break;
		case 1: action = @"brainstorm";		break;
		case 2: action = @"research";		break;
		case 3: action = @"buy";			break;
		case 4: action = @"review";			break;
		case 5: action = @"contact";		break;
			
		default: action = @"do";			break;
			
	}
	
	return action;
}


// --------------------------------------------------------
// Card Handling
// --------------------------------------------------------

@synthesize inbox;
@synthesize next;
@synthesize tracking;
@synthesize scheduled;
@synthesize someday;
@synthesize done;
@synthesize projects;

-(void)populateCardsWithStoredData
{
	NSManagedObjectContext* context = ((AppDelegate*)[NSApplication sharedApplication].delegate).managedObjectContext;
	NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription* entity = [NSEntityDescription
								   entityForName:@"CardInfo"
								   inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
	NSError* error;
	if (![context save:&error])
	{
		NSLog(@"shit mother fucker couldn't save: %@",[error localizedDescription]);
	}
	
	// fetch data from store
	NSArray* fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	// set up filtering predicates
	NSPredicate* inboxPredicate		= [NSPredicate predicateWithFormat:@"type == 'inbox'"];
	NSPredicate* nextPredicate		= [NSPredicate predicateWithFormat:@"type == 'next'"];
	NSPredicate* trackingPredicate	= [NSPredicate predicateWithFormat:@"type == 'tracking'"];
	NSPredicate* somedayPredicate	= [NSPredicate predicateWithFormat:@"type == 'someday'"];
	NSPredicate* scheduledPredicate = [NSPredicate predicateWithFormat:@"type == 'scheduled'"];
	NSPredicate* projectsPredicate	= [NSPredicate predicateWithFormat:@"type == 'projects'"];
	NSPredicate* donePredicate		= [NSPredicate predicateWithFormat:@"type == 'done'"];
	
	// create filtered arrays
	NSArray* inboxArray		= [fetchedObjects filteredArrayUsingPredicate:inboxPredicate];
	NSArray* nextArray		= [fetchedObjects filteredArrayUsingPredicate:nextPredicate];
	NSArray* trackingArray	= [fetchedObjects filteredArrayUsingPredicate:trackingPredicate];
	NSArray* somedayArray	= [fetchedObjects filteredArrayUsingPredicate:somedayPredicate];
	NSArray* scheduledArray = [fetchedObjects filteredArrayUsingPredicate:scheduledPredicate];
	NSArray* projectsArray	= [fetchedObjects filteredArrayUsingPredicate:projectsPredicate];
	NSArray* doneArray		= [fetchedObjects filteredArrayUsingPredicate:donePredicate];
	
	NSMutableArray* mInboxArray		= [[NSMutableArray alloc] init];
	NSMutableArray* mNextArray		= [[NSMutableArray alloc] init];
	NSMutableArray* mTrackingArray	= [[NSMutableArray alloc] init];
	NSMutableArray* mSomedayArray	= [[NSMutableArray alloc] init];
	NSMutableArray* mScheduledArray = [[NSMutableArray alloc] init];
	NSMutableArray* mProjectsArray	= [[NSMutableArray alloc] init];
	NSMutableArray* mDoneArray		= [[NSMutableArray alloc] init];
	
	NSArray* sectionArrays = [[NSArray alloc] initWithObjects:inboxArray, nextArray, trackingArray, somedayArray, scheduledArray, projectsArray, doneArray, nil];
	NSArray* mSectionArrays = [[NSArray alloc] initWithObjects:mInboxArray, mNextArray, mTrackingArray, mSomedayArray, mScheduledArray, mProjectsArray, mDoneArray, nil];
	
	// populate mutable arrays required for the 'setting' bullshit below
	for (int n=0;n<7;n++)
	{
		if ([[sectionArrays objectAtIndex:n] count] != 0)
		{
			for (CardInfo* cInfo in [sectionArrays objectAtIndex:n])
			{
				CardModel* aCard = [[CardModel alloc] initWithInfo:cInfo];
				[[mSectionArrays objectAtIndex:n] addObject:aCard];
			}
		}
	}
	
	// set member arrays
	[self setInbox:mInboxArray];
	[self setNext:mNextArray];
	[self setTracking:mTrackingArray];
	[self setScheduled:mScheduledArray];
	[self setSomeday:mSomedayArray];
	[self setProjects:mProjectsArray];
	[self setDone:mDoneArray];
	
	// go ahead and re-populate the inbox bullshit
	[self populateInboxProcessingFields];
}

-(CardModel*)firstInboxCard
{
	CardModel* cardPtr;
	
	if ([[self inbox] count] != 0)
	{
		cardPtr = [[self inbox] objectAtIndex:0];
	}
	
	return cardPtr;
}

-(void)editCard:(CardModel*)cModel
{
	NSLog(@"editCard: %@",cModel.title);
	
	// set up context and fetch bullshit
	NSManagedObjectContext* context = ((AppDelegate*)[NSApplication sharedApplication].delegate).managedObjectContext;
	NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription* entity = [NSEntityDescription
								   entityForName:@"CardInfo"
								   inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
	// save
	NSError* error;
	if (![context save:&error])
	{
		NSLog(@"shit mother fucker couldn't save: %@",[error localizedDescription]);
	}
	
	NSArray* fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	// get object with certain identifier
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",cModel.identifier];
	NSArray* filteredArray = [fetchedObjects filteredArrayUsingPredicate:predicate];
	
	// assign card model's information
	if ([filteredArray count] != 0)
	{
		NSManagedObject* objToEdit = [filteredArray objectAtIndex:0];
		[self assignCardInfo:(CardInfo*)objToEdit fromModel:cModel];
	}
	else
	{
		NSLog(@"%lu cards exist that match this card: %@ // %@",[filteredArray count],cModel.title,cModel.identifier);
	}
	
	// save
	if (![context save:&error])
	{
		NSLog(@"shit mother fucker couldn't save: %@",[error localizedDescription]);
	}
}

-(void)deleteCard:(CardModel*)cModel
{
	// set up context and fetch bullshit
	NSManagedObjectContext* context = ((AppDelegate*)[NSApplication sharedApplication].delegate).managedObjectContext;
	NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription* entity = [NSEntityDescription
								   entityForName:@"CardInfo"
								   inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
	// save
	NSError* error;
	if (![context save:&error])
	{
		NSLog(@"shit mother fucker couldn't save: %@",[error localizedDescription]);
	}
	
	NSArray* fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	// get object with certain identifier
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",cModel.identifier];
	NSArray* filteredArray = [fetchedObjects filteredArrayUsingPredicate:predicate];
	
	// assign card model's information
	if ([filteredArray count] != 0)
	{
		NSLog(@"card model info deleted");
		NSManagedObject* objToDelete = [filteredArray objectAtIndex:0];
		[context deleteObject:objToDelete];
	}
	else
	{
		NSLog(@"%lu cards exist that match this card: %@ // %@",[filteredArray count],cModel.title,cModel.identifier);
	}
	
	// save
	if (![context save:&error])
	{
		NSLog(@"shit mother fucker couldn't save: %@",[error localizedDescription]);
	}

}

-(void)assignCardInfo:(CardInfo*)cInfo fromModel:(CardModel*)cModel
{
	NSLog(@"assignCardInfo: %@",cInfo.title);
	
	cInfo.title				= cModel.title;
	cInfo.identifier		= cModel.identifier;
	
	cInfo.createdDate		= cModel.createdDate;
	cInfo.completedDate		= cModel.completedDate;
	cInfo.lastEditedDate	= cModel.lastEditedDate;
	cInfo.dueDate			= cModel.dueDate;
	cInfo.reminderDate		= cModel.reminderDate;
	
	cInfo.type				= cModel.type;
	cInfo.action			= cModel.action;
	
	cInfo.notes				= cModel.notes;
	
	for (NSString* string in cModel.tags)
	{
		[self addTag:string toCardInfo:cInfo];
	}

	cInfo.project			= cModel.project;
	cInfo.waitingOn			= cModel.waitingOn;
	cInfo.neededFor			= cModel.neededFor;
}

-(void)assignCardModel:(CardModel*)cModel fromInfo:(CardInfo*)cInfo
{
	cModel.title			= cInfo.title;
	cModel.identifier		= cInfo.identifier;
	
	cModel.createdDate		= cInfo.createdDate;
	cModel.completedDate	= cInfo.completedDate;
	cModel.lastEditedDate	= cInfo.lastEditedDate;
	cModel.dueDate			= cInfo.dueDate;
	cModel.reminderDate		= cInfo.reminderDate;
	
	cModel.type				= cInfo.type;
	cModel.action			= cInfo.action;
	
	cModel.notes			= cInfo.notes;
	
	for (Tag* tag in cInfo.tags)
	{
		[cModel.tags addObject:tag.name];
	}
	
	cModel.project			= cInfo.project;
	cModel.waitingOn		= cInfo.waitingOn;
	cModel.neededFor		= cInfo.neededFor;
}

-(void)addTag:(NSString*)t toCardInfo:(CardInfo*)cInfo
{
	NSLog(@"addTag: %@ to cardInfo: %@",t,cInfo.title);
	
	NSManagedObjectContext* context = ((AppDelegate*)[NSApplication sharedApplication].delegate).managedObjectContext;
	
	Tag* tagToAdd;
	
	if ([self tagAlreadyExists:t])
	{
		NSLog(@"tag: %@ exists",t);
		// point to already existing tag
		tagToAdd = [self tagWithName:t];
	}
	else
	{
		NSLog(@"tag: %@ is unique",t);
		// create new tag
		tagToAdd = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
		tagToAdd.name = t;
	}

	NSMutableSet* tmpArray = [NSMutableSet setWithSet:cInfo.tags];
	[tmpArray addObject:tagToAdd];
	cInfo.tags = tmpArray;
	
	// save!
	NSError* error;
	if (![context save:&error])
	{
		NSLog(@"fuck - couldn't save: %@",[error localizedDescription]);
	}
}

-(void)printAllTags
{
	NSManagedObjectContext* context = ((AppDelegate*)[NSApplication sharedApplication].delegate).managedObjectContext;
	NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription* entity = [NSEntityDescription
								   entityForName:@"Tag"
								   inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
	NSError* error;
	if (![context save:&error])
	{
		NSLog(@"shit mother fucker couldn't save: %@",[error localizedDescription]);
	}
	
	// fetch data from store
	NSArray* fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	NSLog(@"number of fetched objects: %lu",[fetchedObjects count]);
	
	for (Tag* tag in fetchedObjects)
	{
		NSLog(@"tag name: %@",tag.name);
	}
}

-(BOOL)tagAlreadyExists:(NSString*)tagName
{
	bool check = false;
	
	// get tags
	NSManagedObjectContext* context = ((AppDelegate*)[NSApplication sharedApplication].delegate).managedObjectContext;
	NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription* entity = [NSEntityDescription
								   entityForName:@"Tag"
								   inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
	NSError* error;
	if (![context save:&error])
	{
		NSLog(@"shit mother fucker couldn't save: %@",[error localizedDescription]);
	}
	
	// fetch data from store
	NSArray* fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	// filter using predicate
	NSPredicate* namePredicate = [NSPredicate predicateWithFormat:@"name == %@",tagName];
	NSArray* filteredArray = [fetchedObjects filteredArrayUsingPredicate:namePredicate];
	
	if ([filteredArray count] == 0)
	{
		NSLog(@"filtered count is zero");
		check = false;
	}
	else
	{
		NSLog(@"%lu tags exist with the name: %@",[filteredArray count],tagName);
		check = true;
	}
	
	return check;
}

-(Tag*)tagWithName:(NSString*)tagName
{
	// get tags
	NSManagedObjectContext* context = ((AppDelegate*)[NSApplication sharedApplication].delegate).managedObjectContext;
	NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription* entity = [NSEntityDescription
								   entityForName:@"Tag"
								   inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
	NSError* error;
	if (![context save:&error])
	{
		NSLog(@"shit mother fucker couldn't save: %@",[error localizedDescription]);
	}
	
	// fetch data from store
	NSArray* fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	// filter using predicate
	NSPredicate* namePredicate = [NSPredicate predicateWithFormat:@"name == %@",tagName];
	NSArray* filteredArray = [fetchedObjects filteredArrayUsingPredicate:namePredicate];
	
	// ** do some checks here and log if there are more than one obviously
	
	Tag* x = [filteredArray objectAtIndex:0];
	return x;
}

// --------------------------------------------------------
// Helpers
// --------------------------------------------------------
-(NSString*)getRandomAlphanumericString
{
	CFUUIDRef uuidObj = CFUUIDCreate(nil);//create a new UUID
	NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
	CFRelease(uuidObj);
	return [uuidString substringToIndex:8]; //specify length here. even you can use full
}

// --------------------------------------------------------
// Bullshit setter getter functions
// --------------------------------------------------------
-(void)setNext:(NSMutableArray *)a
{
	next = a;
}

-(void)setTracking:(NSMutableArray *)a
{
	tracking = a;
}

-(void)setScheduled:(NSMutableArray *)a
{
	scheduled = a;
}

-(void)setProjects:(NSMutableArray *)a
{
	projects = a;
}

-(void)setSomeday:(NSMutableArray *)a
{
	someday = a;
}

-(void)setDone:(NSMutableArray *)a
{
	done = a;
}

-(NSArray*)next
{
	return next;
}

-(NSArray*)tracking
{
	return tracking;
}

-(NSArray*)scheduled
{
	return scheduled;
}

-(NSArray*)projects
{
	return projects;
}

-(NSArray*)someday
{
	return someday;
}

-(NSArray*)done
{
	return done;
}










@end































