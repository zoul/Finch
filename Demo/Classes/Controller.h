@class Finch, Sound;

@interface Controller : UIViewController
{
    Finch *engine;
    Sound *sample;
}

- (void) makeSound: (id) sender;

@end

