#import "FISound.h"

/*
    When you send the “play” message to a regular sound
    (instance of Sound.m), the sound rewinds and plays from
    the start. This is not always desirable, a lot of times
    you would like to play many instances of the same sound
    simultaneously (think machinegun). This is what this
    class is for.
*/
@interface FIRevolverSound : NSObject

@property(assign) float gain;

- (id) initWithFile: (NSURL*) fileURL rounds: (int) max;

- (void) play;
- (void) stop;

@end
