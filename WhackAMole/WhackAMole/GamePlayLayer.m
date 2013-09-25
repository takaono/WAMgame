//
//  GamePlayLayer.m
//  WhackAMole
//
//  Created by T.ONO.
//  Copyright 2013 T.ONO. All rights reserved.
//

#import "GamePlayLayer.h"


@implementation GamePlayLayer

@synthesize GameLevel = gameLevel_;
@synthesize MaxActiveNum = maxActiveNum_;


+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    
    GamePlayLayer *layer = [GamePlayLayer node];
    
    [scene addChild: layer];
    
    return scene;
}


+(CCScene *) sceneWithLevel:(int)level
{
    CCScene *scene = [CCScene node];
    
    GamePlayLayer *layer = [[[self alloc] initWithLevel:level] autorelease];
    
    [scene addChild: layer];
    
    return scene;
}


-(id)init
{
    if((self=[super init]))
    {
        score_ = 0;
        
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        /*背景画像の設置*/
        CCSprite *bg0 = [CCSprite spriteWithFile:@"bg_sample01.png"];
		bg0.anchorPoint = ccp(0.5, 1.0);
        bg0.position = ccp(size.width / 2, size.height);
        [self addChild:bg0 z:tBg0];
        
        CCSprite *bg1 = [CCSprite spriteWithFile:@"bg_sample02.png"];
		bg1.anchorPoint = ccp(0.5, 0.0);
        bg1.position = ccp(size.width / 2, size.height / 2);
        [self addChild:bg1 z:tBg1];
        
        CCSprite *bg2 = [CCSprite spriteWithFile:@"bg_sample03.png"];
		bg2.anchorPoint = ccp(0.5, 1.0);
        bg2.position = ccp(size.width / 2, size.height / 2);
        [self addChild:bg2 z:tBg2];
        
        CCSprite *bg3 = [CCSprite spriteWithFile:@"bg_sample04.png"];
		bg3.anchorPoint = ccp(0.5, 0.0);
        bg3.position = ccp(size.width / 2, 0.0);
        [self addChild:bg3 z:tBg3];
        
        __block id copy_self = self;
        
        [CCMenuItemFont setFontSize:20];
		
        
        /*ゲーム終了後のシーン遷移用ラベルの生成と設置*/
		CCMenuItem *endLabel = [CCMenuItemFont itemWithString:@"Game End" block:^(id sender){
            [copy_self showGameResult:sender];
        }];
		
		CCMenu *menu = [CCMenu menuWithItems:endLabel, nil];
		menu.tag = tEndMenu;
        
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width / 2, 100)];
        menu.opacity = 0;
        menu.visible = NO; /*visibleをNOにしないとタップできてしまう*/
		
		[self addChild:menu z:tOrderGameEnd];
        
        
        /*スタートカウントダウン用ラベルの生成と設置*/
        CCLabelTTF *countDownLabel = [CCLabelTTF labelWithString:@"3" fontName:@"Marker Felt" fontSize:24];
        
        countDownLabel.position = ccp( size.width / 2, size.height / 2);
        countDownLabel.tag = tCountDown;
        countDownLabel.opacity = 0;
        countDownLabel.scale = 0;
        
        [self addChild: countDownLabel z:tOrderStartCount];
        
        /*制限時間用ラベルの生成と設置*/
        CCLabelTTF *mainTimerLabel = [CCLabelTTF labelWithString:@"60.0s" fontName:@"Marker Felt" fontSize:20];
        
        mainTimerLabel.position = ccp(10, size.height - 10);
        mainTimerLabel.tag = tMainTimer;
        mainTimerLabel.anchorPoint = ccp(0.0f, 1.0f);
        mainTimerLabel.visible = NO;
        
        [self addChild: mainTimerLabel z:tOrderTime];
        
        /*得点カウント用ラベルの生成と設置*/
        CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Marker Felt" fontSize:20];
        
        scoreLabel.position = ccp(size.width - 10, size.height - 10);
        scoreLabel.tag = tScoreLabel;
        scoreLabel.anchorPoint = ccp(1.0f, 1.0f);
        scoreLabel.visible = YES;
        
        [self addChild: scoreLabel z:tOrderScore];
        
        
        /*スタートボタン用ラベルの生成と設置*/
        CCMenuItem *startButton = [CCMenuItemFont itemWithString:@"Tap to start" block:^(id sender){
            [copy_self startCountDown:sender];
        }];
		
		CCMenu *startMenu = [CCMenu menuWithItems:startButton, nil];
        startMenu.tag = tStartMenu;
        
        [startMenu setPosition:ccp( size.width / 2, size.height / 2)];
		
		[self addChild:startMenu z:tOrderTap];
        
        /*モグラオブジェクトの生成と設置*/
        moleSet_ = [[CCArray alloc] initWithCapacity:5];
        MoleObject *mole0 = [[[MoleObject alloc] initWithPosition:ccp(size.width / 4, size.height / 2 + 110)] autorelease];
        [self addChild:mole0 z:tMole0];
        [moleSet_ addObject:mole0];
		
		MoleObject *mole1 = [[[MoleObject alloc] initWithPosition:ccp(size.width * 3 / 4, size.height / 2 + 110)] autorelease];
        [self addChild:mole1 z:tMole1];
        [moleSet_ addObject:mole1];
		
		MoleObject *mole2 = [[[MoleObject alloc] initWithPosition:ccp(size.width / 2, size.height / 2 + 10)] autorelease];
        [self addChild:mole2 z:tMole2];
        [moleSet_ addObject:mole2];
		
		MoleObject *mole3 = [[[MoleObject alloc] initWithPosition:ccp(size.width / 4, size.height / 2 - 90)] autorelease];
        [self addChild:mole3 z:tMole3];
        [moleSet_ addObject:mole3];
		
		MoleObject *mole4 = [[[MoleObject alloc] initWithPosition:ccp(size.width * 3 / 4, size.height / 2 - 90)] autorelease];
        [self addChild:mole4 z:tMole4];
        [moleSet_ addObject:mole4];
    }
    
    return self;
}


-(id)initWithLevel:(int)level
{
    if((self = [self init]))
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        gameLevel_ = level;
        
        
        /*このクラスがどのレベルで生成されたかを表示するラベル*/
        NSString *slevel = [NSString stringWithFormat:@"Current Level: %d", gameLevel_];
        CCLabelTTF *levelLabel = [CCLabelTTF labelWithString:slevel fontName:@"Marker Felt" fontSize:20];
        
        levelLabel.position =  ccp( size.width - 10, 10 );
        levelLabel.anchorPoint = ccp(1.0, 0.0);
        
		[self addChild: levelLabel];
        
        switch(level)
		{
			case 1:
				maxActiveNum_ = 2;
				break;
				
			case 2:
				maxActiveNum_ = 4;
				break;
				
			case 3:
				maxActiveNum_ = 5;
				break;
				
			default:
				maxActiveNum_ = 2;
				break;
		}
    }
    return self;
}


-(void) dealloc
{
    [moleSet_ release];
    [super dealloc];
}


- (void)showGameResult:(id)sender
{
    NSLog(@"Game End Button Tap");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene:[ScoreScreenLayer scene]]];
}


-(void)startCountDown:(id)sender
{
    NSLog(@"start button tapped");
    
    CCMenu* startMenu = (CCMenu*)[self getChildByTag:tStartMenu];
    
    CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:0.3];
    CCCallBlockN *block = [CCCallBlockN actionWithBlock:^(CCNode* me){ me.visible = NO; }];
    CCSequence *seq = [CCSequence actions:fadeOut, block, nil];
    [startMenu runAction:seq];
    
    CCLabelTTF *countDownLabel = (CCLabelTTF*)[self getChildByTag:tCountDown];
    
    CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:0.1];
    CCScaleTo *scaleTo = [CCScaleTo actionWithDuration:0.5 scale:1.0];
    CCEaseBounceOut *backOut = [CCEaseBounceOut actionWithAction:scaleTo];
    CCSpawn *spawn = [CCSpawn actions:fadeIn, backOut, nil];
    [countDownLabel runAction:spawn];
    
    startTimer_ = 4;
    
    [self schedule:@selector(scheduleCountDown:)];
}


-(void)scheduleCountDown:(ccTime)dlt
{
    startTimer_ -= dlt;
    CCLabelTTF *countDownLabel = (CCLabelTTF*)[self getChildByTag:tCountDown];
    
    if(startTimer_ > 1)
    {
        [countDownLabel setString:[NSString stringWithFormat:@"%d", (int)startTimer_]];
    }
    else
    {
        [countDownLabel setString:[NSString stringWithFormat:@"Start"]];
        CCScaleTo *scaleTo = [CCScaleTo actionWithDuration:0.3 scale:3];
        CCEaseBackIn * backIn = [CCEaseBackIn actionWithAction:scaleTo];
        CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:0.3];
        CCSpawn *spawn = [CCSpawn actions:backIn, fadeOut, nil];
        
        [countDownLabel runAction:spawn];
        
        CCLabelTTF *mainTimer = (CCLabelTTF*)[self getChildByTag:tMainTimer];
        mainTimer.visible = YES;
        
        gameMainTimer_ = TIME_LIMIT;
        
        [self schedule:@selector(scheduleGameMain:)];
        
        [self unschedule:_cmd];
    }
}


-(void)scheduleGameMain:(ccTime)dlt
{
    gameMainTimer_ -= dlt;
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCLabelTTF *mainTimer = (CCLabelTTF*)[self getChildByTag:tMainTimer];
    
    if(gameMainTimer_ < 0.0)
    {
        [mainTimer setString:[NSString stringWithFormat:@"0.00s"]];
        
        CCLabelTTF *endLabel = [CCLabelTTF labelWithString:@"FINISH" fontName:@"Marker Felt" fontSize:20];
        endLabel.position = ccp( size.width /2 , size.height / 2);
        
        [self addChild: endLabel];
        
        CCMenu *endMenu = (CCMenu*)[self getChildByTag:tEndMenu];
        endMenu.visible = YES;
        
        CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:0.5];
        [endMenu runAction:fadeIn];
        
        for(MoleObject *mole in moleSet_)
        {
            [mole stopAllActions];
            [mole unscheduleAllSelectors];
            [mole backToOriginAction];
        }
        
        [self unschedule:_cmd];
    }
    else
    {
        [mainTimer setString:[NSString stringWithFormat:@"%.02fs", gameMainTimer_]];
        
        for(MoleObject* mole in moleSet_)
		{
			//何匹出現中か取得
//			int numAppear = [self countActiveMoles];
//			
//			if(!mole.OnAppear && numAppear < maxActiveNum_)
//			{
//				[mole runPeepAction];
//			}
			
            //int numAppear = [self countActiveMoles];
            //maxActiveNum_ = 2;
			if(mole.AppearState == sHidden)
			{
				[mole runPeepAction];
			}

		}
    }
}


-(void)incrementScore
{
	score_ += 1;
    
	NSString *sScore = [NSString stringWithFormat:@"Score: %d", score_];
    
	CCLabelTTF *scoreLabel = (CCLabelTTF*)[self getChildByTag:tScoreLabel];
    
    [scoreLabel setString:sScore];
}


-(int)countActiveMoles
{
	int count = 0;
	
	for(MoleObject* mole in moleSet_)
	{
		if(mole.AppearState == sAppear)
		{
			count++;
		}
	}
	
	return count;
}


@end
