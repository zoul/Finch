@class Controller;

@interface Application : NSObject <UIApplicationDelegate>

@property(retain, nonatomic) IBOutlet UIWindow *window;
@property(retain, nonatomic) IBOutlet Controller *controller;

@end

