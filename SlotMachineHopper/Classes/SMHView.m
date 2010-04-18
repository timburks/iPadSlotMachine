//
//  SMHView.m
//  SlotMachineHopper
//
//  Created by Andrew Dudney on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMHView.h"
#import "SMHModel.h"
#import "SlotMachineHopperViewController.h"

@implementation SMHView


- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])){
    }
    return self;
}

- (void)awakeFromNib{
	
#pragma mark subLayers
	
	backgroundLayer = [CALayer layer];
	coinsLayer = [CALayer layer];
	pileLayer = [CALayer layer];
	frontLayer = [CALayer layer];
	
	//backgroundLayer.backgroundColor = [[UIColor blueColor] CGColor];
	//pileLayer.backgroundColor = [[UIColor greenColor] CGColor];
	//frontLayer.backgroundColor = [[UIColor orangeColor] CGColor];
	
	backgroundLayer.position = CGPointMake(512.0, 275.5);
	coinsLayer.position = CGPointMake(512.0, 192.0);
	pileLayer.position = CGPointMake(512.0, 568.0);
	frontLayer.position = CGPointMake(512.0, 659.5);
	
	backgroundLayer.bounds = CGRectMake(0.0, 0.0, 1024.0, 551.0);
	coinsLayer.bounds = CGRectMake(0.0, 0.0, 1024.0, 768.0);
	pileLayer.bounds = CGRectMake(0.0, 0.0, 824.0, 369.0);
	frontLayer.bounds = CGRectMake(0.0, 0.0, 1024.0, 217.0);
	
	backgroundLayer.contents = (id)[[UIImage imageNamed:@"ChestTopBackground.png"]CGImage];
	pileLayer.contents = (id)[[UIImage imageNamed:@"CoinGlow.png"]CGImage];
	frontLayer.contents = (id)[[UIImage imageNamed:@"ChestBottom.png"]CGImage];
	
	[self.layer addSublayer:backgroundLayer];
	[self.layer addSublayer:coinsLayer];
	[self.layer addSublayer:pileLayer];
	[self.layer addSublayer:frontLayer];
	
#pragma mark coins
	coins = [[NSMutableArray alloc] init];
	for (Byte i = 0; i < 100; i++) {
		CALayer *coinLayer = [CALayer layer];
		coinLayer.contents = (id)[[UIImage imageNamed:@"coin.png"]CGImage];
		coinLayer.bounds = CGRectMake(0.0, 0.0, 50.0, 50.0);
		coinLayer.position = CGPointMake((rand()%824)+100.0, -50.0);
		[coinsLayer addSublayer:coinLayer];
		[coins addObject:coinLayer];

		CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
		anim.duration = 2.0;
		//anim.timeOffset = ((rand()%10)+1.0)/5.0;
		anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
		anim.delegate = self;
		[anim setValue:coinLayer forKey:@"myLayer"];
		coinLayer.actions = [NSDictionary dictionaryWithObject:anim forKey:@"position"];

		[coinLayer release];
		coinLayer = nil;
	}
	
#pragma mark textLayer
	textLayer = [CATextLayer layer];
	textLayer.bounds = CGRectMake(0.0, 0.0, 1024.0, 190.0);
	textLayer.position = CGPointMake(512.0, 384.0);
	//textLayer.font = @"Chalkboard";
	textLayer.fontSize = 190.0;
	textLayer.alignmentMode = kCAAlignmentCenter;
	textLayer.string = @"";
	textLayer.foregroundColor = [[UIColor blackColor]CGColor];
	textLayer.backgroundColor = [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]CGColor];
	textLayer.transform = CATransform3DMakeScale(0.1, 0.1, 1.0);
	[self.layer addSublayer:textLayer];
}

- (IBAction)action{
	[self beginCoinDrop:jackpot];
}

- (void)beginCoinDrop:(winSize)size{
	switch (size) {
		case lose:
			coinCount = 0;
			textLayer.string = @"YOU LOSE.";
			break;
		case win:
			coinCount = 10;
			textLayer.string = @"You Win";
			break;
		case bigWin:
			coinCount = 30;
			textLayer.string = @"Big Win!";
			break;
		case jackpot:
			coinCount = 100;
			textLayer.string = @"JACKPOT!!";
			break;
		default:
			textLayer.string = @"";
			break;
	}
		
	CATransform3D scale0 = CATransform3DMakeScale(0.1, 0.1, 1.0);
	textLayer.transform = scale0;
	CATransform3D scale1 = CATransform3DMakeScale(1.5, 1.5, 1.0);
	CATransform3D scale2 = CATransform3DMakeScale(0.5, 0.5, 1.0);
	CATransform3D scale3 = CATransform3DMakeScale(1.3, 1.3, 1.0);
	CATransform3D scale4 = CATransform3DMakeScale(0.8, 0.8, 1.0);
	CATransform3D scale5 = CATransform3DMakeScale(1.2, 1.2, 1.0);
	CATransform3D scale6 = CATransform3DMakeScale(1.0, 1.0, 1.0);
	NSArray *scaleArray = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:scale0], [NSValue valueWithCATransform3D:scale1], [NSValue valueWithCATransform3D:scale2], [NSValue valueWithCATransform3D:scale3], [NSValue valueWithCATransform3D:scale4], [NSValue valueWithCATransform3D:scale5], [NSValue valueWithCATransform3D:scale6], nil];
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	animation.values = scaleArray;
	animation.duration = 2.0;	
	
	NSNumber *duration0 = [NSNumber numberWithFloat:0.0];
	NSNumber *duration1 = [NSNumber numberWithFloat:0.1];
	NSNumber *duration2 = [NSNumber numberWithFloat:0.2];
	NSNumber *duration3 = [NSNumber numberWithFloat:0.3];
	NSNumber *duration4 = [NSNumber numberWithFloat:0.5];
	NSNumber *duration5 = [NSNumber numberWithFloat:0.7];
	NSNumber *duration6 = [NSNumber numberWithFloat:1.0];
	
	NSArray *durationArray = [NSArray arrayWithObjects:duration0, duration1, duration2, duration3, duration4, duration5, duration6, nil];
	
	animation.keyTimes = durationArray;
	
	textLayer.actions = [NSDictionary dictionaryWithObject:animation forKey:@"transform"];
	textLayer.transform = scale6;
	
	//for(Byte x = 0; x < coinCount/10; x++){
		for(CALayer *coinLayer in coins) {
			NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:((float)(rand()%20)/10.0) target:self selector:@selector(moveLayer:) userInfo:[NSDictionary dictionaryWithObject:coinLayer forKey:@"layer"] repeats:YES];
			//coinLayer.position = CGPointMake(coinLayer.position.x, 768.0);
		}
	//}
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
	//static int thing;
	CALayer *coinLayer = [anim valueForKey:@"myLayer"];
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	srand(rand());
	coinLayer.position = CGPointMake((rand()%824)+100.0, -50.0);
	[CATransaction commit];
	pileLayer.position = CGPointMake(pileLayer.position.x, pileLayer.position.y-0.5);
	/*if(thing < coinCount){
		thing++;
		coinLayer.position = CGPointMake(coinLayer.position.x, 768.0);
	}*/
}

- (void)moveLayer:(NSTimer *)time{
	static int amount;
	CALayer *layer = [[time userInfo] objectForKey:@"layer"];
	layer.position = CGPointMake(layer.position.x, 768.0);
	amount++;
	if(amount > coinCount*1000){
		[time invalidate];
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)dealloc{
	[super dealloc];
	[coins release];
	coins = nil;
	[textLayer release];
	textLayer = nil;
	[backgroundLayer release];
	backgroundLayer = nil;
	[coinsLayer release];
	coinsLayer = nil;
	[pileLayer release];
	pileLayer = nil;
	[frontLayer release];
	frontLayer = nil;

}


@end
