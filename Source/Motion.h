
typedef enum  {
	SlotMachineMotionTypeUnknown,
	SlotMachineMotionTypeCalibrating,
	SlotMachineMotionTypeListening,
	SlotMachineMotionTypeTriggering,
	SlotMachineMotionTypeTriggered
} SlotMachineMotionType;

@protocol MotionDelegate <NSObject>
- (void)motionTriggered:(id)sender;
@end

@interface Motion : UIView <UIAccelerometerDelegate> {
	id<MotionDelegate> delegate;
    UIAccelerationValue accelerationX;
    UIAccelerationValue accelerationY;
    UIAccelerationValue accelerationZ;	
	SlotMachineMotionType motionState;
	NSTimeInterval motion;
	NSTimer *durationTimer;
	NSMutableArray *calibrationReadings;
	CGFloat baselineAcceleration;
}

@property (nonatomic, assign) id<MotionDelegate> delegate;
@property (nonatomic, retain) NSTimer *durationTimer;
@property (nonatomic, retain) NSMutableArray *calibrationReadings;

- (void)startMotionDetectionWithDelegate:(id)motionDelegate;
- (void)stopMotionDetection;

@end
