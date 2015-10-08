//
//  Filter.h
//  Audio Development
//
//  Created by Jože Ws on 9/12/15.
//  Copyright (c) 2015 Audio Developments. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheAmazingAudioEngine.h"

@class Wave;

@interface Filter : NSObject

@property (nonatomic) BOOL active; ///< Whether the synthesizer is active, does not adjust changes

@property (nonatomic,strong) Wave *amplitudeModulator; ///The amplitude modulator
@property (nonatomic) BOOL amplitudeModulatorOn; ///< Whether the wave is amplitude modulated, doesn't adjust changes

@property (nonatomic,readonly) AEAudioControllerFilterCallback filterCallback; ///< Render callback of audio playable protocol

+(instancetype)filter;

@end
