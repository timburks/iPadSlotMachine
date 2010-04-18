//
//  MasterViewController.m
//  iPadSlotMachine
//
//  Created by Tim Burks on 4/17/10.
//

#import "MasterViewController.h"
#import "ApplicationDelegate.h"

@implementation MasterViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	self.view = [[[UIView alloc]
				  initWithFrame:[[UIScreen mainScreen] applicationFrame]]
				 autorelease];
	self.view.backgroundColor = [UIColor clearColor];
	UIButton *startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[startButton setTitle:@"Start" forState:UIControlStateNormal];
	[startButton addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
	startButton.frame = CGRectMake(100,300,768-200,1024-600);
	[self.view addSubview:startButton];
}

- (void) start:(id) sender {
	NSLog(@"START PRESSED");
	[DELEGATE sendMessageToReels];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
