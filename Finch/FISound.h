@interface FISound : NSObject

@property(assign, readonly) BOOL isPlaying;

@property(assign, nonatomic) BOOL loop;
@property(assign, nonatomic) float gain;
@property(assign, nonatomic) float pitch;
@property(assign, readonly) NSTimeInterval duration;

@property(assign, nonatomic) NSTimeInterval lastPlayTime;
@property(assign, nonatomic) float cacheDuration;

- (id) initWithPath: (NSString*) path andName: (NSString *) name maxPolyphony: (NSUInteger) voices error: (NSError**) error;
- (id) initWithPath: (NSString*) path andName: (NSString *) name error: (NSError**) error;

- (void) play;
- (void) stop;

@end
