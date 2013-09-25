//
//  GamePlayLayer.h
//  WhackAMole
//
//  Created by T.ONO.
//  Copyright 2013 T.ONO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ScoreScreenLayer.h"
#import "MoleObject.h"

#define TIME_LIMIT 20.0f

typedef enum
{
    tStartMenu,
    tEndMenu,
    tCountDown,
    tMainTimer,
    tScoreLabel,
} GamePlayTags;

typedef enum
{
    tBg0 = 0,
	tMole0,
	tMole1,
    tBg1,
	tMole2,
	tBg2,
	tMole3,
	tMole4,
	tBg3,
    tOrderGameEnd,
    tOrderStartCount,
    tOrderTime,
    tOrderScore,
    tOrderTap,
} SpriteOrderTags;


@interface GamePlayLayer : CCLayer
{
    int gameLevel_;
    int score_;
    int maxActiveNum_;
    ccTime startTimer_;
    ccTime gameMainTimer_;
    
    CCArray* moleSet_;
    //CCLabelTTF *countDownLabel_;
//    CCMenu *startMenu_;
}

@property (nonatomic, readonly) int GameLevel;
@property (nonatomic, readonly) int MaxActiveNum;

+(CCScene *) scene;
+(CCScene *) sceneWithLevel:(int)level;
-(void)incrementScore;
-(int)countActiveMoles;

@end
