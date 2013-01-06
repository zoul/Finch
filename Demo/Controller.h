@class FISound;

@interface Controller : UIViewController

@property(strong) FISound *sound;

- (IBAction) playSound;
- (IBAction) updateSoundPitchFrom: (UISlider*) slider;

@end

