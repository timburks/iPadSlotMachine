//
//  ApplicationDelegate.m
//  iPadSlotMachine
//
//  Created by Tim Burks on 4/16/10.
//

#import "ApplicationDelegate.h"
#import "Motion.h"

ApplicationDelegate *DELEGATE;

// connection timeouts
#define TIMEOUT 60

@implementation ApplicationDelegate
@synthesize window, applicationRole, is_iPad;
@synthesize motion;
@synthesize session;
@synthesize masterID, slaveHandleID, slaveHopperID, slaveReels;

UIAlertView *roleChooserAlert; 
AVAudioPlayer *soundPlayer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	DELEGATE = self;
	
	UIDevice *device = [UIDevice currentDevice];
	if ([device respondsToSelector:@selector(userInterfaceIdiom)]) {
		self.is_iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == 1);
	} else {
		self.is_iPad = NO;
	}
	
	self.slaveReels = [NSMutableArray array];
	
	CGRect mainBounds = [[UIScreen mainScreen] bounds];
	self.window = [[[UIWindow alloc] initWithFrame:mainBounds] autorelease];
	self.window.backgroundColor = [UIColor blueColor]; // confirm we've got it
	
	self.motion = [[[Motion alloc] init] retain];
    [window addSubview:motion];
	[self.motion becomeFirstResponder];
	
	// display role chooser
	roleChooserAlert = [[[UIAlertView alloc]
						 initWithTitle:@"iPad Slot Machine"
						 message:@"Let's get started!"
						 delegate:self
						 cancelButtonTitle:@"Join Existing"
						 otherButtonTitles:@"Create New", nil]
						autorelease];
	[roleChooserAlert show];
	
	[self.window makeKeyAndVisible];

	// play a sound on startup
	NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"StartingGate" ofType:@"wav"]];
	NSError *error;
	if (!soundPlayer) {
		soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
	}
	[soundPlayer play];
	AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
	
	return YES;
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
	if (alertView == roleChooserAlert) {
		self.applicationRole = (buttonIndex == 0) ? SlotMachineApplicationRoleSlaveSearching : SlotMachineApplicationRoleMaster;
		[self startConnection];
	}
}

- (void) startConnection {
	if (self.applicationRole == SlotMachineApplicationRoleMaster) {
		self.session = [[[GKSession alloc] initWithSessionID:@"iPadSlotMachine" 
												 displayName:[[UIDevice currentDevice] uniqueIdentifier]
												 sessionMode:GKSessionModeServer] autorelease];
	} else {
		self.session = [[[GKSession alloc] initWithSessionID:@"iPadSlotMachine" 
												 displayName:[[UIDevice currentDevice] uniqueIdentifier]
												 sessionMode:GKSessionModeClient] autorelease];
	}
	self.session.available = YES;
	self.session.delegate = self;
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
	UIAlertView *alert = [[[UIAlertView alloc]
						   initWithTitle:@"Received request from" message:peerID delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
						  autorelease];
	[alert show];
	
	NSError *error;
	[session acceptConnectionFromPeer:peerID error:&error];
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state 
{
	UIAlertView *alert = [[[UIAlertView alloc]
						   initWithTitle:@"Peer did change state" 
						   message:[NSString stringWithFormat:@"Peer: %@ State:%d", peerID, state]
						   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
						  autorelease];
	[alert show];
	
	if (self.applicationRole == SlotMachineApplicationRoleMaster) {
		// handle connections for master
		
		// when a peer has connected, we need to assign it a role and then send that role to the peer.
		
		
	} else {
		
		// handle connections for slave
		if (state == GKPeerStateAvailable) {
			[session connectToPeer:peerID withTimeout:TIMEOUT];
		}
	}
}


@end
