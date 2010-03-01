#import "Controller.h"
#import "Finch.h"
#import "Sound.h"

@implementation Controller

- (void) presentError: (NSError*) error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
        message:[error localizedDescription] delegate:nil
        cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    engine = [[Finch alloc] init];
    NSString *const path = [[[NSBundle mainBundle] resourcePath]
        stringByAppendingPathComponent:@"sitar.wav"];
    NSError *error = nil;
    sample = [[Sound alloc] initWithFile:path error:&error];
    if (!sample)
        [self presentError:error];
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
