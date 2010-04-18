//
//  HandleViewController.m
//  iPadSlotMachine
//
//  Created by Aleksey Novicov on 4/17/10.
//

#import "HandleViewController.h"
#import "ApplicationDelegate.h"

@implementation HandleViewController

@synthesize motionDetector, handleButton;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	Motion *detector = [[Motion alloc] init];
	self.motionDetector = detector;
	
	[detector autorelease];
}


- (void)viewDidUnload {
	self.handleButton = nil;
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
	[handleButton release];
	[motionDetector release];
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
	
	// Play sound
	NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pullhandle" ofType:@"wav"]];
	NSError *error;
	if (!soundPlayer) {
		soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
	}
	[soundPlayer play];
	
	// Animate the button for feedback
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.35];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didAnimateButton:finished:context:)];
	[handleButton setTransform:CGAffineTransformMakeScale(2.0, 2.0)];
	[UIView commitAnimations];
}


- (void)didAnimateButton:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.35];
	[handleButton setTransform:CGAffineTransformIdentity];
	[UIView commitAnimations];
}


@end
