//
//  AppDelegate.h
//  Cards
//
//  Created by Ryan Tuck on 6/20/14.
//  Copyright (c) 2014 Ryan Tuck. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@class MainWindowController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction)showMainWindow:(id)sender;

@end

// here's a test line for the commit

