#import <UIKit/UIKit.h>

static UIBarButtonItem *cachedButton=nil;
static UIBarButtonItem *origButton=nil;
static BOOL locked=YES;

%hook CKConversationListController

%new(:@@)
-(void)toggle
{
    locked=!locked;
    [self setEditing:NO animated:YES];
    [self loadView];    
}


-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    %orig;
    if(editing) 
    {
        if(!cachedButton) 
        {
            origButton=[[self navigationItem].rightBarButtonItem retain];
            
            cachedButton=[[UIBarButtonItem alloc] initWithTitle:@"Unlock" style:UIBarButtonItemStylePlain target:self action:@selector(toggle)];
        } else 
        {
            cachedButton.title = (locked) ? @"Unlock" : @"Lock";
        }
        
        [[self navigationItem] setRightBarButtonItem:cachedButton animated:YES];
    } 
    else 
    {
        [[self navigationItem] setRightBarButtonItem:origButton animated:YES];
    }
}

-(int)tableView:(id)view numberOfRowsInSection:(int)section
{
    if (locked) { return 0; }
    return %orig;
}

-(void)composeButtonClicked:(id)clicked
{
    if (locked) { return; }
    %orig;
}
%end

