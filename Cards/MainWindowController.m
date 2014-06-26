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
		CardModel* aCard = [[CardModel alloc] init];
		aCard.title = entryInput.stringValue;
		[self createNewCardWithTitle:entryInput.stringValue];
		[self insertObject:aCard inCardsArrayAtIndex:0];
		[self setCards:cards];
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
	cardInfo.title = title;
	cardInfo.identifier = [self getRandomAlphanumericString];
	cardInfo.createdDate = [NSDate date];
	
	NSError* error;
	if (![context save:&error])
	{
		NSLog(@"fuck - couldn't save: %@",[error localizedDescription]);
	}
	
	// fetch and list all stored cards
	NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription* entity = [NSEntityDescription
								   entityForName:@"CardInfo"
								   inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSArray* fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	for (CardInfo* card in fetchedObjects)
	{
		NSLog(@"Title: %@",card.title);
		NSLog(@"ID: %@",card.identifier);
		NSLog(@"Date: %@",card.createdDate);
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
	[self deleteCardWithIdentifier:[self firstCard].identifier];
	[self populateCardsWithStoredData];
}

-(IBAction)processButtonPressed:(id)sender
{
	// save new title to card
	[self firstCard].title = [[self titleBox] stringValue];
	[self populateCardsWithStoredData];
	[self populateInboxProcessingFields];
}

-(IBAction)changeType:(id)sender
{
	int x = (int)[[self types] selectedRow];
	NSLog(@"type: %@",[NSNumber numberWithInt:x]);
	
	switch (x)
	{
		case 0:
			// next
			[self editCardTypeWithIdentifier:((CardModel*)[[self inbox] objectAtIndex:0]).identifier toNewType:@"next"];
			break;
		case 1:
			// scheduled
			[self editCardTypeWithIdentifier:((CardModel*)[[self inbox] objectAtIndex:0]).identifier toNewType:@"scheduled"];
			break;
		case 2:
			// tracking
			[self editCardTypeWithIdentifier:((CardModel*)[[self inbox] objectAtIndex:0]).identifier toNewType:@"tracking"];
			break;
		case 3:
			// someday
			[self editCardTypeWithIdentifier:((CardModel*)[[self inbox] objectAtIndex:0]).identifier toNewType:@"someday"];
			break;
		case 4:
			// projects
			[self editCardTypeWithIdentifier:((CardModel*)[[self inbox] objectAtIndex:0]).identifier toNewType:@"projects"];
			break;
		default:
			NSLog(@"no case chosen");
			break;
	}
}

-(IBAction)changeAction:(id)sender
{
	int x = (int)[[self types] selectedRow];
	NSLog(@"action: %@",[NSNumber numberWithInt:x]);
	
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
	CardInfo* currentCard = [self firstCard];
	
	if (currentCard != nil)
	{
		[self.titleBox setStringValue:currentCard.title];
		[self.identifierLabel setStringValue:currentCard.identifier];
		[self updateCardCount];
	}
	
	
}


// --------------------------------------------------------
// Card Handling
// --------------------------------------------------------
@synthesize cards;

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
	
	NSArray* fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	NSPredicate* inboxPredicate		= [NSPredicate predicateWithFormat:@"type == 'inbox'"];
	NSPredicate* nextPredicate		= [NSPredicate predicateWithFormat:@"type == 'next'"];
	NSPredicate* trackingPredicate	= [NSPredicate predicateWithFormat:@"type == 'tracking'"];
	NSPredicate* somedayPredicate	= [NSPredicate predicateWithFormat:@"type == 'someday'"];
	NSPredicate* scheduledPredicate = [NSPredicate predicateWithFormat:@"type == 'scheduled'"];
	NSPredicate* projectsPredicate	= [NSPredicate predicateWithFormat:@"type == 'projects'"];
	NSPredicate* donePredicate		= [NSPredicate predicateWithFormat:@"type == 'done'"];
	
	
	
	NSArray* inboxArray = [fetchedObjects filteredArrayUsingPredicate:inboxPredicate];
	NSArray* nextArray = [fetchedObjects filteredArrayUsingPredicate:nextPredicate];
	NSArray* trackingArray = [fetchedObjects filteredArrayUsingPredicate:trackingPredicate];
	NSArray* somedayArray = [fetchedObjects filteredArrayUsingPredicate:somedayPredicate];
	NSArray* scheduledArray = [fetchedObjects filteredArrayUsingPredicate:scheduledPredicate];
	NSArray* projectsArray = [fetchedObjects filteredArrayUsingPredicate:projectsPredicate];
	NSArray* doneArray = [fetchedObjects filteredArrayUsingPredicate:donePredicate];
	
	NSArray* sectionArrays = [[NSArray alloc] initWithObjects:inboxArray, nextArray, trackingArray, somedayArray, scheduledArray, projectsArray, doneArray, nil];
	
	NSMutableArray* mInboxArray		= [[NSMutableArray alloc] init];
	NSMutableArray* mNextArray		= [[NSMutableArray alloc] init];
	NSMutableArray* mTrackingArray	= [[NSMutableArray alloc] init];
	NSMutableArray* mSomedayArray	= [[NSMutableArray alloc] init];
	NSMutableArray* mScheduledArray = [[NSMutableArray alloc] init];
	NSMutableArray* mProjectsArray	= [[NSMutableArray alloc] init];
	NSMutableArray* mDoneArray		= [[NSMutableArray alloc] init];
	
	NSArray* mSectionArrays = [[NSArray alloc] initWithObjects:mInboxArray, mNextArray, mTrackingArray, mSomedayArray, mScheduledArray, mProjectsArray, mDoneArray, nil];
	
	for (int n=0;n<7;n++)
	{
		if ([[sectionArrays objectAtIndex:n] count] != 0)
		{
			for (CardInfo* cInfo in [sectionArrays objectAtIndex:n])
			{
				CardModel* aCard = [[CardModel alloc] initWithInfo:cInfo];
				[[mSectionArrays objectAtIndex:n] addObject:aCard];
				NSLog(@"n = %u",n);
			}
		}
	}
	
	[self setInbox:mInboxArray];
	[self setNext:mNextArray];
	[self setTracking:mTrackingArray];
	[self setScheduled:mScheduledArray];
	[self setSomeday:mSomedayArray];
	[self setProjects:mProjectsArray];
	[self setDone:mDoneArray];
	
	[self populateInboxProcessingFields];
}

-(CardInfo*)firstCard
{
	CardInfo* cardPtr;
	
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
	
	if ([fetchedObjects count] != 0)
	{
		cardPtr = (CardInfo*)[fetchedObjects objectAtIndex:0];
	}
	
	
	// save
	if (![context save:&error])
	{
		NSLog(@"shit mother fucker couldn't save: %@",[error localizedDescription]);
	}
	
	
	return cardPtr;
}

-(void)deleteCardWithIdentifier:(NSString*)myIdentifier
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
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",myIdentifier];
	NSArray* filteredArray = [fetchedObjects filteredArrayUsingPredicate:predicate];
	
	if ([filteredArray count] != 0)
	{
		// pick out object to delete and print its shit
		NSManagedObject* objToDelete = [filteredArray objectAtIndex:0];
		NSLog(@"objToDelete title: %@",((CardInfo*)objToDelete).title);
		[context deleteObject:objToDelete];
	}
	else
	{
		NSLog(@"array is not long enough you dumb fuck!");
	}
	
	// save
	if (![context save:&error])
	{
		NSLog(@"shit mother fucker couldn't save: %@",[error localizedDescription]);
	}
}

-(void)editCardTitleWithIdentifier:(NSString*)myIdentifier toNewTitle:(NSString*)newTitle
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
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",myIdentifier];
	NSArray* filteredArray = [fetchedObjects filteredArrayUsingPredicate:predicate];
	
	if ([filteredArray count] != 0)
	{
		// pick out object who we want to edit and change the title
		NSManagedObject* objToEdit = [filteredArray objectAtIndex:0];
		NSLog(@"objToEdit title: %@",((CardInfo*)objToEdit).title);
		((CardInfo*)objToEdit).title = newTitle;
		NSLog(@"new title: %@",((CardInfo*)objToEdit).title);
	}
	else
	{
		NSLog(@"array is not long enough you dumb fuck!");
	}
	
	// save
	if (![context save:&error])
	{
		NSLog(@"shit mother fucker couldn't save: %@",[error localizedDescription]);
	}
	
}

-(void)editCardTypeWithIdentifier:(NSString*)myIdentifier toNewType:(NSString*)newType
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
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",myIdentifier];
	NSArray* filteredArray = [fetchedObjects filteredArrayUsingPredicate:predicate];
	
	if ([filteredArray count] != 0)
	{
		// pick out object who we want to edit and change the type
		NSManagedObject* objToEdit = [filteredArray objectAtIndex:0];
		NSLog(@"objToEdit type: %@",((CardInfo*)objToEdit).type);
		((CardInfo*)objToEdit).type = newType;
		NSLog(@"new title: %@",((CardInfo*)objToEdit).type);
	}
	else
	{
		NSLog(@"array is not long enough you dumb fuck!");
	}
	
	// save
	if (![context save:&error])
	{
		NSLog(@"shit mother fucker couldn't save: %@",[error localizedDescription]);
	}
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
-(void)insertObject:(CardModel *)c inCardsArrayAtIndex:(NSUInteger)index
{
	[cards insertObject:c atIndex:index];
}

-(void)setCards:(NSMutableArray *)a
{
	cards = a;
}

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


-(NSArray*)cards
{
	return cards;
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































