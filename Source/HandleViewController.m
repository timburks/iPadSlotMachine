//
//  HandleViewController.m
//  iPadSlotMachine
//
//  Created by Aleksey Novicov on 4/17/10.
//

#import "HandleViewController.h"
#import "ApplicationDelegate.h"

@implementation HandleViewController

@synthesize motionDetector, handleButton, handleBar;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	Motion *detector = [[Motion alloc] init];
	self.motionDetector = detector;
	
	[detector autorelease];
}


- (void)viewDidUnload {
	self.handleButton = nil;
	self.handleBar = nil;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated {
	[self.motionDetector startMotionDetectionWithDelegate:self];
	
	handleRect = handleBar.frame;
}


- (void)viewWillDisappear:(BOOL)animated {
	[self.motionDetector stopMotionDetection];
}


- (void)dealloc {
	[handleBar release];
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
	
	CGAffineTransform transform = CGAffineTransformMakeScale(2.0, 2.0);
	transform = CGAffineTransformTranslate(transform, 30, 30);
	[handleButton setTransform:transform];
	
	CGRect newRect = CGRectMake(handleRect.origin.x, handleRect.origin.y+30, handleRect.size.width+100, handleRect.size.height-30);
	handleBar.frame = newRect;
	
	[UIView commitAnimations];
}


- (void)didAnimateButton:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.35];
	[handleButton setTransform:CGAffineTransformIdentity];
	handleBar.frame = handleRect;
	[UIView commitAnimations];
}


@end
