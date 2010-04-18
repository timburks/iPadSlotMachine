//
//  ApplicationDelegate.h
//  iPadSlotMachine
//
//  Created by Tim Burks on 4/16/10.
//

#import "HandleViewController.h"
#import "WheelSpinner.h"

typedef enum  {
	SlotMachineApplicationRoleUnknown,
	SlotMachineApplicationRoleMaster,
	SlotMachineApplicationRoleSlaveSearching,
	SlotMachineApplicationRoleSlaveHandle,
	SlotMachineApplicationRoleSlaveHopper,
	SlotMachineApplicationRoleSlaveReel0,
	SlotMachineApplicationRoleSlaveReel1,
	SlotMachineApplicationRoleSlaveReel2,
	SlotMachineApplicationRoleMax
} SlotMachineApplicationRoleType;

@class MasterViewController;
@class SpinWheelViewController;
@class SlotMachineHopperViewController;
@class HandleViewController;

@interface ApplicationDelegate : NSObject <GKSessionDelegate, HandleViewControllerDelegate, WheelSpinnerDelegate> {
	UIWindow *window;
	int applicationRole;
	BOOL is_iPad;
	
	GKSession *session;
	
	// Peer IDs
	NSString *masterID;
	NSString *slaveHandleID;
	NSString *slaveHopperID;
	NSMutableArray *slaveReels;
	NSMutableArray *slaveScores;
	
	// external display
	UIWindow *externalWindow;
	
	// view controllers
	MasterViewController *masterViewController;
	SpinWheelViewController *spinWheelViewController;
	SlotMachineHopperViewController *slotMachineHopperViewController;
	HandleViewController *handleViewController;
	
	int numberOfReelsCurrentlySpinning;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, assign) int applicationRole;
@property (nonatomic, assign) BOOL is_iPad;

@property (nonatomic, retain) GKSession *session;

@property (nonatomic, retain) NSString *masterID;
@property (nonatomic, retain) NSString *slaveHandleID;
@property (nonatomic, retain) NSString *slaveHopperID;
@property (nonatomic, retain) NSMutableArray *slaveReels;
@property (nonatomic, retain) NSMutableArray *slaveScores;

@property (nonatomic, retain) UIWindow *externalWindow;

@property (nonatomic, retain) MasterViewController *masterViewController;
@property (nonatomic, retain) SpinWheelViewController *spinWheelViewController;
@property (nonatomic, retain) SlotMachineHopperViewController *slotMachineHopperViewController;
@property (nonatomic, retain) HandleViewController *handleViewController;

@property (nonatomic, assign) int numberOfReelsCurrentlySpinning;

- (void) sendMessage:(NSString *) message toPeer:(NSString *) peerID;
- (void) sendMessageToReels:(NSString *) message;

@end

// Global. Could be a singleton if you prefer. :)
extern ApplicationDelegate *DELEGATE;
