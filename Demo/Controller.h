@class FISound, FIRevolverSound;

@interface Controller : UIViewController

@property(strong) FISound *sitarSound;
@property(strong) FISound *gunSound;

- (IBAction) playSitarSound;
- (IBAction) playGunSound;
- (IBAction) updateSoundPitchFrom: (UISlider*) slider;

@end

