#import "RevolverSound.h"
#import "Sound+IO.h"

@implementation RevolverSound

- (id) initWithFile: (NSString*) file rounds: (int) max
{
    [super init];
    sounds = [[NSMutableArray alloc] init];
    for (int i=0; i<max; i++)
        [sounds addObject:[[[Sound alloc] initWithFile:file] autorelease]];
    return self;
}

- (void) dealloc
{
    [sounds release];
    [super dealloc];
}

- (void) play
{
    [[sounds objectAtIndex:current] play];
    current = (current + 1) % [sounds count];
}

- (void) stop
{
    [[sounds objectAtIndex:current] stop];
}

- (void) setGain: (float) val
{
    for (Sound *sound in sounds)
        [sound setGain:val];
}

- (float) gain
{
    return [[sounds lastObject] gain];
}

@end
