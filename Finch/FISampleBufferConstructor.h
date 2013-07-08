//
//  FISampleBufferConstructor.h
//  Bazingo
//
//  Created by Jacob Agar on 2013-07-05.
//  Copyright (c) 2013 Uken Games, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISampleBufferConstructor : NSOperation {
    NSString * soundName;
    NSUInteger voices;
    float cacheDuration;
}
- (id)initWithSoundNamed:(NSString*)aSoundName maxPolyphony:(NSUInteger)numVoices withCacheDuration:(float)aCacheDuration;
@end
