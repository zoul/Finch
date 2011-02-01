@class Controller;

@interface Application : NSObject <UIApplicationDelegate> {}

@property(retain) IBOutlet UIWindow *window;
@property(retain) IBOutlet Controller *controller;

@end

