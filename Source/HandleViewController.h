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
	AVAudioPlayer *soundPlayer;
	IBOutlet UIButton *handleButton;
}

@property (nonatomic, retain) Motion *motionDetector;
@property (nonatomic, retain) UIButton *handleButton;

- (IBAction)buttonPressed:(id)sender;

@end
