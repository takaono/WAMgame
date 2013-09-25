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

@synthesize AppearState = appearState_;

-(id)init
{
    if((self=[super init]))
    {
        self.touchEnabled=YES;
        self.contentSize = CGSizeMake(50, 60);
        appearState_ = sHidden;
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
        self.anchorPoint = ccp(0.5, 1.0);
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
        //GamePlayLayer *game = (GamePlayLayer*)[self parent];
        //[game incrementScore];
		if(appearState_ == sAppear && !onHit_)
		{
			onHit_ = YES;
			GamePlayLayer *game = (GamePlayLayer*)[self parent];
			[game incrementScore];
			//成功アクションの実行
			[self successAction];
		}
	}
}


-(void)runPeepAction
{
	//レベルによってこの時間を調整すれば、出現頻度、出現時間が変わる
	waitingTime_ = CCRANDOM_0_1()*3 + 0.5; //0.5～3.5秒間の待機時間を生成
	actionTime_ = CCRANDOM_0_1()*1.5 + 0.5; //0.5～2秒間のアクションタイムを生成
	
	currentWait_ = 0;
    appearState_ = sStandBy;
    
	[self schedule:@selector(scheduleActionBegin:)];
}


-(void)scheduleActionBegin:(ccTime)dlt
{
	currentWait_ += dlt;
	
	if(currentWait_ > waitingTime_)
	{
		onHit_ = NO;
        
        GamePlayLayer *game = (GamePlayLayer*)[self parent];
        
        int appearCount = [game countActiveMoles];
        
        if(appearCount < game.MaxActiveNum)
        {
            [self startAction];
        }
		[self unschedule:_cmd];
	}
}


-(void)startAction
{
    srandom(time(NULL));
    
	//ランダムで出現エフェクトを決定　int 0-3
    float randnum = CCRANDOM_0_1()*3;
	int effectType = (int)randnum % 3;
    NSLog(@"type: %d", effectType);
    
	appearState_ = sAppear;
    
    float randY = CCRANDOM_0_1() * 20;
    float randUp = CCRANDOM_0_1() * 0.2 + 0.3;
    float randDown = CCRANDOM_0_1() * 0.2 + 0.3;
	
	float moveY = 20 + randY;
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
            
			easeUp = [CCEaseSineIn actionWithAction:up];
			easeDown = [CCEaseSineIn actionWithAction:down];
			
			break;
			
		case 2:
            
			easeUp = [CCEaseExponentialIn actionWithAction:up];
			easeDown = [CCEaseExponentialIn actionWithAction:down];
			
			break;
			
		default:
            
			easeUp = [CCEaseIn actionWithAction:up rate:5];
			easeDown = [CCEaseIn actionWithAction:down rate:5];
			
			break;
	}
	
	CCCallBlock *block = [CCCallBlock actionWithBlock:^{ appearState_ = sHidden; }];
	
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
	CCCallBlock *block = [CCCallBlock actionWithBlock:^{ appearState_ = sHidden; }];
	
	CCSequence *seq = [CCSequence actions:easeDown, block, nil];
    
    [self runAction:seq];
}


-(void)backToOriginAction
{
    appearState_ = sHidden;
    
    CCMoveTo *moveBack = [CCMoveTo actionWithDuration:0.3 position:originalPos_];
    CCEaseOut *easeDown = [CCEaseOut actionWithAction:moveBack rate:5];
    [self runAction:easeDown];
}

@end
