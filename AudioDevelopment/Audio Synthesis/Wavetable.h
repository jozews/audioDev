//
//  SYWavetable.h
//  Synthesis
//
//  Created by Jose Pablo on 5/17/14.
//  Copyright (c) 2014 Digital Instruments. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! Flawed wavetable */

@interface AUDWavetable : NSObject

@property (nonatomic) CGFloat frequency; ///< Frequency of the wave as Hertz
@property (nonatomic) CGFloat amplitude; ///< Amplitude of the wave as an unsigned decimal

+(AUDWavetable*)wavetable;
double wavetableSample (AUDWavetable *wavetable);

@end
