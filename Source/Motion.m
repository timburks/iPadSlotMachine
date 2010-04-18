//
//  Motion.m
//  AcceleratorTest
//
//  Created by Warren Stringer on 4/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Motion.h"

#define UPDATE_FREQUENCY		30						// Hz
#define LOWPASS_FILTER_FACTOR	0.12
#define CALIBRATION_DURATION	1.0
#define TRIGGER_DURATION		1.0

@implementation Motion

@synthesize delegate;
@synthesize calibrationReadings;
@dynamic durationTimer;


- (void)startMotionDetectionWithDelegate:(id)motionDelegate {
	self.delegate = motionDelegate;

	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / UPDATE_FREQUENCY)];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	
	// Not sure if accelerometer readings vary device to device.
	// So will calibrate by determining a baseline reading, assuming
	// device
	self.calibrationReadings = [NSMutableArray arrayWithCapacity:30];
	self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:CALIBRATION_DURATION target:self selector:@selector(didFinishCalibrating:) userInfo:nil repeats:NO];
	motionState = SlotMachineMotionTypeCalibrating;
}


- (void)stopMotionDetection {
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
	self.durationTimer = nil;
	self.calibrationReadings = nil;
}


#pragma mark -
#pragma mark Timer Methods

- (NSTimer *)durationTimer {
	return durationTimer;
}	


-(void)setDurationTimer:(NSTimer *)newTimer {
	if (durationTimer != newTimer) {
		[durationTimer invalidate];
		[durationTimer release];
		
		durationTimer = [newTimer retain];
	}
}


- (void)didFinishCalibrating:(NSTimer *)timer {
	if (motionState == SlotMachineMotionTypeCalibrating) {
		// Determine an average baseline calibration value
		CGFloat total;
		for (NSNumber *calibration in calibrationReadings)
			total += [calibration floatValue];
	
		baselineAcceleration = total / [calibrationReadings count];
		NSLog(@"calibrated threshold = %1.4f", baselineAcceleration);

		motionState = SlotMachineMotionTypeListening;
	}
}


- (void)didFinishWaitingForTrigger:(NSTimer *)timer {
	motionState = SlotMachineMotionTypeListening;
}


#pragma mark -
#pragma mark UIAccelerometer Delegate

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    // Simple high pass filter
    accelerationX = acceleration.x - (acceleration.x * LOWPASS_FILTER_FACTOR + accelerationX * (1.0 - LOWPASS_FILTER_FACTOR));
    accelerationY = acceleration.y - (acceleration.y * LOWPASS_FILTER_FACTOR + accelerationY * (1.0 - LOWPASS_FILTER_FACTOR));
    accelerationZ = acceleration.z - (acceleration.z * LOWPASS_FILTER_FACTOR + accelerationZ * (1.0 - LOWPASS_FILTER_FACTOR));
	
	CGFloat magnitude = sqrt(pow(accelerationX,2) + pow(accelerationY,2) + pow(accelerationZ,2));
	//NSLog(@"accel = %1.4f", magnitude);
	
	switch (motionState) {
		case SlotMachineMotionTypeCalibrating:
			[calibrationReadings addObject:[NSNumber numberWithFloat:magnitude]];
			break;
			
		case SlotMachineMotionTypeListening:
			if (magnitude > baselineAcceleration*2) {
				self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:TRIGGER_DURATION target:self selector:@selector(didFinishWaitingForTrigger:) userInfo:nil repeats:NO];
				motionState = SlotMachineMotionTypeTriggering;
			}
			break;
		
		case SlotMachineMotionTypeTriggering:
			if (magnitude > baselineAcceleration*2) {
				if ([delegate respondsToSelector:@selector(motionTriggered:)]) {
					[delegate motionTriggered:self];
				}
				motionState = SlotMachineMotionTypeTriggered;
			}
			break;
			
		default:
			break;
	}
}

@end
