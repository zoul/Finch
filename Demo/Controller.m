#import "Controller.h"
#import "FISound.h"

@implementation Controller
@synthesize sitarSound, gunSound;

- (IBAction) playSitarSound
{
    [sitarSound play];
}

- (IBAction) playGunSound
{
    for (int i=0; i<4; i++) {
        [gunSound play];
        usleep(80000);
    }
}

- (IBAction) updateSoundPitchFrom: (UISlider*) slider
{
    sitarSound.pitch = gunSound.pitch = slider.value;
}

@end