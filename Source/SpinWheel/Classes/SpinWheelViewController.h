//
//  SpinWheelViewController.h
//  SpinWheel
//

#import <UIKit/UIKit.h>
#import "WheelSpinner.h"

@interface SpinWheelViewController : UIViewController 
{
	WheelSpinner*	_wheel;
	int				_count;
	UIButton*		_spinButton;
	NSInteger		_spinCount;
}

@property (nonatomic, retain) IBOutlet WheelSpinner *wheel;
@property (nonatomic, assign) int count;
@property (nonatomic, retain) IBOutlet UIButton *spinButton;

- (IBAction) doSpin:(id)sender;
- (IBAction) doSpinForever:(id)sender;
- (IBAction) doStop:(id)sender;

@end

