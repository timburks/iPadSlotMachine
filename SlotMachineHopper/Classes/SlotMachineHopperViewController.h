//
//  SlotMachineHopperViewController.h
//  SlotMachineHopper
//
//  Created by Andrew Dudney on 4/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
	SlotMachineHopperWinSizeLose = 0,
	SlotMachineHopperWinSizeWin,
	SlotMachineHopperWinSizeBigWin,
	SlotMachineHopperWinSizeJackpot
} SlotMachineHopperWinSize;

@interface SlotMachineHopperViewController : UIViewController {
}

- (void) dropCoins:(SlotMachineHopperWinSize) prize;	
@end

