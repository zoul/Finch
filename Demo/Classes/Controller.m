#import "Controller.h"
#import "Finch.h"
#import "Sound.h"
#import "RevolverSound.h"
#import <unistd.h>

static const int kBulletRounds = 4;

@interface Controller ()
@property(retain) Finch *engine;
@property(retain) Sound *sitar;
@property(retain) RevolverSound *gun;
@end

@implementation Controller
@synthesize engine, sitar, gun;

- (NSURL*) soundURLForName: (NSString*) soundName
{
    return [[NSBundle mainBundle] URLForResource:soundName withExtension:@"wav"];
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    engine = [[Finch alloc] init];
    sitar = [[Sound alloc] initWithFile:[self soundURLForName:@"sitar"]];
    NSLog(@"Loaded sitar sound, %2.2f seconds.", [sitar duration]);
    gun = [[RevolverSound alloc] initWithFile:[self soundURLForName:@"shot"] rounds:kBulletRounds];
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

- (IBAction) makeGoodSound: (id) sender
{
    NSLog(@"Playing good sound.");
    [sitar play];
}

- (IBAction) makeBadSound: (id) sender
{
    NSLog(@"Playing bad sound.");
    for (int i=0; i<kBulletRounds; i++) {
        [gun play];
        usleep(80000);
    }
}

- (IBAction) updateSitarPitchFrom: (id) sender
{
    sitar.pitch = [(UISlider*) sender value];
}

@end
