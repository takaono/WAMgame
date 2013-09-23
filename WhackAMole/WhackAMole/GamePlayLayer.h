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

#define TIME_LIMIT 10.0f

typedef enum
{
    tStartMenu,
    tEndMenu,
    tCountDown,
    tMainTimer,
    tScoreLabel,
} GamePlayTags;

@interface GamePlayLayer : CCLayer
{
    int gameLevel_;
    int score_;
    ccTime startTimer_;
    ccTime gameMainTimer_;
    
    CCArray* moleSet_;
    //CCLabelTTF *countDownLabel_;
//    CCMenu *startMenu_;
}

@property (nonatomic, readonly) int GameLevel;

+(CCScene *) scene;
+(CCScene *) sceneWithLevel:(int)level;
-(void)incrementScore;

@end
