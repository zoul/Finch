#import "FIFactory.h"
#import "FISoundEngine.h"
#import "FIRevolverSound.h"
#import "FISample.h"
#import "FIDecoder.h"
#import "FISound.h"

@interface FIFactory ()
@property(strong) FIDecoder *decoder;
@end

@implementation FIFactory
@synthesize logger, soundBundle, decoder;

#pragma mark Public Components

- (FISoundEngine*) buildSoundEngine
{
    FISoundEngine *engine = [[FISoundEngine alloc] init];
    [engine setLogger:logger];
    return engine;
}

- (FISound*) loadSoundNamed: (NSString*) soundName
{
    NSString *path = [soundBundle pathForResource:soundName ofType:nil];
    if (!path) {
        return nil;
    }
    FISample *sample = [decoder decodeSampleAtPath:path error:NULL];
    return [[FISound alloc] initWithSample:sample error:NULL];
}

- (FISound*) loadSoundNamed: (NSString*) soundName maxPolyphony: (NSUInteger) voices
{
    NSMutableArray *sounds = [NSMutableArray array];
    for (NSUInteger i=0; i<voices; i++) {
        FISound *voice = [self loadSoundNamed:soundName];
        if (voice == nil)
            return nil;
        [sounds addObject:voice];
    }
    return (id) [[FIRevolverSound alloc] initWithVoices:sounds];
}

#pragma mark Initalization

- (id) init
{
    self = [super init];
    [self setLogger:FILoggerNull];
    [self setSoundBundle:[NSBundle mainBundle]];
    [self setDecoder:[[FIDecoder alloc] init]];
    return self;
}

@end
