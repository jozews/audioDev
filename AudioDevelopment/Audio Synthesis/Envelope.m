//
//  SYEnvelope.m
//  Synthesis
//
//  Created by Jose Pablo on 4/17/14.
//  Copyright (c) 2014 Digital Instruments. All rights reserved.
//

#import "Envelope.h"
#import "Wave.h"
#import "Modulator.h"

#define samplesPerSecond 44100.0
#define secondsPerSample (1.0/samplesPerSecond)
#define sinePeriod (2.0*M_PI)
#define incrementPerHertz (sinePeriod/samplesPerSecond)

#define minAttackDuration 0.009
#define minReleseDurationPerDeltaUnit 0.08
#define maxDeltaPerSecond 1/minReleseDurationPerDeltaUnit

#define minExponent .3
#define maxExponent 4

#define defaultAttack 0.0
#define defaultRelease 0.0

@interface Envelope ()
@property (nonatomic) BOOL isActive; ///< Whether the envelope is active
@property (nonatomic) BOOL isStopping; ///< Whether the envelope is stopping
@property (nonatomic) BOOL isRestarting; ///< Whether the envelope is restarting
@property (nonatomic) BOOL attacking; /// Whether the envelope is in attack phase

@property (nonatomic) float value; ///< Value of the envelope as a unsigned fraction
@property (nonatomic) CFTimeInterval duration; ///< Duration in seconds of the envelope since active

@property (nonatomic) CFTimeInterval effectAttackDuration; ///< Stores effective attack duration to avoid changes while active
@property (nonatomic) CFTimeInterval effectReleaseDuration; ///< Stores effective release duration to avoid changes while active

@property (nonatomic) float attackExp; ///< Attack exponent in the attack function
@property (nonatomic) float releaseExp; ///< Release exponent in the release function
@property (nonatomic) float effectAttackExp; ///< Effective attack exponent to avoid changes while active
@property (nonatomic) float effectReleaseExp; ///< Effective release exponent to avoid changes while active

@property (nonatomic) float attackConstant; ///< Attack duration constant in the attack function
@property (nonatomic) float releaseConstant; ///< Release duration constant in the release function
@end

@implementation Envelope

+(instancetype)envelope{
    Envelope *envelope=[[Envelope alloc] init];
    envelope.attackDuration=defaultAttack;
    envelope.releaseDuration=defaultRelease;
    envelope.attackShape=SYShapeLinear;
    envelope.releaseShape=SYShapeLinear;
    //private
    envelope.isActive=NO;
    envelope.isStopping=NO;
    envelope.attacking=NO;
    envelope.value=0.0;
    envelope.duration=0.0;
    return envelope;
}

-(void)setAttackDuration:(CFTimeInterval)attackDuration{
    _attackDuration=attackDuration;
    if (_attackDuration<minAttackDuration) {
        _attackDuration=minAttackDuration;
    }
}

-(void)setReleaseDuration:(CFTimeInterval)releaseDuration{
    _releaseDuration=releaseDuration;
    if (_releaseDuration<minReleseDurationPerDeltaUnit) {
        _releaseDuration=minReleseDurationPerDeltaUnit;
    }
}

-(void)setAttackShape:(SYShape)attackShape{
    _attackShape=attackShape;
    switch (_attackShape) {
        case SYShapeCubicRoot:
            _attackExp=1.0/3.0;
            break;
        case SYShapeSquareRoot:
            _attackExp=1.0/2.0;
            break;
        case SYShapeLinear:
            _attackExp=1.0;
            break;
        case SYShapeSquare:
            _attackExp=2.0;
            break;
        case SYShapeCubic:
            _attackExp=3.0;
            break;
    }
}

-(void)setReleaseShape:(SYShape)releaseShape{
    _releaseShape=releaseShape;
    switch (_releaseShape) {
        case SYShapeCubicRoot:
            _releaseExp=1.0/3.0;
            break;
        case SYShapeSquareRoot:
            _releaseExp=1.0/2.0;
            break;
        case SYShapeLinear:
            _releaseExp=1.0;
            break;
        case SYShapeSquare:
            _releaseExp=2.0;
            break;
        case SYShapeCubic:
            _releaseExp=3.0;
            break;
    }
}

void startEnvelope(Envelope *envelope) {
    envelope->_effectAttackDuration=envelope->_attackDuration;
    envelope->_effectReleaseDuration=envelope->_releaseDuration;
    envelope->_value=0.0;
    envelope->_duration=0.0;
    envelope->_effectAttackExp=envelope->_attackExp;
    envelope->_effectReleaseExp=envelope->_releaseExp;
    envelope->_attackConstant=1/envelope->_effectAttackDuration;
    envelope->_releaseConstant=1/envelope->_effectReleaseDuration;
    envelope->_attacking=YES;
    envelope->_isActive=YES;
    envelope->_isStopping=NO;
}

void stopEnvelope (Envelope *envelope) {
    envelope->_isStopping=YES;
}

void restartEnvelope (Envelope *envelope) {
    if (envelope->_isActive) {
        envelope->_isRestarting=YES;
        stopEnvelope(envelope);
    }
    else startEnvelope(envelope);
}

double envelopeValue (Envelope *envelope) {
    if (!envelope->_isActive) return 0.0;
    if (envelope->_isStopping) {
        envelope->_value-=maxDeltaPerSecond*secondsPerSample;
        if (envelope->_value<=0.0) {
            envelope->_isStopping=NO;
            if (envelope->_isRestarting) {
                envelope->_isRestarting=NO;
                startEnvelope(envelope);
                return envelope->_value;
            }
            else envelope->_isActive=NO;
            if (envelope->_observerWave) observedEnvelopeStopped(envelope->_observerWave, envelope);
        }
        return envelope->_value;
    }
    if (envelope->_attacking) {
        envelope->_value=powf(envelope->_attackConstant*envelope->_duration,envelope->_effectAttackExp);
        if (envelope->_duration>=envelope->_effectAttackDuration) {
            envelope->_duration=0.0;
            envelope->_attacking=NO;
        }
    } else {
        envelope->_value=1-powf(envelope->_releaseConstant*envelope->_duration,envelope->_effectReleaseExp);
        if (envelope->_value<=0.0) {
            envelope->_isActive=NO;
            if (envelope->_observerWave) observedEnvelopeEnded(envelope->_observerWave, envelope);
        }
    }
    envelope->_duration+=secondsPerSample;
    return envelope->_value;
}

bool envelopeIsActive (Envelope *envelope) {
    return envelope->_isActive;
}

@end

