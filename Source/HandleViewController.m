//
//  HandleViewController.m
//  iPadSlotMachine
//
//  Created by Aleksey Novicov on 4/17/10.
//

#import "HandleViewController.h"
#import "ApplicationDelegate.h"

@implementation HandleViewController

@synthesize motionDetector;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	Motion *detector = [[Motion alloc] init];
	self.motionDetector = detector;
	
	[detector autorelease];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated {
	[self.motionDetector startMotionDetectionWithDelegate:self];
}


- (void)viewWillDisappear:(BOOL)animated {
	[self.motionDetector stopMotionDetection];
}


- (void)dealloc {
	[self.motionDetector release];
    [super dealloc];
}


- (IBAction)buttonPressed:(id)sender {
	if ([DELEGATE respondsToSelector:@selector(handleButtonPressed:)])
		[DELEGATE handleButtonPressed:self];
}


#pragma mark -
#pragma mark MotionDelegate

- (void)motionTriggered:(id)sender {
	if ([DELEGATE respondsToSelector:@selector(handlePulled:)])
		[DELEGATE handlePulled:self];
}


@end
