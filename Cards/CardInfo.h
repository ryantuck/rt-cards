//
//  CardInfo.h
//  Cards
//
//  Created by Ryan Tuck on 6/23/14.
//  Copyright (c) 2014 Ryan Tuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CardInfo : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString* type;

@end
