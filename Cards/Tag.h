//
//  Tag.h
//  Cards
//
//  Created by Ryan Tuck on 6/29/14.
//  Copyright (c) 2014 Ryan Tuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CardInfo;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSSet *cards;

@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addCardsObject:(CardInfo *)value;
- (void)removeCardsObject:(CardInfo *)value;
- (void)addCards:(NSSet *)values;
- (void)removeCards:(NSSet *)values;

@end
