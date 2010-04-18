//
//  WheelSpinner.h
//  SpinWheel
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol WheelSpinnerDelegate
- (void) SpinningEndedAt:(NSUInteger)number;
@end

@interface WheelSpinner : UIImageView 
{
	id<NSObject, WheelSpinnerDelegate> _spinDelegate;
	NSUInteger			_currentPosition;
	NSUInteger			_maxTimeout;
	NSUInteger			_currentSpin;
	CGRect				_currentDisplayRect;
	CGFloat				_heightOffsetCoordinate;
	CABasicAnimation*	_spinAnimation;
	UIImageView*		_glossLayer;
	NSUInteger			_spinMax;
	NSUInteger			_spinCount;
	NSUInteger			_maxImages;
	NSUInteger			_maxImageIndex;
	NSUInteger			_finalCounter;
	BOOL				_stopSpin;
}

@property (nonatomic, assign) id<NSObject, WheelSpinnerDelegate> spinDelegate;
@property (nonatomic, assign) NSUInteger currentPosition;
@property (nonatomic, assign) NSUInteger maxTimeout;
@property (nonatomic, assign) NSUInteger currentSpin;
@property (nonatomic, assign) CGRect currentDisplayRect;
@property (nonatomic, assign) CGFloat heightOffsetCoordinate;
@property (nonatomic, retain) CABasicAnimation *spinAnimation;
@property (nonatomic, retain) IBOutlet UIImageView *glossLayer;
@property (nonatomic, assign) NSUInteger spinMax;
@property (nonatomic, assign) NSUInteger spinCount;
@property (nonatomic, assign) NSUInteger maxImages;
@property (nonatomic, assign) NSUInteger maxImageIndex;

- (void) setWheelTo:(NSUInteger)position startAt:(NSInteger)startAt animate:(BOOL)animate;
- (void) spinWheel:(NSInteger)count;
- (void) stopWheel;

@end
