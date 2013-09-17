//
//  StartScreenLayer.m
//  WhackAMole
//
//  Created by T.ONO.
//  Copyright T.ONO 2013. All rights reserved.
//


#import "StartScreenLayer.h"
#import "AppDelegate.h"

#pragma mark - StartScreenLayer

@implementation StartScreenLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	StartScreenLayer *layer = [StartScreenLayer node];
    
	[scene addChild: layer];
	
	return scene;
}


-(id) init
{
	if( (self=[super init]) ) {
        
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Choose Level" fontName:@"Marker Felt" fontSize:20];
        
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		label.position =  ccp( size.width /2 , size.height - 50 );
        
		[self addChild: label];
		
        __block id copy_self = self;
        
		[CCMenuItemFont setFontSize:20];
		
        
        /*レベルボタンの生成と設置*/
		CCMenuItem *levelbutton1 = [CCMenuItemFont itemWithString:@"LEVEL 1" block:^(id sender){
            [copy_self gameStart:sender];
        }];
		
		levelbutton1.tag = level1;
        
        CCMenuItem *levelbutton2 = [CCMenuItemFont itemWithString:@"LEVEL 2" block:^(id sender){
            [copy_self gameStart:sender];
        }];
        
        levelbutton2.tag = level2;
        
        CCMenuItem *levelbutton3 = [CCMenuItemFont itemWithString:@"LEVEL 3" block:^(id sender){
            [copy_self gameStart:sender];
        }];
        
        levelbutton3.tag = level3;
		
		CCMenu *menu = [CCMenu menuWithItems:levelbutton1, levelbutton2, levelbutton3, nil];
		
		[menu alignItemsVerticallyWithPadding:20];
		[menu setPosition:ccp( size.width / 2, size.height / 2)];
		
		[self addChild:menu];
	}
	return self;
}


- (void) dealloc
{
	[super dealloc];
}


- (void)gameStart:(id)sender
{
    NSLog(@"Game Start Button Tap");
    int level;
    
    switch ([sender tag]) {
        case level1:
            level = 1;
            break;
            
        case level2:
            level = 2;
            break;
            
        case level3:
            level = 3;
            break;
            
        default:
            break;
    }
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene:[GamePlayLayer sceneWithLevel:level]]];
}


#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
