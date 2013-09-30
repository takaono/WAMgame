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
    tInfoLayer,
} GamePlayTags;

typedef enum
{
    zBg0 = 0,
	zMole0,
    zBg1,
	zMole1,
	zBg2,
    zMole2,
	zBg3,
    zInfoLayer,
} SpriteOrderTags;


@interface GamePlayLayer : CCLayer
{
    CGSize size;
    int gameLevel_;
    int score_;
    int totalCount_;
    int maxActiveNum_;
    ccTime startTimer_;
    ccTime gameMainTimer_;
    
    CCArray* moleSet_;
}

@property (nonatomic, readonly) int GameLevel;
@property (nonatomic, readonly) int MaxActiveNum;

+(CCScene *) scene;
+(CCScene *) sceneWithLevel:(int)level;
-(void)incrementScore;
-(void)incrementTotalCount;
-(int)countActiveMoles;

@end
