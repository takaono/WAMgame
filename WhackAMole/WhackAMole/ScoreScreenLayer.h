//
//  ScoreScreenLayer.h
//  WhackAMole
//
//  Created by T.ONO.
//  Copyright 2013 T.ONO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "StartScreenLayer.h"

//typedef enum
//{
//    tSuccessRate,
//} ScoreTags;

@interface ScoreScreenLayer : CCLayer {
    
}

+(CCScene *) scene;
-(void)createSuccessRateLabel:(int)rate;

@end
