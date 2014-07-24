//
//  CardView.h
//  Cards
//
//  Created by Ryan Tuck on 7/2/14.
//  Copyright (c) 2014 Ryan Tuck. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "MainWindowController.h"

@protocol RTDelegate
	-(void)doShit:(NSEvent*)theEvent;
@end

@interface CardView : NSView

@property BOOL selected;
@property IBOutlet id<RTDelegate> delegate;

-(void)logShit;

@end
