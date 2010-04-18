//
//  MasterViewController.m
//  iPadSlotMachine
//
//  Created by Tim Burks on 4/17/10.
//

#import "MasterViewController.h"
#import "ApplicationDelegate.h"

@implementation MasterViewController
@synthesize startButton;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	self.view = [[[UIView alloc]
				  initWithFrame:[[UIScreen mainScreen] applicationFrame]]
				 autorelease];
	self.view.backgroundColor = [UIColor clearColor];
	self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[startButton setImage:[UIImage imageNamed:@"StartButton.png"] forState:UIControlStateNormal];
	[startButton setImage:[UIImage imageNamed:@"StartButtonActive.png"] forState:UIControlStateHighlighted];
	[startButton addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
	startButton.opaque = NO;
	startButton.backgroundColor = [UIColor clearColor];
	startButton.frame = CGRectMake(0.5*(768-682),0.5*(1024-288),682,288);
	[self.view addSubview:startButton];
}

- (void) start:(id) sender {
	[startButton setImage:[UIImage imageNamed:@"StopButton.png"] forState:UIControlStateNormal];
	[startButton setImage:[UIImage imageNamed:@"StopButtonActive.png"] forState:UIControlStateHighlighted];
	[startButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
	[startButton addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
	DELEGATE.numberOfReelsCurrentlySpinning = [DELEGATE.slaveReels count];
	[DELEGATE sendMessageToReels:@"start"];
}

- (void) stop:(id) sender {
	[startButton setImage:[UIImage imageNamed:@"StartButton.png"] forState:UIControlStateNormal];
	[startButton setImage:[UIImage imageNamed:@"StartButtonActive.png"] forState:UIControlStateHighlighted];
	[startButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
	[startButton addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
	[DELEGATE sendMessageToReels:@"stop"];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
