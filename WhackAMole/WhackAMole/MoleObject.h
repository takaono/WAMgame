//
//  MoleObject.h
//  WhackAMole
//
//  Created by T.ONO.
//  Copyright 2013 T.ONO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


typedef enum
{
    tPeepAct,
    tMoleSprite,
} MoleObjTags;

typedef enum
{
    sHidden,
	sStandBy,
	sAppear,
} AppearState;


@interface MoleObject : CCLayer
{
    unsigned appearState_;
	BOOL onHit_;
	CGPoint originalPos_;
	ccTime waitingTime_;
	ccTime currentWait_;
	ccTime actionTime_;
}

@property (nonatomic, readonly) unsigned AppearState;

-(id)initWithPosition:(CGPoint)pos;
-(void)runPeepAction;
-(void)backToOriginAction;

@end
