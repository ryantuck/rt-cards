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

@synthesize entryView;
@synthesize inboxView;
@synthesize nextView;
@synthesize projectsView;
@synthesize trackingView;
@synthesize scheduledView;
@synthesize somedayView;
@synthesize doneView;

@synthesize currentViewTag;

@synthesize cards;

@synthesize inbox;
@synthesize next;
@synthesize tracking;
@synthesize scheduled;
@synthesize someday;
@synthesize done;

@synthesize entryInput;

-(id)init
{
	self = [super initWithWindowNibName:@"MainWindow"];
	return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
	[[self window] setContentSize:[entryView frame].size];
	[[[self window] contentView] addSubview:entryView];
	[[[self window] contentView] setWantsLayer:YES];
	NSLog(@"awake from nib ran");
}

-(NSView*)viewForTag:(int)tag
{
	NSView* view = nil;
	switch (tag)
	{
		case 0: view = entryView;		break;
		case 1: view = inboxView;		break;
		case 2: view = nextView;		break;
		case 3: view = projectsView;	break;
		case 4: view = trackingView;	break;
		case 5: view = scheduledView;	break;
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

// We need to be layer-backed to have subview transitions.
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

-(IBAction)switchView:(id)sender
{
	int tag = (int)[sender tag];
	NSView* view = [self viewForTag:tag];
	NSView* previousView = [self viewForTag:currentViewTag];
	currentViewTag = tag;
	
	[[[self window] contentView] replaceSubview:previousView with:view];
}


-(void)insertObject:(CardModel *)c inCardsArrayAtIndex:(NSUInteger)index {
	[cards insertObject:c atIndex:index];
}

-(void)removeObjectFromCardsAtIndex:(NSUInteger)index {
	[cards removeObjectAtIndex:index];
}

-(void)setCards:(NSMutableArray *)a {
	cards = a;
}

-(NSArray*)cards {
	return cards;
}

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
	
	
	// test filtering this array
//	NSPredicate* blahPredicate = [NSPredicate predicateWithFormat:@"identifier contains[c] '9964F35E'"];
//	NSArray* aArray = [tmpCardArray filteredArrayUsingPredicate:blahPredicate];
//	NSMutableArray* xArray = [[NSMutableArray alloc] initWithArray:aArray];
	
	// create tmpCard array and draw its info out of the fetchRequest shit
	NSMutableArray* tmpCardArray = [[NSMutableArray alloc] init];
	for (CardInfo* cInfo in fetchedObjects)
	{
		// create new CardModel object and add to a NSMutableArray
		CardModel* aCard = [[CardModel alloc] initWithInfo:cInfo];
		[tmpCardArray addObject:aCard];
	}
	
	[self setCards:tmpCardArray];
}

-(IBAction)buttonPressed:(id)sender
{
	[self editCardTitleWithIdentifier:@"99BEDD24" toNewTitle:@"a new title here bro"];
	[self populateCardsWithStoredData];
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

//======================================================================================
// generates random string. should use for shit.
-(NSString*)getRandomAlphanumericString
{
	CFUUIDRef uuidObj = CFUUIDCreate(nil);//create a new UUID
	NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
	CFRelease(uuidObj);
	return [uuidString substringToIndex:8]; //specify length here. even you can use full
}



@end































