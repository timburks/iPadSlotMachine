//
//  SpinWheelAppDelegate.h
//  SpinWheel
//

#import <UIKit/UIKit.h>

@class SpinWheelViewController;

@interface SpinWheelAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SpinWheelViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SpinWheelViewController *viewController;

@end

