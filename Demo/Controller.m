#import "Controller.h"
#import "FISoundEngine.h"
#import "FISound.h"
#import "FIRevolverSound.h"
#import <unistd.h>

static const int kBulletRounds = 4;

@interface Controller ()
@property(retain) FISoundEngine *engine;
@property(retain) FISound *sitar;
@property(retain) FIRevolverSound *gun;
@end

@implementation Controller
@synthesize engine, sitar, gun;

- (NSURL*) soundURLForName: (NSString*) soundName
{
    return [[NSBundle mainBundle] URLForResource:soundName withExtension:@"wav"];
}

- (void) openAudioSession
{
    NSError *error = nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    NSAssert(error == nil, @"Failed to set audio session category.");
    [session setActive:YES error:&error];
    NSAssert(error == nil, @"Failed to activate audio session.");
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self openAudioSession];
    engine = [[FISoundEngine alloc] init];
    sitar = [[FISound alloc] initWithFile:[self soundURLForName:@"sitar"]];
    NSLog(@"Loaded sitar sound, %2.2f seconds.", [sitar duration]);
    gun = [[FIRevolverSound alloc] initWithFile:[self soundURLForName:@"shot"] rounds:kBulletRounds];
    NSLog(@"Loaded revolver sound.");
}

- (void) dealloc
{
    [engine release];
    [sitar release];
    [gun release];
    [super dealloc];
}

#pragma mark Actions

- (IBAction) makeGoodSound
{
    NSLog(@"Playing good sound.");
    [sitar play];
}

- (IBAction) makeBadSound
{
    NSLog(@"Playing bad sound.");
    for (int i=0; i<kBulletRounds; i++) {
        [gun play];
        usleep(80000);
    }
}

- (IBAction) updateSitarPitchFrom: (UISlider*) slider
{
    [sitar setPitch:[slider value]];
}

@end