//
//  Motion.m
//  AcceleratorTest
//
//  Created by Warren Stringer on 4/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Motion.h"


@implementation Motion

// must add [motion becomeFirstResponder] *after* adding this view to view hierarchy
// see MotionAppDelegate

-(BOOL) canBecomeFirstResponder {
    return YES;
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event { //__OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0)
    
    NSLog(@"%s",_cmd);
}
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {//__OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0) 

    NSLog(@"%s",_cmd);
}
-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {//__OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0);
    
    NSLog(@"%s",_cmd);
}

@end
