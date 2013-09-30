//
//  ScoreScreenLayer.m
//  WhackAMole
//
//  Created by T.ONO.
//  Copyright 2013 T.ONO. All rights reserved.
//

#import "ScoreScreenLayer.h"


@implementation ScoreScreenLayer

+(CCScene *)scene
{
    CCScene *scene = [CCScene node];
    
    ScoreScreenLayer *layer = [ScoreScreenLayer node];
    
    [scene addChild:layer];
    
    return scene;
}


-(id)init
{
    if((self = [super init]))
    {
        CCLayerColor *background = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
        [self addChild:background];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"s c o r e   r a t e" fontName:@"Helvetica" fontSize:22];
        
        label.scale = 0.5;
        
        label.color = ccc3(20, 20, 20);
        
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		label.position = ccp( size.width /2 , size.height/2 + 30 );
        
		[self addChild: label];
        
        
        __block id copy_self = self;
        
        [CCMenuItemFont setFontSize:20];
		
        
        /*スタート画面へ戻るボタンの生成と設置*/
		CCMenuItem *restartLabel = [CCMenuItemImage itemWithNormalImage:@"btn_restart.png" selectedImage:@"btn_restart_pressed.png" block:^(id sender){
            [copy_self showStartScreen:sender];
        }];
		
		CCMenu *menu = [CCMenu menuWithItems:restartLabel, nil];
        
		[menu setPosition:ccp( size.width/2, size.height/2 - 100)];
		
		[self addChild:menu];
    }
    
    return self;
}


-(void) dealloc
{
    [super dealloc];
}


- (void)showStartScreen:(id)sender
{
    NSLog(@"Game Restart Button Tap");
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[StartScreenLayer scene] withColor:ccWHITE]];
}


-(void)createSuccessRateLabel:(int)rate
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCLabelTTF *successRate = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d%%", rate] fontName:@"Helvetica" fontSize:30];
    successRate.scale = 0.5;
    successRate.color = ccc3(20, 20, 20);
    
    //successRate.tag = tSuccessRate;
    successRate.position = ccp(size.width / 2, size.height / 2 );
    
    [self addChild:successRate];
}

@end
