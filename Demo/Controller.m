#import "Controller.h"
#import "FISound.h"
#import "FIRevolverSound.h"
#import <unistd.h>

@implementation Controller
@synthesize sitarSound, gunSound;

- (void) dealloc
{
    [sitarSound release];
    [gunSound release];
    [super dealloc];
}

#pragma mark Actions

- (IBAction) makeGoodSound
{
    [sitarSound play];
}

- (IBAction) makeBadSound
{
    for (int i=0; i<4; i++) {
        [gunSound play];
        usleep(80000);
    }
}

- (IBAction) updateSitarPitchFrom: (UISlider*) slider
{
    [sitarSound setPitch:[slider value]];
}

@end