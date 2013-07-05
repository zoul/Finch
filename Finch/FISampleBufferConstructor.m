//
//  FISampleBufferConstructor.m
//  Bazingo
//
//  Created by Jacob Agar on 2013-07-05.
//  Copyright (c) 2013 Uken Games, Inc. All rights reserved.
//

#import "FISampleBufferConstructor.h"
#import "FISound.h"
#import "FISoundEngine.h"

@implementation FISampleBufferConstructor

- (id)initWithSoundNamed:(NSString*)aSoundName maxPolyphony:(NSUInteger)numVoices {
    
    if (self = [super init]) {
        soundName = aSoundName;
        voices = numVoices;
    }
    return self;
}

- (void)main {
     NSError* error;
    
    FISound *sound = [[FISound alloc]
                      initWithPath:[((FISoundEngine *)[FISoundEngine sharedEngine]).soundBundle pathForResource:soundName ofType:nil] andName:soundName
                      maxPolyphony:voices error:&error];
    @synchronized( [FISoundEngine class] ) {
        if (sound) {
             [((FISoundEngine *)[FISoundEngine sharedEngine]).sounds setObject:sound forKey:soundName];
        }
        
        //do error handling here:
        
        //finally play the sound
        [sound play];
    }
}

@end
