//
//  MoleObject.m
//  WhackAMole
//
//  Created by T.ONO.
//  Copyright 2013 T.ONO. All rights reserved.
//

#import "MoleObject.h"
#import "GamePlayLayer.h"


@implementation MoleObject

@synthesize OnAppear = onAppear_;

-(id)init
{
    if((self=[super init]))
    {
        self.touchEnabled=YES;
        self.contentSize = CGSizeMake(50, 60);
        onAppear_ = NO;
		onHit_ = NO;
        
        self.ignoreAnchorPointForPosition = NO;
        
        CCSprite *moleImg = [CCSprite spriteWithFile:@"sample01.png"];
        
        [self addChild:moleImg];
        
        moleImg.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    }
    
    return self;
}


-(id)initWithPosition:(CGPoint)pos
{
    if((self = [self init]))
    {
        self.position = pos;
		originalPos_ = pos;
    }
    return self;
}


-(void) dealloc
{
    [super dealloc];
}


-(void)onEnter
{
    [super onEnter];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}


-(void)onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}



-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchPos = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
    
    return CGRectContainsPoint(self.boundingBox, touchPos);
}


-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	if(touch.tapCount > 0)
	{
        NSLog(@"Tap");
        GamePlayLayer *game = (GamePlayLayer*)[self parent];
        [game incrementScore];
//		if(onAppear_ && !onHit_)
//		{
//			onHit_ = YES;
//			GamePlayLayer *game = (GamePlayLayer*)[self parent];
//			[game incrementScore];
//			//成功アクションの実行
//			[self successAction];
//		}
	}
}


-(void)scheduleActionBegin:(ccTime)dlt
{
	currentWait_ += dlt;
	
	if(currentWait_ > waitingTime_)
	{
		onHit_ = NO;
		[self startAction];
		[self unschedule:_cmd];
	}
}


-(void)startAction
{
	//ランダムで出現エフェクトを決定　int 0-3
	int effectType = (int)CCRANDOM_0_1() * 4 % 4;
    NSLog(@"type: %d", effectType);
	onAppear_ = YES;
    
    float randY = CCRANDOM_0_1() * 20;
    float randUp = CCRANDOM_0_1() * 0.2 + 0.3;
    float randDown = CCRANDOM_0_1() * 0.2 + 0.3;
	
	float moveY = 40 + randY;
	float upTime = actionTime_ * randUp;
	float downTime = actionTime_ * randDown;
	float delayTime = actionTime_ - upTime - downTime;
	
	CCMoveBy *up = [CCMoveBy actionWithDuration:upTime position:ccp(0.0, moveY)];
	CCMoveTo *down = [CCMoveTo actionWithDuration:downTime position:originalPos_];
	CCDelayTime* delay = [CCDelayTime actionWithDuration:delayTime];
	
	id easeUp;
	id easeDown;
	
	switch(effectType)
	{
		case 0:
            
			easeUp = [CCEaseIn actionWithAction:up rate:5];
			easeDown = [CCEaseIn actionWithAction:down rate:5];
			
			break;
			
		case 1:
            
			easeUp = [CCEaseIn actionWithAction:up rate:5];
			easeDown = [CCEaseIn actionWithAction:down rate:5];
			
			break;
			
		case 2:
            
			easeUp = [CCEaseIn actionWithAction:up rate:5];
			easeDown = [CCEaseIn actionWithAction:down rate:5];
			
			break;
			
		case 3:
            
			easeUp = [CCEaseIn actionWithAction:up rate:5];
			easeDown = [CCEaseIn actionWithAction:down rate:5];
			
			break;
			
		default:
            
			easeUp = [CCEaseIn actionWithAction:up rate:5];
			easeDown = [CCEaseIn actionWithAction:down rate:5];
			
			break;
	}
	
	CCCallBlock *block = [CCCallBlock actionWithBlock:^{ onAppear_ = NO; }];
	
	CCSequence* seq = [CCSequence actions:easeUp, delay, easeDown, block, nil];
	
	seq.tag = tPeepAct;
	
	[self runAction:seq];
}


-(void)successAction
{
	[self stopActionByTag:tPeepAct];
	
	//画像の変更
	CCMoveTo *moveBack = [CCMoveTo actionWithDuration:0.5 position:originalPos_];
	CCEaseOut *easeDown = [CCEaseOut actionWithAction:moveBack rate:5];
	CCCallBlock *block = [CCCallBlock actionWithBlock:^{ onAppear_ = NO; }];
	
	CCSequence *seq = [CCSequence actions:easeDown, block, nil];
    
    [self runAction:seq];
}


@end
