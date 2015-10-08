//
//  AUDOscillator.h
//  Synthesis
//
//  Created by Jose Pablo on 5/24/14.
//  Copyright (c) 2014 Digital Instruments. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef struct {
    NSUInteger *samples;
    NSUInteger length;
} AUDUIntBuffer;

@interface Oscillator : NSObject

@property (nonatomic,readonly) AUDUIntBuffer minimums;
@property (nonatomic,readonly,strong) Oscillator *oscillator;

+(Oscillator*)oscillator;

void oscillatorAddMinimums (Oscillator *oscillator, AUDUIntBuffer minumums);

@end
