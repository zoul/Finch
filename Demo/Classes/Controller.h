@class Finch, Sound, RevolverSound;

@interface Controller : UIViewController
{
    Finch *engine;
    Sound *sitar;
    RevolverSound *gun;
}

- (IBAction) makeGoodSound: (id) sender;
- (IBAction) makeBadSound: (id) sender;
- (IBAction) updateSitarPitchFrom: (id) sender;

@end

