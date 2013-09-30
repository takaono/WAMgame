//
//  GamePlayLayer.m
//  WhackAMole
//
//  Created by T.ONO.
//  Copyright 2013 T.ONO. All rights reserved.
//

#import "GamePlayLayer.h"
#import "StartScreenLayer.h"


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
        totalCount_ = 0;
        
		size = [[CCDirector sharedDirector] winSize];
        
        [self makeBackGround];
        
        [self locateMoleObjects];
        
        CCLayer *infoLayer = [CCLayer node];
        
        [self addChild:infoLayer z:zInfoLayer tag:tInfoLayer];
        
        [self locatePanels];
        
        [self makeButtons];
    }
    
    return self;
}


-(id)initWithLevel:(int)level
{
    if((self = [self init]))
    {
        gameLevel_ = level;
        
        CCLayer *infoLayer = (CCLayer*)[self getChildByTag:tInfoLayer];
        
        CCSprite *starImg;
        
        switch(level)
		{
			case 1:
                starImg = [CCSprite spriteWithFile:@"level_icon_1.png"];
				maxActiveNum_ = 2;
				break;
				
			case 2:
                starImg = [CCSprite spriteWithFile:@"level_icon_2.png"];
				maxActiveNum_ = 4;
				break;
				
			case 3:
                starImg = [CCSprite spriteWithFile:@"level_icon_3.png"];
				maxActiveNum_ = 5;
				break;
				
			default:
                starImg = [CCSprite spriteWithFile:@"level_icon_1.png"];
				maxActiveNum_ = 2;
				break;
		}
        
        [infoLayer addChild:starImg];
        
        starImg.position = ccp(size.width / 2 + 55, 20);
    }
    return self;
}


-(void) dealloc
{
    [moleSet_ release];
    [super dealloc];
}


-(void)locatePanels
{
    CCLayer *infoLayer = (CCLayer*)[self getChildByTag:tInfoLayer];
    
    /*上下のパネル*/
    /* 
     * Bottom Right
     */
    CCLayerColor *layerBR = [CCLayerColor layerWithColor:ccc4(230, 232, 93, 255) width:160 height:40];
    
    layerBR.position = ccp(size.width, 0);
    
    layerBR.ignoreAnchorPointForPosition = NO;
    
    layerBR.anchorPoint = ccp(1.0, 0.0);
    
    [infoLayer addChild:layerBR];
    
    CCLabelTTF *levelLabel = [CCLabelTTF labelWithString:@"l e v e l" fontName:@"Helvetica" fontSize:18];
    
    levelLabel.position =  ccp(97, 19);
    
    levelLabel.scale = 0.5;
    
    levelLabel.color = ccc3(20, 20, 20);
    
    [layerBR addChild: levelLabel];
    
    /*
     * Top Left Panel 
     */
    CCLayerColor *layerTL = [CCLayerColor layerWithColor:ccc4(230, 232, 93, 255) width:160 height:40];
    
    layerTL.position = ccp(0, size.height);
    
    layerTL.ignoreAnchorPointForPosition = NO;
    
    layerTL.anchorPoint = ccp(0.0, 1.0);
    
    [infoLayer addChild:layerTL];
    
    CCSprite *clockImg = [CCSprite spriteWithFile:@"clock_icon.png"];
    
    [layerTL addChild:clockImg];
    
    clockImg.position = ccp(38,20);
    
    /* 制限時間をカウントするラベル */
    CCLabelTTF *mainTimerLabel = [CCLabelTTF labelWithString:@"20" fontName:@"Helvetica" fontSize:32];
    
    mainTimerLabel.position = ccp(70, size.height - 21);
    
    mainTimerLabel.scale = 0.5;
    
    mainTimerLabel.tag = tMainTimer;
    
    mainTimerLabel.color = ccc3(60, 60, 60);
    
    mainTimerLabel.visible = YES;
    
    [infoLayer addChild: mainTimerLabel];
    
    CCLabelTTF *secondsLabel = [CCLabelTTF labelWithString:@"s e c o n d s" fontName:@"Helvetica" fontSize:18];
    
    secondsLabel.position = ccp(113, 17);
    
    secondsLabel.scale = 0.5;
    
    secondsLabel.color = ccc3(20, 20, 20);
    
    secondsLabel.visible = YES;
    
    [layerTL addChild: secondsLabel];
    
    
    /* 
     * Top Right Panel
     */
    CCLayerColor *layerTR = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255) width:160 height:40];
    
    layerTR.position = ccp(size.width, size.height);
    
    layerTR.ignoreAnchorPointForPosition = NO;
    
    layerTR.anchorPoint = ccp(1.0, 1.0);
    
    [infoLayer addChild:layerTR];
    
    CCSprite *crownImg = [CCSprite spriteWithFile:@"crown_icon.png"];
    
    crownImg.position = ccp(40,20);
    
    [layerTR addChild:crownImg];
    
    /* 得点をカウントするラベル */
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Helvetica" fontSize:32];
    
    scoreLabel.position = ccp(size.width / 2 + 80, size.height - 21);
    
    scoreLabel.scale = 0.5;
    
    scoreLabel.tag = tScoreLabel;
    
    scoreLabel.color = ccc3(60, 60, 60);
    
    scoreLabel.visible = YES;
    
    [infoLayer addChild: scoreLabel];
    
    CCLabelTTF *hitsLabel = [CCLabelTTF labelWithString:@"h i t s" fontName:@"Helvetica" fontSize:18];
    
    hitsLabel.position = ccp(110, 17);
    
    hitsLabel.scale = 0.5;
    
    hitsLabel.color = ccc3(20, 20, 20);
    
    hitsLabel.visible = YES;
    
    [layerTR addChild: hitsLabel];
    
    
    /*
     * スタートカウントダウン用ラベルの生成と設置
     */
    CCLabelTTF *countDownLabel = [CCLabelTTF labelWithString:@"3" fontName:@"Helvetica" fontSize:38];
    
    countDownLabel.position = ccp( size.width / 2, size.height / 2);
    
    countDownLabel.tag = tCountDown;
    
    countDownLabel.opacity = 0;
    
    countDownLabel.scale = 0;
    
    countDownLabel.color = ccc3(255, 255, 255);
    
    [infoLayer addChild:countDownLabel];
}

-(void)makeButtons
{
    CCLayer *infoLayer = (CCLayer*)[self getChildByTag:tInfoLayer];
    
    [CCMenuItemFont setFontSize:28];
    
    [CCMenuItemFont setFontName:@"Helvetica"];

    __block id copy_self = self;
    
    /*
     * スタートボタン用ラベルの生成と設置
     */
    CCMenuItem *startButton = [CCMenuItemImage itemWithNormalImage:@"tap_start.png" selectedImage:@"tap_start_pressed.png" block:^(id sender){
        [copy_self startCountDown:sender];
    }];
    
    CCMenu *startMenu = [CCMenu menuWithItems:startButton, nil];
    
    startMenu.tag = tStartMenu;
    
    [startMenu setPosition:ccp( size.width / 2, size.height / 2)];
    
    [infoLayer addChild:startMenu];
    
    
    /*ゲーム終了後のシーン遷移用ラベルの生成と設置*/
    CCMenuItem *endLabel = [CCMenuItemImage itemWithNormalImage:@"game_end.png" selectedImage:@"game_end_pressed.png" block:^(id sender){
        [copy_self showGameResult:sender];
    }];
    
    CCMenu *menu = [CCMenu menuWithItems:endLabel, nil];
    
    menu.tag = tEndMenu;
    
    [menu setPosition:ccp( size.width / 2, size.height / 2)];
    
    menu.opacity = 0;
    
    menu.visible = NO; /*visibleをNOにしないとタップできてしまう*/
    
    [infoLayer addChild:menu];
    
    
    /* Back button */
    CCMenuItem *backImg = [CCMenuItemImage itemWithNormalImage:@"back_panel.png" selectedImage:@"back_panel_pressed.png" block:^(id sender){
        [copy_self backToStartScreen:sender];
    }];
    
    CCMenu *backMenu = [CCMenu menuWithItems:backImg, nil];
    
    [backMenu setPosition:ccp(80, 20)];
    
    [infoLayer addChild:backMenu];
    
    CCLabelTTF *backLabel = [CCLabelTTF labelWithString:@"b a c k" fontName:@"Helvetica" fontSize:18];
    
    backLabel.position = ccp(97, 19);
    
    backLabel.scale = 0.5;
    
    backLabel.color = ccc3(20, 20, 20);
    
    backLabel.visible = YES;
    
    [infoLayer addChild: backLabel];
}


-(void)locateMoleObjects
{
    /*モグラオブジェクトの生成と設置*/
    moleSet_ = [[CCArray alloc] initWithCapacity:5];
    
    MoleObject *mole0 = [[[MoleObject alloc] initWithPosition:ccp(size.width / 4, size.height / 2 + 90)] autorelease];
    
    [self addChild:mole0 z:zMole0];
    
    [moleSet_ addObject:mole0];
    
    
    MoleObject *mole1 = [[[MoleObject alloc] initWithPosition:ccp(size.width * 3 / 4, size.height / 2 + 90)] autorelease];
    
    [self addChild:mole1 z:zMole0];
    
    [moleSet_ addObject:mole1];
    
    
    MoleObject *mole2 = [[[MoleObject alloc] initWithPosition:ccp(size.width / 2, size.height / 2 - 10)] autorelease];
    
    [self addChild:mole2 z:zMole1];
    
    [moleSet_ addObject:mole2];
    
    
    MoleObject *mole3 = [[[MoleObject alloc] initWithPosition:ccp(size.width / 4, size.height / 2 - 110)] autorelease];
    
    [self addChild:mole3 z:zMole2];
    
    [moleSet_ addObject:mole3];
    
    
    MoleObject *mole4 = [[[MoleObject alloc] initWithPosition:ccp(size.width * 3 / 4, size.height / 2 - 110)] autorelease];
    
    [self addChild:mole4 z:zMole2];
    
    [moleSet_ addObject:mole4];
}


-(void)makeBackGround
{
    /*背景画像の設置*/
    CCLayerColor *baseLayer = [CCLayerColor layerWithColor:ccc4(103, 83, 51, 255)];
    
    [self addChild:baseLayer];
    
    
    CCSprite *bg0 = [CCSprite spriteWithFile:@"bg0.png"];
    
    bg0.anchorPoint = ccp(0.5, 1.0);
    
    bg0.position = ccp(size.width / 2, size.height);
    
    [self addChild:bg0 z:zBg0];
    
    
    CCSprite *bg1 = [CCSprite spriteWithFile:@"bg1.png"];
    
    bg1.anchorPoint = ccp(0.5, 0.0);
    
    bg1.position = ccp(size.width / 2, size.height / 2 - 20);
    
    [self addChild:bg1 z:zBg1];
    
    
    CCSprite *bg2 = [CCSprite spriteWithFile:@"bg2.png"];
    
    bg2.anchorPoint = ccp(0.5, 1.0);
    
    bg2.position = ccp(size.width / 2, size.height / 2 - 20);
    
    [self addChild:bg2 z:zBg2];
    
    
    CCSprite *bg3 = [CCSprite spriteWithFile:@"bg3.png"];
    
    bg3.anchorPoint = ccp(0.5, 0.0);
    
    bg3.position = ccp(size.width / 2, 0.0);
    
    [self addChild:bg3 z:zBg3];
}


- (void)showGameResult:(id)sender
{
    CCScene *scoreScreenScene = [ScoreScreenLayer scene];
	
    ScoreScreenLayer *baseLayer = [scoreScreenScene.children objectAtIndex:0];
    
    float rate = (float)score_ / (float)totalCount_ * 100.0;
    
    NSLog(@"rate: %f, score: %d, total: %d", rate, score_, totalCount_);
    
    [baseLayer createSuccessRateLabel:(int)rate];
	
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene:scoreScreenScene]];
}


-(void)startCountDown:(id)sender
{
    CCMenu* startMenu = (CCMenu*)[[self getChildByTag:tInfoLayer] getChildByTag:tStartMenu];
    
    CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:0.3];
    
    CCCallBlockN *block = [CCCallBlockN actionWithBlock:^(CCNode* me){ me.visible = NO; }];
    
    CCSequence *seq = [CCSequence actions:fadeOut, block, nil];
    
    [startMenu runAction:seq];
    
    CCLabelTTF *countDownLabel = (CCLabelTTF*)[[self getChildByTag:tInfoLayer] getChildByTag:tCountDown];
    
    CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:0.1];
    
    CCScaleTo *scaleTo = [CCScaleTo actionWithDuration:0.5 scale:0.5];
    
    CCEaseBounceOut *backOut = [CCEaseBounceOut actionWithAction:scaleTo];
    
    CCSpawn *spawn = [CCSpawn actions:fadeIn, backOut, nil];
    
    [countDownLabel runAction:spawn];
    
    startTimer_ = 4;
    
    [self schedule:@selector(scheduleCountDown:)];
}


-(void)scheduleCountDown:(ccTime)dlt
{
    startTimer_ -= dlt;
    
    CCLabelTTF *countDownLabel = (CCLabelTTF*)[[self getChildByTag:tInfoLayer] getChildByTag:tCountDown];
    
    if(startTimer_ > 1)
    {
        [countDownLabel setString:[NSString stringWithFormat:@"%d", (int)startTimer_]];
    }
    else
    {
        [countDownLabel setString:[NSString stringWithFormat:@"Start"]];
        
        CCScaleTo *scaleTo = [CCScaleTo actionWithDuration:0.3 scale:1];
        
        CCEaseBackIn * backIn = [CCEaseBackIn actionWithAction:scaleTo];
        
        CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:0.3];
        
        CCSpawn *spawn = [CCSpawn actions:backIn, fadeOut, nil];
        
        [countDownLabel runAction:spawn];
        
        CCLabelTTF *mainTimer = (CCLabelTTF*)[[self getChildByTag:tInfoLayer] getChildByTag:tMainTimer];
        
        mainTimer.visible = YES;
        
        gameMainTimer_ = TIME_LIMIT;
        
        [self schedule:@selector(scheduleGameMain:)];
        
        [self unschedule:_cmd];
    }
}


-(void)scheduleGameMain:(ccTime)dlt
{
    gameMainTimer_ -= dlt;
    
    size = [[CCDirector sharedDirector] winSize];
    
    CCLabelTTF *mainTimer = (CCLabelTTF*)[[self getChildByTag:tInfoLayer] getChildByTag:tMainTimer];
    
    if(gameMainTimer_ < 0.0)
    {
        [mainTimer setString:[NSString stringWithFormat:@"0"]];
        
        CCLabelTTF *endLabel = [CCLabelTTF labelWithString:@"FINISH" fontName:@"Helvetica" fontSize:20];
        endLabel.position = ccp( size.width /2 , size.height / 2);
        
        [self addChild: endLabel];
        
        CCMenu *endMenu = (CCMenu*)[[self getChildByTag:tInfoLayer] getChildByTag:tEndMenu];
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
        [mainTimer setString:[NSString stringWithFormat:@"%d", (int)gameMainTimer_]];
        
        for(MoleObject* mole in moleSet_)
		{
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
    
	NSString *sScore = [NSString stringWithFormat:@"%d", score_];
    
	CCLabelTTF *scoreLabel = (CCLabelTTF*)[[self getChildByTag:tInfoLayer] getChildByTag:tScoreLabel];
    
    [scoreLabel setString:sScore];
}


-(void)incrementTotalCount
{
    totalCount_++;
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


-(void)backToStartScreen:(id)sender
{
    [self unscheduleAllSelectors];
    
    for(MoleObject* mole in moleSet_)
	{
        [mole stopAllActions];
        
        [mole unscheduleAllSelectors];
	}
    
    CCScene *startScreenScene = [StartScreenLayer scene];
	
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5 scene:startScreenScene]];
}


@end
