@interface FISound : NSObject

@property(assign, readonly) BOOL isPlaying;

@property(assign, nonatomic) BOOL loop;
@property(assign, nonatomic) float gain;
@property(assign, nonatomic) float pitch;
@property(assign, readonly) NSTimeInterval duration;

- (id) initWithPath: (NSString*) path maxPolyphony: (NSUInteger) voices error: (NSError**) error;
- (id) initWithPath: (NSString*) path error: (NSError**) error;

- (void) play;
- (void) stop;

@end
