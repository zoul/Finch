#import "FIRevolverSound.h"
#import "FISound.h"

@interface FIRevolverSound ()
@property(strong) NSArray *voices;
@property(assign) NSUInteger current;
@end

@implementation FIRevolverSound {
    NSUInteger playingSound;
}
@synthesize voices, current;

- (id) initWithVoices: (NSArray*) newVoices
{
    self = [super init];
    [self setVoices:newVoices];
    return self;
}

#pragma mark Sound Controls

- (void) play
{
    playingSound = current;
    [(FISound*) [voices objectAtIndex:current] play];
    current = (current + 1) % [voices count];
}

- (void) stop
{
    [[voices objectAtIndex:playingSound] stop];
}

#pragma mark Sound Properties

- (void) forwardInvocation: (NSInvocation*) invocation
{
    for (FISound *voice in voices)
        [invocation invokeWithTarget:voice];
}

- (NSMethodSignature*) methodSignatureForSelector: (SEL) selector
{
    NSMethodSignature *our = [super methodSignatureForSelector:selector];
    NSMethodSignature *voiced = [[voices lastObject] methodSignatureForSelector:selector];
    return our ? our : voiced;
}

@end
