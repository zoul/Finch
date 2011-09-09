@class FISound, FIRevolverSound;

@interface Controller : UIViewController

@property(retain) FISound *sitarSound;
@property(retain) FIRevolverSound *gunSound;

- (IBAction) makeGoodSound;
- (IBAction) makeBadSound;
- (IBAction) updateSitarPitchFrom: (UISlider*) slider;

@end

