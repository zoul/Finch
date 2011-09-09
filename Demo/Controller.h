@class FISound, FIRevolverSound;

@interface Controller : UIViewController

@property(retain) FISound *sitarSound;
@property(retain) FIRevolverSound *gunSound;

- (IBAction) playSitarSound;
- (IBAction) playGunSound;
- (IBAction) updateSitarPitchFrom: (UISlider*) slider;

@end

