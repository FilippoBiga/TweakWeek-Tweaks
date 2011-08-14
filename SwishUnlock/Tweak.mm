#import <UIKit/UIKit.h>

@interface SBAwayLockBar : UIView
-(UIView *)knob;
-(void)unlock;
@end


static BOOL unlock;
static float slide;


%hook SBAwayLockBar

-(void)slideBack:(BOOL)back
{
    %orig(NO);
}

-(void)knobDragged:(float)dragged
{
    %log;
    slide=dragged;
    
    if (dragged == 1.0f)
    { 
        
        unlock=YES;
        
        [[self knob] setTransform:CGAffineTransformMakeScale(-1,1)];
        
        return; 
    }
    
    %orig; 
    
    if (unlock && dragged == 0.0f) 
    {
        
        [[self knob] setTransform:CGAffineTransformMakeScale(1,-1)];
        
        [self unlock];
        unlock=NO;
    }
}

-(void)unlock
{
    %log;
    if (!unlock || slide != 0.0f) { return; }
    %orig;    
}


-(void)freezeKnobInUnlockedPosition{}

%end