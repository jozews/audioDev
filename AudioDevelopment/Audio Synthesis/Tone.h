//
//  SYTone.h
//  Synthesis
//
//  Created by Jose Pablo on 4/30/14.
//  Copyright (c) 2014 Digital Instruments. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! Tone sampler*/

@interface Tone : NSObject

@property (nonatomic,readonly) NSUInteger capacity; ///< The partials capacity

+(instancetype)sine;
+(instancetype)square;
+(instancetype)triangle;
+(instancetype)unitTriangle;
+(instancetype)sawtooth;
+(instancetype)inverseSawtooth;

double toneSample (Tone *tone ,double phase); ///< Returns the tone sample
double toneSampleModulated (Tone *tone ,double phase, double modulation); ///< Returns the tone sample with the given modulation

@end

