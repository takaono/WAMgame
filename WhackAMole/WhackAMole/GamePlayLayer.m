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
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width / 2, 100)];
		
		[self addChild:menu];
        
        
        /*スタートカウントダウン用ラベルの生成と設置*/
        countDownLabel_ = [CCLabelTTF labelWithString:@"3" fontName:@"Marker Felt" fontSize:24];
        
        countDownLabel_.position = ccp( size.width / 2, size.height / 2 - 50);
        
        [self addChild: countDownLabel_];
        
        
        /*スタートボタン用ラベルの生成と設置*/
        CCMenuItem *startButton = [CCMenuItemFont itemWithString:@"Tap to start" block:^(id sender){
            [copy_self startCountDown:sender];
        }];
		
		startMenu_ = [CCMenu menuWithItems:startButton, nil];
        
        [startMenu_ setPosition:ccp( size.width / 2, size.height / 2)];
		
		[self addChild:startMenu_];
        
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
}


@end
