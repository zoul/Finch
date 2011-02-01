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

- (void) presentError: (NSError*) error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
        message:[error localizedDescription] delegate:nil
        cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    engine = [[Finch alloc] init];
    sitar = [[Sound alloc] initWithFile:
        [[NSBundle mainBundle] URLForResource:@"sitar" withExtension:@"wav"]];
    NSLog(@"Loaded sitar sound, %2.2f seconds.", sitar.duration);
    gun = [[RevolverSound alloc] initWithFile:
        [[NSBundle mainBundle] URLForResource:@"shot" withExtension:@"wav"]
        rounds:kBulletRounds];
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
