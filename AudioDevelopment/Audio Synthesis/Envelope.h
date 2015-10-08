//
//  SYEnvelope.h
//  Synthesis
//
//  Created by Jose Pablo on 4/17/14.
//  Copyright (c) 2014 Digital Instruments. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SYShape){
    SYShapeCubicRoot=0,
    SYShapeSquareRoot=1,
    SYShapeLinear=2,
    SYShapeSquare=3,
    SYShapeCubic=4,
};

@class Wave;

/*! Envelope sampler */

@interface Envelope : NSObject

@property (nonatomic,weak) Wave *observerWave; ///< The wave the envelope notifies

@property (nonatomic) CFTimeInterval attackDuration; ///< Attack duration in seconds
@property (nonatomic) CFTimeInterval releaseDuration; ///< Release duration in seconds

@property (nonatomic) SYShape attackShape; ///< Attack shape as an unsigned float
@property (nonatomic) SYShape releaseShape; ///< Release shape as an unsigned float

+(instancetype)envelope; ///< Instantiates an envelope with default attack and release

void startEnvelope(Envelope *envelope); ///< Starts the envelope
void stopEnvelope(Envelope *envelope); ////< Stops the envelope with the minimum release rate
void restartEnvelope(Envelope *envelope); ////< Restarts the envelope

bool envelopeIsActive(Envelope *envelope); ///< Whether the left envelope is active

double envelopeValue(Envelope *envelope); ///< Returns the envelope value

@end

