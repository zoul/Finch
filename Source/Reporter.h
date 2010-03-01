@interface Reporter : NSObject
{
    NSString *domain;
}

- (id) initWithDomain: (NSString*) errDomain error: (NSError**) error;
+ (id) forDomain: (NSString*) errDomain error: (NSError**) error;

- (NSError*) errorWithCode: (int) code;
- (NSError*) errorWithCode: (int) code description: (NSString*) msg;

@end
