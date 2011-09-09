#import "FIFactory.h"
#import "FISoundEngine.h"
#import "FISoundSample.h"
#import "FIRevolverSound.h"
#import "FIPCMDecoder.h"
#import "FISound.h"

@implementation FIFactory
@synthesize logger, soundDecoders, soundBundle;

#pragma mark Private Components

- (NSSet*) buildDefaultSoundDecoders
{
    FIPCMDecoder *decoder = [[FIPCMDecoder alloc] init];
    return [NSSet setWithObject:[decoder autorelease]];
}

- (id <FISoundDecoder>) decoderForFileAtPath: (NSString*) path
{
    for (id <FISoundDecoder> decoder in soundDecoders)
        for (NSString *extension in [decoder supportedFileExtensions])
            if ([path hasSuffix:extension])
                return decoder;
    return nil;
}

#pragma mark Public Components

- (FISoundEngine*) buildSoundEngine
{
    FISoundEngine *engine = [[FISoundEngine alloc] init];
    [engine setLogger:logger];
    return [engine autorelease];
}

- (FISound*) buildSoundNamed: (NSString*) soundName
{
    NSString *path = [soundBundle pathForResource:soundName ofType:nil];
    id <FISoundDecoder> decoder = [self decoderForFileAtPath:path];
    FISoundSample *decodedSound = [decoder decodeFileAtPath:path error:NULL];
    FISound *sound = [[FISound alloc] initWithSample:decodedSound error:NULL];
    return [sound autorelease]; 
}

- (FISound*) buildSoundNamed: (NSString*) soundName maxPolyphony: (NSUInteger) voices
{
    NSMutableArray *sounds = [NSMutableArray array];
    for (NSUInteger i=0; i<voices; i++)
        [sounds addObject:[self buildSoundNamed:soundName]];
    return (id) [[[FIRevolverSound alloc] initWithVoices:sounds] autorelease];
}

#pragma mark Initalization

- (id) init
{
    self = [super init];
    [self setLogger:FILoggerNull];
    [self setSoundDecoders:[self buildDefaultSoundDecoders]];
    [self setSoundBundle:[NSBundle mainBundle]];
    return self;
}

- (void) dealloc
{
    [soundBundle release];
    [soundDecoders release];
    [logger release];
    [super dealloc];
}

@end
