//
//  ApplicationDelegate.h
//  iPadSlotMachine
//
//  Created by Tim Burks on 4/16/10.
//

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

@class Motion;

@interface ApplicationDelegate : NSObject <GKSessionDelegate> {
	UIWindow *window;
	int applicationRole;
	BOOL is_iPad;
	
	Motion *motion;
	GKSession *session;
	
	// Peer IDs
	NSString *masterID;
	NSString *slaveHandleID;
	NSString *slaveHopperID;
	NSMutableArray *slaveReels;
	
	// external display
	UIWindow *externalWindow;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, assign) int applicationRole;
@property (nonatomic, assign) BOOL is_iPad;
@property (nonatomic, retain) Motion *motion;

@property (nonatomic, retain) GKSession *session;

@property (nonatomic, retain) NSString *masterID;
@property (nonatomic, retain) NSString *slaveHandleID;
@property (nonatomic, retain) NSString *slaveHopperID;
@property (nonatomic, retain) NSMutableArray *slaveReels;

@property (nonatomic, retain) UIWindow *externalWindow;

@end

// Global. Could be a singleton if you prefer. :)
extern ApplicationDelegate *DELEGATE;
