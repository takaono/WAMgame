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
} MoleObjTags;


@interface MoleObject : CCLayer
{
    BOOL onAppear_;
	BOOL onHit_;
	CGPoint originalPos_;
	ccTime waitingTime_;
	ccTime currentWait_;
	ccTime actionTime_;
}

@property (nonatomic, readonly) BOOL OnAppear;

-(id)initWithPosition:(CGPoint)pos;

@end
