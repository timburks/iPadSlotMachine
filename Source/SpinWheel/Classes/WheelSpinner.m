//
//  WheelSpinner.m
//  SpinWheel
//

#import "WheelSpinner.h"
#import <QuartzCore/QuartzCore.h>
#include "math.h"

//#define USENUMBERS	1

#ifdef USENUMBERS
#define IMAGESTRIP	@"imagestrip.png"
#define IMAGEGLOSS	@"imagegloss.png"
#define IMAGESINSTRIP			10
#else
#define IMAGESTRIP	@"longstrip.png"
#define IMAGEGLOSS	@"SlotMachine.png"
#define IMAGESINSTRIP			5
#endif


#define VIEWPORTINCREMENT	(1.0 / (CGFloat) IMAGESINSTRIP)
#define MAXROTATION			4
#define MINROTATION			2

@implementation WheelSpinner


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
        // Initialization code
		//
		_spinDelegate = nil;
		_stopSpin = NO;
		_spinning = NO;
		self.maxImages = IMAGESINSTRIP;
		self.maxImageIndex = IMAGESINSTRIP-1;
		//self.backgroundColor = [UIColor greenColor];
		
		self.image = [UIImage imageNamed:IMAGESTRIP];
		self.glossLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGEGLOSS]];
		self.glossLayer.backgroundColor = [UIColor clearColor];
		[self addSubview:self.glossLayer];
		self.contentMode = UIViewContentModeTopLeft;
		self.currentPosition = 0;
		self.maxTimeout = 30;
		self.currentSpin = 0;
		self.spinAnimation = [CABasicAnimation animationWithKeyPath:@"contentsRect"];
		self.spinAnimation.removedOnCompletion = NO;
		self.spinAnimation.fillMode = kCAFillModeForwards;
		self.spinAnimation.duration = 1.0;
		self.spinAnimation.delegate = self;
		self.currentDisplayRect = CGRectMake(0.0, 0.0, 1.0, VIEWPORTINCREMENT);		
		self.layer.contentsRect = self.currentDisplayRect;

    }
    return self;
}

// Starts at 0
//
- (void) setWheelTo:(NSUInteger)position startAt:(NSInteger)startAt animate:(BOOL)animate
{
	_spinning = YES;
	
	// If we've reached the bottom of the strip, we turn off animated value changes,
	// step the displayrect back up to the top and re-enable animations.
	//
	if (self.currentPosition == (self.maxImageIndex) && position == 0 && !animate) {
		[CATransaction setDisableActions:YES];
		self.currentDisplayRect = CGRectMake(0.0, 0.0, 1.0, VIEWPORTINCREMENT);
		self.layer.contentsRect = self.currentDisplayRect;
		[CATransaction setDisableActions:NO];
	} else 
		// This one's for when going backwards...
		if (self.currentPosition == 0 && position == (self.maxImageIndex) && !animate) {
			[CATransaction setDisableActions:YES];
			self.currentDisplayRect = CGRectMake(0.0, 0.9, 1.0, VIEWPORTINCREMENT);
			self.layer.contentsRect = self.currentDisplayRect;
			[CATransaction setDisableActions:NO];
	}
	
	
	if (startAt >= 0) {
		[CATransaction setDisableActions:YES];
		self.currentDisplayRect = CGRectMake(0.0, (startAt*VIEWPORTINCREMENT), 1.0, VIEWPORTINCREMENT);
		self.layer.contentsRect = self.currentDisplayRect;
		[CATransaction setDisableActions:NO];
	}		
	
	CGRect newDisplayRect = CGRectMake(0.0, (position)*VIEWPORTINCREMENT, 1.0, VIEWPORTINCREMENT);
	self.spinAnimation.fromValue = [NSValue valueWithCGRect:self.currentDisplayRect];
	self.spinAnimation.toValue = [NSValue valueWithCGRect:newDisplayRect];	
	//	self.spinAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	[self.layer addAnimation:self.spinAnimation forKey:nil];
	self.currentDisplayRect = newDisplayRect;
	self.currentPosition = position;
}

// Called when each animation has concluded. It will either fire off another one or 
// stop and clean up. If done, it calls back the delegate and tells it what
// number it ended up with.

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
	NSInteger stopCount = 0;

	// Let's ignore coreanimation completions for other elements in the UI.
	//
	if (!_spinning)
		return;
	
	if (self.spinCount >= self.spinMax && finished) {
		CALayer *layer = self.layer;
		NSString *path = [self.spinAnimation keyPath];
		[layer setValue:[self.spinAnimation toValue] forKeyPath:path];
		[layer removeAnimationForKey:path];

		// Notify the delegate we're done and return the number we came up with (between 0 < imageCount).
		//
		
		if (_spinDelegate)
			[_spinDelegate SpinningEndedAt:_finalCounter];
	} else {
		// On any complete spin that's past the first one but not the last one, we do linear animation.
		//
		if (_spinMax > 0 && self.spinCount < self.spinMax-1) {
			self.spinAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
			stopCount = self.maxImageIndex;
			
		} else {
			// On the very last spin, we stop at the pre-determined value and do an ease-out animation.
			//
			stopCount = _finalCounter;
			self.spinAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
		}
		self.spinCount++;
		[self setWheelTo:stopCount startAt:0 animate:NO];
	}
}

- (void) spinWheel:(NSInteger)count
{
	_spinning = YES;
	
	// We try to randomize the duration of the animation slightly.
	// The base animation for running a whole strip from top to bottom is 1 second.
	// We create a random number between 1 and 20. If it's less than 10, we deduct
	// 1/100 sec * number from the baseline. If it's more than 10, we add to it (to slow it down).
	// 
	
	BOOL slower = NO;
	NSInteger durationSeed = (int) random() % 20;
	if (durationSeed > 10)
		slower = YES;
	
	CGFloat adder = (CGFloat) durationSeed / 100.0;
	CGFloat newDuration = slower ? 1.0 + adder : 1.0 - adder;
	self.spinAnimation.duration = newDuration;
	
	if (count <= 0) {
		self.spinMax = (int) (random() % MAXROTATION);
		if (self.spinMax < MINROTATION)
			self.spinMax = MINROTATION;
	} else
		self.spinMax = count;
	
	self.spinCount = 0;
	_finalCounter = (int) (random() % IMAGESINSTRIP);

	self.spinAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	[self setWheelTo:self.maxImageIndex startAt:-1 animate:YES];
}

- (void) stopWheel
{
	_stopSpin = YES;
	self.spinCount = self.spinMax-1;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)dealloc {
    self.spinAnimation = nil;
    self.glossLayer = nil;
    [super dealloc];
}


@synthesize spinDelegate = _spinDelegate;
@synthesize currentPosition = _currentPosition;
@synthesize maxTimeout = _maxTimeout;
@synthesize currentSpin = _currentSpin;
@synthesize currentDisplayRect = _currentDisplayRect;
@synthesize heightOffsetCoordinate = _heightOffsetCoordinate;
@synthesize spinAnimation = _spinAnimation;
@synthesize glossLayer = _glossLayer;
@synthesize spinMax = _spinMax;
@synthesize spinCount = _spinCount;
@synthesize maxImages = _maxImages;
@synthesize maxImageIndex = _maxImageIndex;


@end
