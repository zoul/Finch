/*
    A simple macro to safely initialize the NSError**
    variable passed to various methods. Discussion here:
    http://google.com/search?q=should+method+set+nserror
*/

#define INIT_ERROR(_e) \
    NSError* _dummyError; \
    if (_e == NULL) \
        _e = &_dummyError;

@interface Reporter : NSObject
{
    NSString *domain;
}

- (id) initWithDomain: (NSString*) errDomain;
+ (id) forDomain: (NSString*) errDomain;

- (NSError*) errorWithCode: (int) code;
- (NSError*) errorWithCode: (int) code description: (NSString*) msg;

@end
