//
//  CardInfo.h
//  Cards
//
//  Created by Ryan Tuck on 6/23/14.
//  Copyright (c) 2014 Ryan Tuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@class Tag;

@interface CardInfo : NSManagedObject

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* identifier;

@property (nonatomic, retain) NSDate* createdDate;
@property (nonatomic, retain) NSDate* lastEditedDate;
@property (nonatomic, retain) NSDate* reminderDate;
@property (nonatomic, retain) NSDate* dueDate;
@property (nonatomic, retain) NSDate* completedDate;

@property (nonatomic, retain) NSString* type;

@property (nonatomic, retain) NSString* action;
@property (nonatomic, retain) NSString* notes;
@property (nonatomic, retain) NSSet* tags;


// needed for project planning
@property (nonatomic, retain) NSString* project;
@property (nonatomic, retain) NSString* waitingOn;
@property (nonatomic, retain) NSString* neededFor;

@end

@interface CardInfo (CoreDataGeneratedAccessors)

- (void)addTagsToObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
