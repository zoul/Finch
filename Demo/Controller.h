@class FISound, FIRevolverSound;

@interface Controller : UIViewController

@property(retain) FISound *sitarSound;
@property(retain) FISound *gunSound;

- (IBAction) playSitarSound;
- (IBAction) playGunSound;
- (IBAction) updateSoundPitchFrom: (UISlider*) slider;

@end

