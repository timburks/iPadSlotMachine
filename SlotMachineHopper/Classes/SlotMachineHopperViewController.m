//
//  SlotMachineHopperViewController.m
//  SlotMachineHopper
//
//  Created by Andrew Dudney on 4/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SlotMachineHopperViewController.h"
#import "SMHView.h"

@implementation SlotMachineHopperViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.frame = CGRectMake(0.5*(768-1024),0.5*(1024-768),1024,768);
	self.view.transform = CGAffineTransformMakeRotation(-M_PI/2);
}

- (void) dropCoins:(SlotMachineHopperWinSize) prize {
	[self.view beginCoinDrop:prize];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
