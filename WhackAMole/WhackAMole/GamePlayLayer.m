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
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Game Play Layer" fontName:@"Marker Felt" fontSize:20];
        
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		label.position =  ccp( size.width / 2, size.height - 100 );
        
		[self addChild: label];
        
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
		
		[self addChild:menu];
        
        
        /*スタートカウントダウン用ラベルの生成と設置*/
        CCLabelTTF *countDownLabel = [CCLabelTTF labelWithString:@"3" fontName:@"Marker Felt" fontSize:24];
        
        countDownLabel.position = ccp( size.width / 2, size.height / 2 - 50);
        countDownLabel.tag = tCountDown;
        countDownLabel.opacity = 0;
        countDownLabel.scale = 0;
        
        [self addChild: countDownLabel];
        
        /*制限時間用ラベルの生成と設置*/
        CCLabelTTF *mainTimerLabel = [CCLabelTTF labelWithString:@"60.0s" fontName:@"Marker Felt" fontSize:20];
        
        mainTimerLabel.position = ccp(10, size.height - 10);
        mainTimerLabel.tag = tMainTimer;
        mainTimerLabel.anchorPoint = ccp(0.0f, 1.0f);
        mainTimerLabel.visible = NO;
        
        [self addChild: mainTimerLabel];
        
        
        /*スタートボタン用ラベルの生成と設置*/
        CCMenuItem *startButton = [CCMenuItemFont itemWithString:@"Tap to start" block:^(id sender){
            [copy_self startCountDown:sender];
        }];
		
		CCMenu *startMenu = [CCMenu menuWithItems:startButton, nil];
        startMenu.tag = tStartMenu;
        
        [startMenu setPosition:ccp( size.width / 2, size.height / 2)];
		
		[self addChild:startMenu];
        
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
        
        levelLabel.position =  ccp( size.width /2 , size.height/2 + 50 );
        
		[self addChild: levelLabel];
        
    }
    return self;
}


-(void) dealloc
{
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
        
        [self unschedule:_cmd];
    }
    else
    {
        [mainTimer setString:[NSString stringWithFormat:@"%.02fs", gameMainTimer_]];
    }
}

@end
