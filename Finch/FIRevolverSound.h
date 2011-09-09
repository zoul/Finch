@interface FIRevolverSound : NSObject

@property(assign) float gain;

- (id) initWithSounds: (NSArray*) sounds;

- (void) play;
- (void) stop;

@end
