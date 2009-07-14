#import "Controller.h"
#import "Finch.h"
#import "Sound+IO.h"

@implementation Controller

- (void) awakeFromNib
{
    [super awakeFromNib];
    engine = [[Finch alloc] init];
    NSString *const path = [[[NSBundle mainBundle] resourcePath]
        stringByAppendingPathComponent:@"sitar.wav"];
    sample = [[Sound alloc] initWithFile:path];
}

- (void) makeSound: (id) sender
{
    NSLog(@"Playing sound.");
    [sample play];
}

- (void) dealloc
{
    [engine release];
    [sample release];
    [super dealloc];
}

@end
