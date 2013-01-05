@class FISoundContext;

@interface FITestCase : SenTestCase

@property(strong, readonly) FISoundContext *soundContext;
@property(strong, readonly) NSBundle *soundBundle;

@end
