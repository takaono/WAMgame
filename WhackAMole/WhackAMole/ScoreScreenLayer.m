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
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Score Screen Layer" fontName:@"Marker Felt" fontSize:20];
        
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		label.position =  ccp( size.width /2 , size.height/2 );
        
		[self addChild: label];
        
        __block id copy_self = self;
        
        [CCMenuItemFont setFontSize:20];
		
        
        /*スタート画面へ戻るボタンの生成と設置*/
		CCMenuItem *restartLabel = [CCMenuItemFont itemWithString:@"Restart" block:^(id sender){
            [copy_self showStartScreen:sender];
        }];
		
		CCMenu *menu = [CCMenu menuWithItems:restartLabel, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
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

@end
