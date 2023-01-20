//First tweak that I created 
#import <UIKit/UIKit.h>
#import <spawn.h>
#import <Foundation/Foundation.h>
#include <SpringBoard/SpringBoard.h>


#define kSettingsPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/PreferenceLoader/Preferences/toldyoupreferences.plist"]

static NSString *nsDomainString = @"com.huseyin.toldyoupreferences";
static NSString *nsNotificationString = @"com.huseyinkabasakal.toldyoupreferences/preferences.changed";

// declare switch and string

static NSString *CustomTitle = @"";
static NSString *CustomButton = @"";
static NSString *CustomMessage = @"";
static NSString *CustomSpeech = @"";
NSMutableDictionary *prefs = nil;

@interface SBBrightnessController : NSObject
	+(id)sharedBrightnessController;
	-(void)setBrightnessLevel:(float)arg1;
@end
@interface NSUserDefaults (CnonPrefs)

    -(id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
    -(void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    
    NSString *eCustomTitle = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"CustomTitle" inDomain:nsDomainString];
    NSString *eCustomButton = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"CustomButton" inDomain:nsDomainString];
    NSString *eCustomMessage = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"CustomMessage" inDomain:nsDomainString];
    NSString *eCustomSpeech = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"CustomSpeech" inDomain:nsDomainString];
    
    CustomTitle = eCustomTitle;
    CustomButton = eCustomButton;
    CustomMessage = eCustomMessage;
    CustomSpeech = eCustomSpeech;

}

void onceConstructor() {
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
}

//Uses tweak "say", just runs a command line
void say(){
   
    NSStringEncoding stringEncoding = NSUTF8StringEncoding;
NSString *anan = CustomSpeech;
const char *anan2 = [anan cStringUsingEncoding:stringEncoding];

    pid_t pid;
int status;
const char* args[] = {"say", anan2, NULL};
posix_spawn(&pid, "/usr/bin/say", NULL, NULL, (char*   const*)args, NULL);
waitpid(pid, &status, WEXITED);//wait untill the process completes   (only if you need to do that)
}
void alert(){
    /*UIAlertView *alert = [[UIAlertView alloc] 
                initWithTitle:CustomTitle 
                message:CustomMessage
                delegate:nil 
                cancelButtonTitle:CustomButton
                otherButtonTitles:nil];
            [alert show];*/

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"title" message:@"message" preferredStyle:UIAlertControllerStyleAlert];

      UIAlertAction *button = [UIAlertAction actionWithTitle:@"Button" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      }];

   [alert addAction:button];
   
}

%hook SBFUserAuthenticationController

-(long long)_evaluatePasscodeAttempt:(id)arg1 outError:(id*)arg2 {

    long long ret = %orig;
    
    
	
    NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults]
    persistentDomainForName:@"com.huseyin.toldyoupreferences"];

    id isEnabledPic = [bundleDefaults valueForKey:@"isEnabledPic"];
    id isEnabledAlert = [bundleDefaults valueForKey:@"isEnabledAlert"];
    id isEnabledSay = [bundleDefaults valueForKey:@"isEnabledSay"];

    
    if (ret != 2) {
        //Display image
        if([isEnabledPic isEqual:@1]){
            UIImage *bobImage = [UIImage imageWithContentsOfFile:@"/var/mobile/Library/ToldYou/GotYou.PNG"];
            UIImageView *bobImageView = [[UIImageView alloc] initWithImage:bobImage];
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            CGFloat screenHeight = screenRect.size.height;
            [bobImageView setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
            [[[UIApplication sharedApplication] keyWindow] addSubview:bobImageView];

            
            
           bobImageView.alpha = 1.0;
           
            
                        [UIView animateWithDuration:5.00 animations:^{
                            bobImageView.alpha = 1.0;
                [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
                [UIView setAnimationBeginsFromCurrentState:YES];
                bobImageView.alpha = 0.0;
            } completion:^(BOOL finished){
            }];
            
        }
        if([isEnabledAlert isEqual:@1]){
        //I know its deprecated duh !
        //UIAlertController does not work for some reason
        
        alert();
        
        }

        if([isEnabledSay isEqual:@1]){
            say();
        }
        
    }
    return ret;   
}




%end

%ctor {
	// prefs changed listener
    notificationCallback(NULL, NULL, NULL, NULL, NULL);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);

    onceConstructor();
    //Create the folder
    NSString* faceidpicPath = @"/var/mobile/Library/";
	NSString *folderName = [faceidpicPath stringByAppendingPathComponent:@"ToldYou"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error = nil;
		if (![fileManager fileExistsAtPath:folderName]){
    		[fileManager createDirectoryAtPath:folderName
           					withIntermediateDirectories:YES
                            attributes:nil
                            error:&error];
        }

}