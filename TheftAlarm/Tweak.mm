#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import <objc/runtime.h>
#import <libactivator/libactivator.h>
#import <AVFoundation/AVFoundation.h>

#define ALARM_PATH @"/var/mobile/Library/TheftAlarm/alarm.caf"

static BOOL Enabled=NO;
AVAudioPlayer *audioPlayer;

%hook SBUIController

-(void)ACPowerChanged
{
    if (Enabled)
    {
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:ALARM_PATH]];
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        audioPlayer.numberOfLoops = 200;
        [audioPlayer play];
        Enabled=NO;
        
    } else if (audioPlayer != nil) 
    {
        if (audioPlayer.playing)
        {
            [audioPlayer stop];
            [audioPlayer release];
        }
    }
    
    %orig;
}

%end

@interface ToggleAlarm : NSObject<LAListener> 
{} 
@end

@implementation ToggleAlarm

-(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
    Enabled = !Enabled;
    
    NSLog(@"Alarm Toggled");
    
    if (audioPlayer != nil)
    {
        if (audioPlayer.playing)
        {
            [audioPlayer stop];
            [audioPlayer release];
        }
    }
}


+(void)load
{
    if (![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"]) {return;}
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	[[LAActivator sharedInstance] registerListener:[self new] forName:@"com.filippobiga.theftalarm"];
	[p release];
}

@end 

%ctor
{
    if (![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"]){return;}
}
