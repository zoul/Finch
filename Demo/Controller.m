#import "Controller.h"
#import "FISound.h"

@implementation Controller

- (IBAction) playSound
{
    [_sound play];
}

- (IBAction) updateSoundPitchFrom: (UISlider*) slider
{
    NSLog(@"Setting pitch to %0.2f.", [slider value]);
    [_sound setPitch:[slider value]];
}

@end