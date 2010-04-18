//
//  HandleViewController.h
//  iPadSlotMachine
//
//  Created by Aleksey Novicov on 4/17/10.
//

#import <UIKit/UIKit.h>
#import "Motion.h"

@protocol HandleViewControllerDelegate <NSObject>
- (void)handlePulled:(id)sender;
- (void)handleButtonPressed:(id)sender;
@end

@interface HandleViewController : UIViewController <MotionDelegate> {
	Motion *motionDetector;
}

@property (nonatomic, retain) Motion *motionDetector;

- (IBAction)buttonPressed:(id)sender;

@end
