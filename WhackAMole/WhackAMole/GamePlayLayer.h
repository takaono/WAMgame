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

@interface GamePlayLayer : CCLayer
{
    int gameLevel_;
    CCLabelTTF *countDownLabel_;
    CCMenu *startMenu_;
}

@property (nonatomic, readonly) int GameLevel;

+(CCScene *) scene;
+(CCScene *) sceneWithLevel:(int)level;

@end
