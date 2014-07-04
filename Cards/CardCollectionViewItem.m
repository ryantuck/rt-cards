//
//  CardCollectionViewItem.m
//  Cards
//
//  Created by Ryan Tuck on 7/2/14.
//  Copyright (c) 2014 Ryan Tuck. All rights reserved.
//

#import "CardCollectionViewItem.h"
#import "CardView.h"

@interface CardCollectionViewItem ()

@end

@implementation CardCollectionViewItem

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)setSelected:(BOOL)flag
{
	[super setSelected:flag];
	[(CardView*)[self view] setSelected:flag];
	[(CardView*)[self view] setNeedsDisplay:YES];
}

-(void)logShit
{
	NSLog(@"logging some bullshit from cvi");
}

@end
