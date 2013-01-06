@class FISoundDevice;

@interface FISoundContext : NSObject

@property(assign, readonly) ALCcontext *handle;
@property(strong, readonly) FISoundDevice *device;
@property(assign, nonatomic, getter = isCurrent) BOOL current;
@property(assign, nonatomic, getter = isSuspended) BOOL suspended;

- (id) initWithDevice: (FISoundDevice*) device error: (NSError**) error;
+ (id) contextForDevice: (FISoundDevice*) device error: (NSError**) error;

@end
