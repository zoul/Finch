#import "FIRevolverSound.h"
#import "FISound.h"

@interface FIRevolverSound ()
@property(retain) NSMutableArray *sounds;
@property(assign) NSUInteger current;
@end

@implementation FIRevolverSound
@synthesize sounds, current;

- (id) initWithFile: (NSURL*) fileURL rounds: (int) max
{
    [super init];
    sounds = [[NSMutableArray alloc] init];
    for (int i=0; i<max; i++)
    {
        FISound *const sample = [[FISound alloc] initWithFile:fileURL];
        if (!sample)
            return nil;
        [sounds addObject:sample];
        [sample release];
    }
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
