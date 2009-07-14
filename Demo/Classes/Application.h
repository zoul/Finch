@class Controller;

@interface Application : NSObject <UIApplicationDelegate>
{
    UIWindow *window;
    Controller *controller;
}

@property(retain) IBOutlet UIWindow *window;
@property(retain) IBOutlet Controller *controller;

@end

