//
//  SYSynthesizer.h
//  Synthesis
//
//  Created by Jose Pablo on 4/16/14.
//  Copyright (c) 2014 Digital Instruments. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheAmazingAudioEngine.h"

@class Wave;

/*! Synthesizer channel */

@interface Synthesizer : NSObject

@property (nonatomic,strong) Wave *wave; ///< The wave the synthesizer renders, does not adjust changes
@property (nonatomic) BOOL active; ///< Whether the synthesizer is active, does not adjust changes

@property (nonatomic) float volume; ///< Volume of audio playable protocol
@property (nonatomic) float pan; ///< Pan of audio playable protocol
@property (nonatomic,readonly) AEAudioControllerRenderCallback renderCallback; ///< Render callback of audio playable protocol

+(instancetype)synthesizer; ///< Instantiate a synthesizer
+(instancetype)synthesizerWithWave:(Wave*)wave; ///< Instantiate a synthesizer with the given wave

@end
