//
//  CardView.m
//  Cards
//
//  Created by Ryan Tuck on 7/2/14.
//  Copyright (c) 2014 Ryan Tuck. All rights reserved.
//

#import "CardView.h"

@implementation CardView

@synthesize selected;

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
	if (selected)
	{
		[[NSColor yellowColor] set];
		NSRectFill([self bounds]);
	}
}

-(void)logShit
{
	NSLog(@"logging shit");
}

@end
