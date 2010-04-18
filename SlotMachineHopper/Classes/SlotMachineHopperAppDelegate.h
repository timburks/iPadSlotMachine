//
//  SlotMachineHopperAppDelegate.h
//  SlotMachineHopper
//
//  Created by Andrew Dudney on 4/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlotMachineHopperViewController;

@interface SlotMachineHopperAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SlotMachineHopperViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SlotMachineHopperViewController *viewController;

@end

