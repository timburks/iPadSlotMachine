//
//  SMHView.h
//  SlotMachineHopper
//
//  Created by Andrew Dudney on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "SlotMachineHopperViewController.h"

@interface SMHView : UIView {
	CATextLayer *textLayer;
	NSMutableArray *coins;
	//SMHModel *model;
	IBOutlet SlotMachineHopperViewController *viewController;
	Byte coinCount;
	CALayer *backgroundLayer, *coinsLayer, *pileLayer, *frontLayer;
	int coinAmount;
}

- (void)beginCoinDrop:(SlotMachineHopperWinSize)size;
- (IBAction)action;

@end
