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

- (id)initWithSoundNamed:(NSString*)aSoundName maxPolyphony:(NSUInteger)numVoices withCacheDuration:(float)aCacheDuration andShouldPlay:(bool)play {
    
    if (self = [super init]) {
        soundName = aSoundName;
        voices = numVoices;
        cacheDuration = aCacheDuration;
        shouldPlay = play;
    }
    return self;
}

- (void)main {
    NSError* error;
    
    NSString *fullpath;
    if ( [[NSFileManager defaultManager] fileExistsAtPath:soundName] ) {
        fullpath = soundName;
    } else {
        fullpath = [((FISoundEngine *)[FISoundEngine sharedEngine]).soundBundle pathForResource:soundName ofType:nil];
    }
    
    FISound *sound = [[FISound alloc]
                      initWithPath:fullpath andName:soundName
                      maxPolyphony:voices error:&error];
    
    sound.cacheDuration = cacheDuration;
    
    @synchronized( [FISoundEngine class] ) {
        if (sound) {
            [((FISoundEngine *)[FISoundEngine sharedEngine]).sounds setObject:sound forKey:soundName];
            //do error handling here:
            if (shouldPlay) {
                //finally play the sound
                [sound play];
            }
        }
    }
}

@end
