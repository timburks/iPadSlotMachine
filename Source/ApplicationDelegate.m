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

@interface ApplicationDelegate (Internal)

- (void) addExternalDisplay:(UIScreen *) newScreen;
- (void) startConnection;

@end


@implementation ApplicationDelegate
@synthesize window, applicationRole, is_iPad;
@synthesize motion;
@synthesize session;
@synthesize masterID, slaveHandleID, slaveHopperID, slaveReels;
@synthesize externalWindow;

UIAlertView *roleChooserAlert; 
UIAlertView *componentChooserAlert;
AVAudioPlayer *soundPlayer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	DELEGATE = self;
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	
	UIDevice *device = [UIDevice currentDevice];
	if ([device respondsToSelector:@selector(userInterfaceIdiom)]) {
		self.is_iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == 1);
	} else {
		self.is_iPad = NO;
	}
	
	self.slaveReels = [NSMutableArray array];
	
	CGRect mainBounds = [[UIScreen mainScreen] bounds];
	self.window = [[[UIWindow alloc] initWithFrame:mainBounds] autorelease];
	
	UIImageView *backgroundView = [[[UIImageView alloc] 
									initWithImage:[UIImage imageNamed:@"MachineBackground.png"]] 
								   autorelease];
	backgroundView.frame = mainBounds;
	[window addSubview:backgroundView];
	backgroundView.contentMode = UIViewContentModeScaleAspectFill;
	
	self.motion = [[[Motion alloc] init] retain];
    [window addSubview:motion];
	[self.motion becomeFirstResponder];
	
	// display role chooser
	roleChooserAlert = [[UIAlertView alloc]
						initWithTitle:@"iPad Slot Machine"
						message:@"Let's get started!"
						delegate:self
						cancelButtonTitle:nil
						otherButtonTitles:@"Create New Machine", 
						@"Join Existing Machine", 
						@"Test Machine Components",
						nil];
	[roleChooserAlert show];
	
	[self.window makeKeyAndVisible];
	
	// watch for external screens
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(screenDidConnect:)
												 name:@"UIScreenDidConnectNotification"
											   object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(screenDidDisconnect:)
												 name:@"UIScreenDidDisconnectNotification"
											   object:nil];	
	if ([UIScreen respondsToSelector:@selector(screens)]) {
	NSArray *screens = [UIScreen screens];
		if ([screens count] > 1) {
			[self addExternalDisplay:[screens objectAtIndex:1]];
		}
	}
	
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

- (void) screenDidConnect:(NSNotification *) notification {
	NSLog(@"notification: %@", notification);
	UIScreen *newScreen = (UIScreen *) notification.object;
	[self addExternalDisplay:newScreen];
}

- (void) screenDidDisconnect:(NSNotification *) notification {
	NSLog(@"notification: %@", notification);
	UIScreen *oldScreen = (UIScreen *) notification.object;
	if (externalWindow && (externalWindow.screen == oldScreen)) {
		self.externalWindow = nil;
	}
}

- (void) addExternalDisplay:(UIScreen *) newScreen 
{
	NSArray *modes = newScreen.availableModes;
	NSLog(@"screen modes: %@", modes);
	newScreen.currentMode = [modes objectAtIndex:0];
	NSLog(@"selecting mode %@", newScreen.currentMode);
	
	self.externalWindow = [[[UIWindow alloc] 
							initWithFrame:[newScreen applicationFrame]]
						   autorelease];
	externalWindow.backgroundColor = [UIColor blueColor];
	externalWindow.screen = newScreen;
	[externalWindow makeKeyAndVisible];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
	NSLog(@"pressed %d", buttonIndex);
	if (alertView == roleChooserAlert) {
		switch (buttonIndex) {
			case 0: 
				self.applicationRole = SlotMachineApplicationRoleMaster;
				[self startConnection];
				break;
			case 1:
				self.applicationRole = SlotMachineApplicationRoleSlaveSearching;
				[self startConnection];
				break;
			default: {
				componentChooserAlert = [[[UIAlertView alloc]
										  initWithTitle:@"Test Machine Components"
										  message:@"Choose a Component"
										  delegate:self
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:@"Handle", 
										  @"Hopper", 
										  @"Reel", 
										  nil]
										 autorelease];
				[componentChooserAlert show];				
			}
		}
	} else if (alertView == componentChooserAlert) {
		if (buttonIndex == componentChooserAlert.cancelButtonIndex) {
			[roleChooserAlert show];
		} else {
			// switch to the appropriate component mode for test purposes
		}
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

- (void)session:(GKSession *)currentSession didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
	UIAlertView *alert = [[[UIAlertView alloc]
						   initWithTitle:@"Received request from" message:peerID delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
						  autorelease];
	[alert show];
	
	NSError *error;
	[currentSession acceptConnectionFromPeer:peerID error:&error];
}

- (void)session:(GKSession *)currentSession peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state 
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
			[currentSession connectToPeer:peerID withTimeout:TIMEOUT];
		}
	}
}


@end
