//
//  StartScreenLayer.h
//  WhackAMole
//
//  Created by T.ONO.
//  Copyright T.ONO 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "GamePlayLayer.h"

typedef enum
{
    level1,
    level2,
    level3
} LevelMenuTags;

@interface StartScreenLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
}

+(CCScene *) scene;

@end
