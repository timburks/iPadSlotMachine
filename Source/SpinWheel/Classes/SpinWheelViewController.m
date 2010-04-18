//
//  SpinWheelViewController.m
//  SpinWheel
//
//  Created by Ramin on 4/16/10.
//  Copyright Ramin Firoozye 2010. All rights reserved.
//

#import "SpinWheelViewController.h"

@implementation SpinWheelViewController



- (id) initWithCoder:(NSCoder*) coder {
    if (self = [super initWithCoder:coder]) {
        // Custom initialization
		CGRect f = self.view.frame;
		self.wheel = [[WheelSpinner alloc] initWithFrame:f];
		self.view = self.wheel;
	
		/*
		 * This is just so we can test the spin forever/stop functionality
		 */
		/*
		UIButton* spinForver = [UIButton buttonWithType: UIButtonTypeRoundedRect];
		spinForever.frame = CGRectMake(200.0, 20.0, 80.0, 60.0);
		[spinForever setTitle:@"Spin" forState: UIControlStateNormal];	
		[spinForever addTarget:self action:@selector(doSpinForever:) forControlEvents:UIControlEventTouchDown];
		[self.view addSubview:spinForever];

		UIButton* stopSpin = [UIButton buttonWithType: UIButtonTypeRoundedRect];
		stopSpin.frame = CGRectMake(400.0, 20.0, 80.0, 60.0);
		[stopSpin setTitle:@"Stop" forState: UIControlStateNormal];	
		[stopSpin addTarget:self action:@selector(doStop:) forControlEvents:UIControlEventTouchDown];
		[view addSubview:stopSpin];
		 */
		
		// Invisible spin button
		//
		self.spinButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.spinButton.frame = CGRectMake(0.0, 0.0, 150.0, 150.0);
		// Uncomment to see the magic invisible button. It's there in case we lose
		// communication between devices.
		//
		//self.spinButton.backgroundColor = [UIColor greenColor];

		[self.spinButton addTarget:self action:@selector(doSpin:) forControlEvents:UIControlEventTouchDown];
		[self.view addSubview:self.spinButton];
		
		self.view.userInteractionEnabled = YES;
		_count = 0;
		[self.wheel setWheelTo:_count startAt:-1 animate:NO];
    }
    return self;
}

- (IBAction) moveDown:(id)sender
{
	if (_count < 9)
		_count++;
	else
		_count = 0;
	
	[self.wheel setWheelTo:_count startAt:-1 animate:YES];
}
	 
- (IBAction) moveUp:(id)sender
{
	if (_count > 0)
		_count--;
	else
		_count = 9;

	[self.wheel setWheelTo:_count startAt:-1 animate:YES];
}

- (IBAction) doSpin:(id)sender
{
	[self.wheel spinWheel:-1];
}

- (IBAction) doSpinForever:(id)sender
{
	[self.wheel spinWheel:(int) FLT_MAX];
}

- (IBAction) doStop:(id)sender
{
	[self.wheel stopWheel];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
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
    self.wheel = nil;
    self.spinButton = nil;
    [super dealloc];
}

@synthesize wheel = _wheel;
@synthesize count = _count;
@synthesize spinButton = _spinButton;

@end
