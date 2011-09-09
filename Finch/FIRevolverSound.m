#import "FIRevolverSound.h"
#import "FISound.h"

@interface FIRevolverSound ()
@property(retain) NSArray *sounds;
@property(assign) NSUInteger current;
@end

@implementation FIRevolverSound
@synthesize sounds, current;

- (id) initWithSounds: (NSArray*) newSounds
{
    [super init];
    [self setSounds:newSounds];
    return self;
}

- (void) dealloc
{
    [sounds release];
    [super dealloc];
}

- (void) play
{
    [(FISound*) [sounds objectAtIndex:current] play];
    current = (current + 1) % [sounds count];
}

- (void) stop
{
    [[sounds objectAtIndex:current] stop];
}

- (void) setGain: (float) val
{
    for (FISound *sound in sounds)
        [sound setGain:val];
}

- (float) gain
{
    return [[sounds lastObject] gain];
}

@end
