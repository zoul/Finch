#import "Controller.h"
#import "Finch.h"
#import "Sound.h"
#import "RevolverSound.h"

#define RSRC(x) [[NSBundle mainBundle] pathForResource:x ofType:nil]
static const int kBulletRounds = 4;

@implementation Controller

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
    sitar = [[Sound alloc] initWithFile:RSRC(@"sitar.wav")];
    NSLog(@"Loaded sitar sound, %2.2f seconds.", sitar.duration);
    gun = [[RevolverSound alloc] initWithFile:RSRC(@"shot.wav") rounds:kBulletRounds];
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
